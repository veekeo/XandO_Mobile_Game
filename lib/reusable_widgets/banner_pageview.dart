// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:xando/banner_pageview_list.dart';
// import 'package:xando/models/home_screen_model.dart';
import 'package:xando/reusable_widgets/banner.dart';

class BannerPageViewBuilder extends StatefulWidget {
  @override
  State<BannerPageViewBuilder> createState() => _BannerPageViewBuilderState();
}

class _BannerPageViewBuilderState extends State<BannerPageViewBuilder> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages =
      3; // Change this to the number of pages in your PageView
  final int _autoScrollInterval =
      3; // Change this to the desired auto-scroll interval in seconds

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(Duration(seconds: _autoScrollInterval), () {
      if (_currentPage < _numPages - 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
      _startAutoScroll(); // Recursive call for continuous auto-scrolling
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: bannerPageViewList.length,
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return HomeBanner(
          title: bannerPageViewList[index].title,
          body: bannerPageViewList[index].body,
          icon: bannerPageViewList[index].icon,
          backgroundColor: bannerPageViewList[index].backgroundColor,
          textColor: bannerPageViewList[index].textColor,
        );
      },
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
