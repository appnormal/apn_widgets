# apn_widgets

A set of usefull widgets used in Appnormal projects

## Available widgets


* PrimaryButton: A simple button with a `isLoading` flag to set a platform aware loading indicator
* PlatformButton: A simple platform aware button
* AppbarAction: A simple button for in a AppBar
* RefreshableDataList: List with out of the box pull to refresh & infinite loading. To be used together with `apn_state` and `apn_http` packages
* DialogPresenter: A inherited widget to put in the top of your widget tree to easily handle presenting and queuing platform aware dialogs.
* PinInput: A container for handling pincode inputs with full control over the pin onput design via the builder pattern
* PlatformAlertDialog: Platform aware dialog Widget
* PlatformPullToRefresh: Platform aware p2r for Lists and Grids.
* SearchBar: A simple search bar widget with clear input icon.
* TappableOverlay: A platform aware multipurpose Widget to easily make a widget clickable, pressed color for iOS native look and feel and Inkwell for Android native look and feel.

## Available extensions

* Color.lighten(double fraction): Make a color lighter by the given fraction
* Color.darken(double fraction): Make a color darker by the given fraction
* Iterable.merge(): Merge e.g. a [[""], [""]] to be a ["", ""].
* Iterable.unique(): Purge duplicate entries from a list
* Iterable.separated(Widget widget): Add a given widget in between all the elements in the list (usefull for gaps and dividers)
* String.ucFirst: Make the first item of a String uppercase
* DateTime.format(String pattern): Shortcut to Intl DateFormat
* DateTime.formatIso(): Format a DateTime to the accepted ISO format with tz
* DateTime.formatTz(): Get the timezone offset (e.g. +0200 or -0800)