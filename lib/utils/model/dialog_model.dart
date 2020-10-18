import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DialogModel {
  DialogType state;

  //Thuộc tính chung
  String title;
  String content;
  double fontSizeTitle;
  String urlAssetImageLogo;
  int colorTitle;
  EdgeInsetsGeometry marginRichText;
  String titleButtonFirst;
  int colorButtonFirst;
  VoidCallback voidCallbackButtonFirst;
  String titleButtonSecond;
  int colorButtonSecond;
  VoidCallback voidCallbackButtonSecond;
  List<RichTextModel> listRichText;
  int colorIcon;

  DialogModel({
      this.state,
      this.title,
      this.content,
      this.fontSizeTitle,
      this.urlAssetImageLogo,
      this.colorTitle,
      this.marginRichText,
      this.titleButtonFirst,
      this.colorButtonFirst,
      this.voidCallbackButtonFirst,
      this.titleButtonSecond,
      this.colorButtonSecond,
      this.voidCallbackButtonSecond,
      this.listRichText,
      this.colorIcon,
  });
}

enum DialogType { AUTH, INAPP }

class RichTextModel {
  String content;
  int color;
  double fontSize;
  String fontFamily;

  RichTextModel(this.content, this.color, this.fontSize, this.fontFamily);
}
//Vi du
