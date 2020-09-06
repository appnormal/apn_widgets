import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
    @required this.controller,
    @required this.onFieldSubmitted,
    @required this.onSearchCleared,
    this.hintText,
    this.hintStyle,
    this.padding,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final VoidCallback onSearchCleared;
  final String hintText;
  final TextStyle hintStyle;
  final EdgeInsets padding;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() => showClearIcon = widget.controller.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63.0,
      padding: widget.padding ?? EdgeInsets.only(left: 20.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('lib/assets/ic_search.png', package: 'apn_widgets'),
          SizedBox(width: 15.0),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[200],
                      fontWeight: FontWeight.w600,
                    ),
                suffixIcon: showClearIcon
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          onPressed: widget.onSearchCleared,
                          icon: Icon(
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? SFSymbols.xmark_circle_fill
                                  : Icons.clear,
                              color: Colors.grey[200]),
                        ),
                      )
                    : null,
              ),
              cursorColor: Colors.blueAccent,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              controller: widget.controller,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
