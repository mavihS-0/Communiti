import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:one_for_all/screens/NGO/homeNGO.dart';
import 'package:one_for_all/screens/NGO/profileNGO.dart';

import '../../utils/constants.dart';


class NavBarNGO extends StatefulWidget {
  const NavBarNGO({Key? key}) : super(key: key);

  @override
  State<NavBarNGO> createState() => _NavBarNGOState();
}

class _NavBarNGOState extends State<NavBarNGO> {

  int index = 0;
  final items = <Widget> [
    Icon(CupertinoIcons.home, color: bgColor,),
    Icon(CupertinoIcons.person, color: bgColor,),
  ];
  final screens = [
    homeNGO(),
    ProfilePageNGO(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgColor,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: bgColor,
          color: navBar,
          height: 60,
          animationCurve: Curves.easeInOut,
          index: index,
          items: items,
          onTap: (index)=> setState(() {
            this.index=index;
          }),
        ),
        body: screens[index],
      ),
    );
  }
}
