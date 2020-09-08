import 'package:apn_analytics/apn_analytics.dart';
import 'package:apn_widgets/apn_widgets.dart';
import 'package:flutter/material.dart';

const kTabHeight = 56.0;

class BaseTabsPage extends StatefulWidget {
  const BaseTabsPage({
    this.tabs,
    this.decoration,
    this.startTabIndex,
    this.tabLabelStyle,
    this.unselectedColor = Colors.black,
    this.selectedColor,
    this.height = kTabHeight,
  });

  final int startTabIndex;
  final double height;
  final List<TabItem> tabs;
  final BoxDecoration decoration;
  final TextStyle tabLabelStyle;
  final Color unselectedColor;
  final Color selectedColor;

  @override
  _BaseTabsPageState createState() => _BaseTabsPageState();
}

class _BaseTabsPageState extends State<BaseTabsPage> {
  int _currentTab;
  List<TabItem> _tabContent;

  @override
  void initState() {
    super.initState();

    _currentTab = widget.startTabIndex ?? 0;

    _tabContent = widget.tabs;
    _tabContent.asMap().entries.forEach((entry) => entry.value.index = entry.key);

    _trackCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: _tabContent
            .map((tab) => Offstage(
                  offstage: tab.index != _currentTab,
                  child: tab.content,
                ))
            .toList(),
      ),
      bottomNavigationBar: TabBar(
        height: widget.height,
        decoration: widget.decoration,
        onTap: (selectedTab) {
          setState(() => _currentTab = selectedTab);
          _trackCurrentScreen();
        },
        items: _tabContent.asMap().entries.map((entry) {
          final unselectedColor = widget.unselectedColor;
          final selectedColor = widget.selectedColor ?? Theme.of(context).primaryColor;
          final isActive = entry.key == _currentTab;

          return TabBarItem(
            tabIndex: entry.key,
            icon: Image.asset(entry.value.icon, color: isActive ? selectedColor : unselectedColor),
            isActive: isActive,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            label: entry.value.label,
            labelStyle: widget.tabLabelStyle,
          );
        }).toList(),
      ),
    );
  }

  void _trackCurrentScreen() {
    FirebaseAnalyticsService.instance.trackScreen(_tabContent[_currentTab].route);
  }
}

class TabBar extends StatelessWidget {
  final ValueSetter<int> onTap;
  final List<TabBarItem> items;
  final BoxDecoration decoration;
  final double height;

  const TabBar({
    Key key,
    this.onTap,
    this.items,
    this.height,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        child: Container(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.map((item) => _selectableTab(context, item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _selectableTab(BuildContext context, TabBarItem item) {
    return Expanded(
      child: TappableOverlay(
        highlightColor: Theme.of(context).accentColor.withOpacity(0.3),
        pressedColor: Colors.white,
        onTap: () => onTap(item.tabIndex),
        child: Center(child: item),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final int tabIndex;
  final Widget icon;
  final String label;
  final TextStyle labelStyle;
  final bool isActive;
  final Color unselectedColor;
  final Color selectedColor;

  const TabBarItem({
    Key key,
    @required this.tabIndex,
    @required this.icon,
    @required this.isActive,
    @required this.unselectedColor,
    @required this.selectedColor,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(context) {
    var widgets = <Widget>[
      Padding(
        padding: EdgeInsets.all(4.0),
        child: icon,
      ),
      if (label != null)
        DefaultTextStyle(
          style: TextStyle(color: isActive ? selectedColor : unselectedColor),
          child: Text(
            label,
            style: labelStyle,
            key: ValueKey('tab_label_$tabIndex'),
          ),
        ),
    ];

    return Column(
      key: ValueKey('tab_$tabIndex'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}

class TabItem {
  int index;
  final Widget content;
  final String icon;
  final String label;
  final String route;

  TabItem({
    this.icon,
    this.content,
    this.label,
    this.route,
  });
}
