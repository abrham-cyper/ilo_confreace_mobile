import 'package:event_prokit/screens/Floormap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/screens/EAForYouTabScreen.dart';
import 'package:event_prokit/screens/Mybage.dart';

import 'package:event_prokit/screens/EATrendingTabScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/main.dart';

import 'EAFilterScreen.dart';

class EASearchScreen extends StatefulWidget {
  final String? name;

  EASearchScreen({this.name});

  @override
  EASearchScreenState createState() => EASearchScreenState();
}

class EASearchScreenState extends State<EASearchScreen> {
  final _kTabs = <Tab>[
    // Tab(text: 'Vote'),
    Tab(text: 'Floor Map'),
  ];

  final _kTabPages = <Widget>[
    // Vote(),
    Floormap(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // Additional initialization code if needed
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          widget.name != null ? "Plan in ${widget.name}" : "20th ILO Regional Conference"),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  width: context.width(),
                  child: Material(
                    color: context.cardColor,
                    child: TabBar(
                      tabs: _kTabs,
                      indicatorColor: primaryColor1,
                      labelColor: primaryColor1,
                      unselectedLabelColor: grey,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: _kTabPages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
