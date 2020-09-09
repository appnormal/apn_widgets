import 'package:apn_http/apn_http.dart';
import 'package:apn_widgets/apn_widgets.dart';
import 'package:flutter/material.dart';

class DataList<T extends Object> extends StatelessWidget {
  final bool isLoading;
  final List<T> data;
  final Widget loading;
  final Widget placeholder;
  final ListBuilder<T> listBuilder;
  final Color listBackgroundColor;

  const DataList({
    Key key,
    @required this.listBuilder,
    @required this.data,
    this.loading,
    this.placeholder,
    this.isLoading = false,
    this.listBackgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // * Return loading is we are loading
    if (isLoading) return loading ?? Center(child: PlatformLoader());

    // * If we have no list and are not loading, show the placeholder
    final length = data?.length ?? 0;
    if (length == 0) return placeholder ?? Container();

    // * We got some data, and make the list
    return Container(
      color: listBackgroundColor,
      child: listBuilder(data ?? []),
    );
  }
}

class RefreshableDataList<T extends ApiBaseState, V> extends StatelessWidget {
  final ApiBaseState<V> state;

  final Widget loading;
  final Widget placeholder;

  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;

  final EdgeInsetsGeometry padding;

  final int gridCrossAxisCount;
  final double gridCrossAxisSpacing;
  final double gridMainAxisSpacing;
  final double gridChildAspectRatio;

  final ValueSetter<ErrorResponse> onError;

  const RefreshableDataList({
    Key key,
    @required this.state,
    @required this.itemBuilder,
    this.separatorBuilder,
    this.loading,
    this.placeholder,
    this.padding,
    this.gridCrossAxisCount = 1,
    this.gridCrossAxisSpacing,
    this.gridMainAxisSpacing,
    this.gridChildAspectRatio,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onNextPage = ({int page = 1}) async {
      if ((state.hasMorePages && !state.isLoading) || page == 1) {
        var newState = await state.dispatchLoadNewPage(page: page);
        if (newState.hasError && onError != null) onError(newState.error);
      }
    };

    var refreshablePlaceholder = TappableOverlay(
      onTap: onNextPage,
      child: placeholder,
      highlightColor: Color(0xFFD9E5F4),
      pressedColor: Colors.white.withOpacity(0.1),
    );

    return DataList<V>(
      data: state.data,
      placeholder: refreshablePlaceholder,
      loading: loading,
      isLoading: state.isLoadingFirstData,
      listBuilder: (items) {
        return PlatformPullToRefresh(
          itemCount: items.length,
          itemBuilder: itemBuilder,
          separatorBuilder: separatorBuilder,
          onRefresh: onNextPage,
          hasMorePages: state.hasMorePages,
          onPageEndReached: () => onNextPage(page: state.paginationInfo.currentPage + 1),
          padding: padding,
          gridCrossAxisCount: gridCrossAxisCount,
          gridCrossAxisSpacing: gridCrossAxisSpacing,
          gridMainAxisSpacing: gridMainAxisSpacing,
          gridChildAspectRatio: gridChildAspectRatio,
        );
      },
    );
  }
}

typedef ListBuilder<T> = Widget Function(List<T> items);
