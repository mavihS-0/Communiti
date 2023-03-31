import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:one_for_all/screens/volunteer/profileVol.dart';
import 'package:one_for_all/screens/volunteer/searchVol.dart';
import 'homeVol.dart';
import 'package:one_for_all/utils/constants.dart';


class NavBarVol extends StatefulWidget {
  const NavBarVol({Key? key}) : super(key: key);

  @override
  State<NavBarVol> createState() => _NavBarVolState();
}

class _NavBarVolState extends State<NavBarVol> {

  int index = 0;
  final items = <Widget> [
    Icon(CupertinoIcons.home, color: bgColor),
    Icon(CupertinoIcons.search, color: bgColor),
    Icon(CupertinoIcons.person, color: bgColor),
  ];
  final screens = [
    homeVol(),
    SearchVol(),
    ProfilePageVol(),
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
