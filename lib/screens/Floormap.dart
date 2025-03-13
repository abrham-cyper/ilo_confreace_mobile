import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';

import 'EAEventDetailScreen.dart';

class Floormap extends StatefulWidget {
  @override
  FloormapState createState() => FloormapState();
}

class FloormapState extends State<Floormap> {
  double _scaleFactor = 1.0;  // Default scale factor (1.0 means no zoom)
  double _minScale = 1.0;  // Minimum scale (default 1.0, no zoom out)
  double _maxScale = 4.0;  // Maximum scale (maximum zoom in 4x)

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // Zoom in functionality
  void _zoomIn() {
    setState(() {
      if (_scaleFactor < _maxScale) {
        _scaleFactor += 0.1; // Increase zoom factor
      }
    });
  }

  // Zoom out functionality
  void _zoomOut() {
    setState(() {
      if (_scaleFactor > _minScale) {
        _scaleFactor -= 0.1; // Decrease zoom factor
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 60),
        itemCount: Events.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              // Image with zoom functionality
              Stack(
                alignment: Alignment.topRight,  // Align buttons to top right
                children: [
                  GestureDetector(
                    onScaleUpdate: (details) {
                      setState(() {
                        _scaleFactor = details.scale;  // Update scale on pinch gesture
                      });
                    },
                    child: Transform.scale(
                      scale: _scaleFactor,
                      alignment: Alignment.center,
                      child: commonCachedNetworkImage(
                        // Events[i].image!,
                        "https://i.pinimg.com/736x/78/4f/6e/784f6e4e4a15871a38ae84464c48dad3.jpg",
                        height: MediaQuery.of(context).size.height,  // Full screen height
                        width: MediaQuery.of(context).size.width,    // Full screen width
                        fit: BoxFit.cover,                           // Make the image cover the full area
                      ).cornerRadiusWithClipRRect(0),  // No corner rounding
                    ),
                  ),
                  // Buttons for zooming in and out
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Zoom Out Button
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: white,
                                size: 30,
                              ),
                              onPressed: _zoomOut,  // Zoom out when clicked
                            ),
                            // Zoom In Button
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: white,
                                size: 30,
                              ),
                              onPressed: _zoomIn,  // Zoom in when clicked
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ).onTap(() {
            
          });
        },
      ),
    );
  }
}
