import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class ListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Lists Page',
      child: _ListsPageBody(),
    );
  }
}

class _ListsPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            child: Text('Pull to refresh'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _PullToRefreshList())),
          ),
          FlatButton(
            child: Text('Data list'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _DataList())),
          ),
        ],
      ),
    );
  }
}

class _PullToRefreshList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull to refresh'),
      ),
      body: Center(
        child: PlatformPullToRefresh(
          itemCount: 5,
          onRefresh: () => {},
          itemBuilder: (BuildContext context, int index) => Container(child: Text('ITEM')),
        ),
      ),
    );
  }
}

class _DataList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var counter = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull to refresh'),
      ),
      body: Center(
        child: DataList(
          listBuilder: (items) {
            counter++;
            return items[counter];
          },
          data: [
            Text('ITEM'),
            Text('ITEM'),
            Text('ITEM'),
            Text('ITEM'),
            Text('ITEM'),
          ],
        ),
      ),
    );
  }
}
