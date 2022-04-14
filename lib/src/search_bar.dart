import 'package:apn_widgets/apn_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.controller,
    required this.onFieldSubmitted,
    required this.onSearchCleared,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.decoration,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final VoidCallback onSearchCleared;
  final String? hintText;
  final String? prefixIcon;
  final String? suffixIcon;
  final BoxDecoration? decoration;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsets? padding;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showSuffixIcon = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() => showSuffixIcon = widget.controller.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63.0,
      padding: widget.padding ?? EdgeInsets.only(left: 20.0),
      decoration: widget.decoration ?? BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            widget.prefixIcon ?? 'lib/assets/ic_search.png',
            package: 'apn_widgets',
            color: widget.prefixIconColor,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isCollapsed: true,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[200],
                      fontWeight: FontWeight.w600,
                    ),
              ),
              cursorColor: Colors.blueAccent,
              style: widget.textStyle ?? TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              controller: widget.controller,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PlatformButton(
              onTap: widget.onSearchCleared,
              color: Colors.transparent,
              child: Icon(
                Theme
                    .of(context)
                    .platform == TargetPlatform.iOS ? CupertinoIcons.clear_circled_solid : Icons.clear,
                color: widget.suffixIconColor ?? Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
