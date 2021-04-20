## [2.0.4] - 20 apr 2021

* Fix bug in null safety in platform pull to refresh

## [2.0.3] - 20 apr 2021

* Add better default for specifying no highlight color in TappableOverlay

## [2.0.2] - 19 apr 2021

* Bugfix in DialogHelper

## [2.0.1] - 11 apr 2021

* Make default size for tappable overlay 2x2 pixels. So that tests can tap them before the actual child content size is determined (in de next frame)

## [2.0.0] - 10 apr 2021

* Drop `beta` pre-release

## [2.0.0-beta.2] - 18 mar 2021

* Removed the unfocus on keyboard dismiss on `PinInput` (and the related dependency).

## [2.0.0-beta] - 18 mar 2021

# BIG BREAKING UPDATE

* Null-safety enabled
* Removed depencency on apn_crashlytics and apn_http
* [BREAKING] Datalist is removed (if you want to use it, you can copy the widget from git history and use it in you project)
* [BREAKING] BaseTab page no longer automatically calls analytics but exposes an onTabActive that can be used instead
* [BREAKING] DialogHelper showError now accepts an Object instead of a ErrorResponse. toString is used to convert it into a message

## [1.1.10] - 15 mar 2021

* Complete dialog result handler on dismiss o

## [1.1.9] - 09 mar 2021

* Only pop dialog if we can pop

## [1.1.8] - 3 mar 2021

* Use builder instead of child for showDialog in dialog presenter

## [1.1.7] - 26 feb 2021

* Fix minor bug in completing active dialog

## [1.1.6] - 24 feb 2021

* Remove dialog queue in DialogPresenter (causes too many wierd bugs)

## [1.1.5] - 23 feb 2021

* Fix seperated on empty list

## [1.1.4] - 18 feb 2021

* Fix bug in TappableOverlay size calculation

## [1.1.3] - 17 nov 2020

* Allow border radius change on primary button

## [1.1.2] - 16 nov 2020

* Expand platform switch color selection

## [1.1.1] - 14 nov 2020

* Remove references to dart.io so that its easier to implement this package on web

## [1.0.23] - 13 nov 2020

* Add platform switch

## [1.0.22] - 11 nov 2020

* Add 24 hour to Android time picker

## [1.0.21] - 10 nov 2020

* Date and time picker

## [1.0.20] - 30 oct 2020

* Add image picker

## [1.0.19] - 29 oct 2020

* Made platform choices dialog choice handling uniform between platforms

## [1.0.18] - 26 oct 2020

* Add message to material choices dialog

## [1.0.17] - 15 oct 2020

* Add choices dialog

## [1.0.16] - 6 oct 2020

* Fix incorrect setState in updateStrings method of the DialogPresenter

## [1.0.15] - 3 oct 2020

* Allow update of dialog helper strings after creation (useful is localizations is initialized lower in the widget tree)

## [1.0.11] - 17 sept 2020

* Make textstyle overridable in Searchbar widget

## [1.0.10] - 17 sept 2020

* Add decoration property on Searchbar widget
* Add prefixIconColor property on Searchbar widget

## [1.0.9] - 12 sept 2020

* Add controller override to datalist
* Make pressed color on tabs more subtle
* Add tab onTabChanged parameter

## [1.0.6] - 10 sept 2020

* Allow for custom amount of pin inputs

## [1.0.5] - 9 sept 2020

* Allow pinfield items to have their own tappable styling

## [1.0.2] - 8 sept 2020

* Update dependency
* Change TappableOverlay to not render the child twice, but calculate the size of the child after the first frame

## [1.0.0] - 6 sept 2020

* First release see readme for widgets in this release
