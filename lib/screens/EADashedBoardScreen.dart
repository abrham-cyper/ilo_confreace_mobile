import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/screens/EANewsList.dart';
import 'package:event_prokit/screens/EAHomeScreen.dart';
import 'package:event_prokit/screens/EAPeopleScreen.dart';
import 'package:event_prokit/screens/EAProfileScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/main.dart';
import 'EASearchScreen.dart';

class EADashedBoardScreen extends StatefulWidget {
  final String? name;

  EADashedBoardScreen({this.name});

  @override
  EADashedBoardScreenState createState() => EADashedBoardScreenState();
}

class EADashedBoardScreenState extends State<EADashedBoardScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(EAHomeScreen(name: widget.name));
    _pages.add(EANewsList());
    // _pages.add(EASearchScreen());
    _pages.add(EAPeopleScreen());
    _pages.add(EAProfileScreen());
  }

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor1,
      unselectedItemColor: appStore.isDarkModeOn ? white : black,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(LineIcons.home, size: 30, color: appStore.isDarkModeOn ? white : black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.handshake, size: 30, color: appStore.isDarkModeOn ? white : black),
          label: '',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(LineIcons.map, size: 30, color: appStore.isDarkModeOn ? white : black),
        //   label: '',
        // ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.comments, size: 30, color: appStore.isDarkModeOn ? white : black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.user, size: 30, color: appStore.isDarkModeOn ? white : black),
          label: '',
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomTab(),
      body: Center(child: _pages.elementAt(_selectedIndex)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EADashedBoardScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}