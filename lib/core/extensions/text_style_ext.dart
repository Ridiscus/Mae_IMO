import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

extension SourceSansProTextStyleExtensions on TextStyle {
  // Source Sans Pro
  TextStyle get sourceSansProBlack => copyWith(fontFamily: 'SourceSansPro-Black');
  TextStyle get sourceSansProBlackItalic => copyWith(fontFamily: 'SourceSansPro-Black', fontStyle: FontStyle.italic);
  TextStyle get sourceSansProBold => copyWith(fontFamily: 'SourceSansPro-Bold');
  TextStyle get sourceSansProBoldItalic => copyWith(fontFamily: 'SourceSansPro-Bold', fontStyle: FontStyle.italic);
  TextStyle get sourceSansProExtraLight => copyWith(fontFamily: 'SourceSansPro-ExtraLight');
  TextStyle get sourceSansProExtraLightItalic => copyWith(fontFamily: 'SourceSansPro-ExtraLight', fontStyle: FontStyle.italic);
  TextStyle get sourceSansProLight => copyWith(fontFamily: 'SourceSansPro-Light');
  TextStyle get sourceSansProLightItalic => copyWith(fontFamily: 'SourceSansPro-Light', fontStyle: FontStyle.italic);
  TextStyle get sourceSansProRegular => copyWith(fontFamily: 'SourceSansPro-Regular');
  TextStyle get sourceSansProItalic => copyWith(fontFamily: 'SourceSansPro-Regular', fontStyle: FontStyle.italic);
  TextStyle get sourceSansProSemiBold => copyWith(fontFamily: 'SourceSansPro-SemiBold');
  TextStyle get sourceSansProSemiBoldItalic => copyWith(fontFamily: 'SourceSansPro-SemiBold', fontStyle: FontStyle.italic);
}
