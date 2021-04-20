import 'dart:math';

import 'package:apn_widgets/apn_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

/// * Maybe use this to improve further in the future is we want to have more control
/// * over custom pull to refresh implementations on iOS and Android
class PlatformPullToRefresh extends StatefulWidget {
  final ScrollController? controller;
  final VoidCallback onRefresh;
  final int itemCount;
  final EdgeInsets? padding;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? loadMoreIndicatorBuilder;
  final VoidCallback? onPageEndReached;
  final int scrollEndReachedThreshold;
  final bool hasMorePages;

  final int gridCrossAxisCount;
  final double? gridCrossAxisSpacing;
  final double? gridMainAxisSpacing;
  final double? gridChildAspectRatio;

  const PlatformPullToRefresh({
    Key? key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.separatorBuilder,
    this.onPageEndReached,
    this.scrollEndReachedThreshold = 250,
    this.hasMorePages = false,
    this.loadMoreIndicatorBuilder,
    this.padding,
    this.gridCrossAxisCount = 1,
    this.gridCrossAxisSpacing,
    this.gridMainAxisSpacing,
    this.gridChildAspectRatio,
  }) : super(key: key);

  @override
  _PlatformPullToRefreshState createState() => _PlatformPullToRefreshState();
}

class _PlatformPullToRefreshState extends State<PlatformPullToRefresh> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController?.addListener(() {
      final pixel = _scrollController?.position.pixels ?? 0;
      final max = _scrollController?.position.maxScrollExtent ?? 1000;
      if (pixel >= max - widget.scrollEndReachedThreshold && widget.onPageEndReached != null) {
        widget.onPageEndReached!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = widget.itemCount;
    var itemBuilder = widget.itemBuilder;

    if (material.ThemeData().platform == TargetPlatform.iOS) {
      return _createForIOS(itemCount, itemBuilder);
    } else {
      return _createForAndroid(itemCount, itemBuilder);
    }
  }

  Widget _createForIOS(int itemCount, IndexedWidgetBuilder itemBuilder) {
    final platformSlivers = <Widget>[];

    platformSlivers.add(CupertinoSliverRefreshControl(
      onRefresh: () async => widget.onRefresh(),
      builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
        // * based on the framework builder, but without the arrow down icon when the refresh state is "drag"
        // * because our custom font doesn't do "arrow down icon" (also not a native thing?)
        const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Opacity(
              opacity: opacityCurve.transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
              child: PlatformLoader(),
            ),
          ),
        );
      },
    ));

    if (widget.separatorBuilder != null) {
      itemCount += (itemCount - 1);

      itemBuilder = (BuildContext context, int position) {
        var actualPosition = 0;
        if (position > 0) {
          actualPosition = (position / 2).floor();
        }

        if (position % 2 == 0) {
          return widget.itemBuilder(context, actualPosition);
        } else {
          return widget.separatorBuilder!(context, actualPosition + 1);
        }
      };
    }

    if (widget.hasMorePages) {
      itemCount += 1;
      itemBuilder = addLoadingIndicatorItemBuilder(itemCount, itemBuilder);
    }

    Widget sliverList = SliverList(
      delegate: SliverChildBuilderDelegate(
        itemBuilder, // builds the item widget
        childCount: itemCount,
      ),
    );

    if (widget.gridCrossAxisCount > 1) {
      final items = <Widget>[];
      List.filled(itemCount, null).asMap().forEach((index, _) => items.add(itemBuilder(context, index)));
      sliverList = SliverGrid.count(
        crossAxisCount: widget.gridCrossAxisCount,
        crossAxisSpacing: widget.gridCrossAxisSpacing!,
        mainAxisSpacing: widget.gridMainAxisSpacing!,
        children: items,
        childAspectRatio: widget.gridChildAspectRatio!,
      );
    }

    if (widget.padding != null) {
      sliverList = SliverPadding(padding: widget.padding!, sliver: sliverList);
    }

    // * build the items list
    platformSlivers.add(SliverSafeArea(
      top: false, // Top safe area is consumed by the navigation bar.
      sliver: sliverList,
    ));

    Widget customScrollView = CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: platformSlivers,
    );

    // * wrap the slivers in a scroll view (wrapped in a scrollbar for showing the scroll indicator)
    customScrollView = CupertinoScrollbar(child: customScrollView, controller: _scrollController);

    return customScrollView;
  }

  Widget _createForAndroid(int itemCount, IndexedWidgetBuilder itemBuilder) {
    var list;

    if (widget.hasMorePages) {
      itemCount += 1;
      itemBuilder = addLoadingIndicatorItemBuilder(itemCount, itemBuilder);
    }

    if (widget.gridCrossAxisCount > 1) {
      final items = <Widget>[];
      List.filled(itemCount, null).asMap().forEach((index, _) => items.add(itemBuilder(context, index)));

      Widget sliverGrid = SliverGrid.count(
        crossAxisCount: widget.gridCrossAxisCount,
        crossAxisSpacing: widget.gridCrossAxisSpacing!,
        mainAxisSpacing: widget.gridMainAxisSpacing!,
        children: items,
        childAspectRatio: widget.gridChildAspectRatio!,
      );
      if (widget.padding != null) {
        sliverGrid = SliverPadding(padding: widget.padding!, sliver: sliverGrid);
      }

      list = CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [sliverGrid],
      );
    } else if (widget.separatorBuilder == null) {
      list = ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: widget.padding,
        itemBuilder: itemBuilder,
      );
    } else {
      list = ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: widget.padding,
        itemBuilder: itemBuilder,
        separatorBuilder: widget.separatorBuilder!,
      );
    }

    // * To get a "free" material refresh indicator we wrap the scrollview in a refresh indicator.
    return material.RefreshIndicator(onRefresh: () async => widget.onRefresh(), child: list);
  }

  IndexedWidgetBuilder addLoadingIndicatorItemBuilder(int itemCount, IndexedWidgetBuilder itemBuilder) {
    return (BuildContext context, int position) {
      if (position == itemCount - 1) {
        return _loadingIndicator(context);
      }
      return itemBuilder(context, position);
    };
  }

  Widget _loadingIndicator(BuildContext context) {
    if (widget.loadMoreIndicatorBuilder != null) {
      return widget.loadMoreIndicatorBuilder!(context);
    }

    return Container(
      width: double.infinity,
      height: 150,
      child: Center(
        child: PlatformLoader(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }
}
