import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.title = '',

    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String title;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/icons/home-icon.png',
      selectedImagePath: 'assets/icons/home-icon.png',
      title: "الرئيسية",

      index: 3,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/cat-icon.png',
      selectedImagePath: 'assets/icons/cat-icon.png',
      index: 2,
      title: "الأقسام",

      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/order-icon.png',
      selectedImagePath: 'assets/icons/order-icon.png',
      index: 1,
      title: "الطلبات",

      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/user-icon.png',
      selectedImagePath: 'assets/icons/user-icon.png',
      index: 0,
      title: "حسابي",

      isSelected: true,
      animationController: null,
    ),

  ];
}
