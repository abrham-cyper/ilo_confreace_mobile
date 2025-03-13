import 'package:event_prokit/main.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

// Define a Spacing utility class for consistent gaps
class Spacing {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor1);

    // Initialize animation controller for fade-in effect
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor1,
          title: Text(
            "About the Conference",
            style: boldTextStyle(color: white, size: 20),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          color: Colors.grey[100], // Light background for professional look
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Spacing.medium, vertical: Spacing.large),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(context),
                  SizedBox(height: Spacing.large),

                  // History and Overview Section
                  _buildSection(
                    title: "History and Overview",
                    content:
                        "From humble beginnings as a small gathering of 21 labour-based engineers in Mbeya, Tanzania, in 1990, the regional Conference has become an international attraction bringing over 500 practitioners from Africa, Asia, Latin America, and beyond. It is now a self-financing, nationally owned event, offering an international platform for south-south learning on pro-employment practices.",
                    icon: Icons.history,
                  ),
                  SizedBox(height: Spacing.large),

                  // Conference Details Section
                  _buildSection(
                    title: "Conference Details",
                    content:
                        "Held every eighteen months at a different venue across the African continent, the Conference embodies the spirit of south-south cooperation and international solidarity. The 19th Conference took place in Kigali, Rwanda, from May 15-19, 2023, themed ‘Promoting skills and productive (decent) jobs for our common better future’. It attracted 1,060 participants from 42 countries across Africa, Asia, Europe, and America.",
                    icon: Icons.event,
                  ),
                  SizedBox(height: Spacing.large),

                  // Contact Us Section
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the header section
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Ethiopian Road Administration",
            style: boldTextStyle(size: 24, color: primaryColor1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Spacing.small),
          Text(
            "20th ILO Regional Conference",
            style: primaryTextStyle(size: 18, color: grey, weight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Spacing.small),
          Divider(color: grey.withOpacity(0.3), thickness: 1),
        ],
      ),
    );
  }

  // Helper method to build a section with title, content, and icon
  Widget _buildSection({required String title, required String content, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: primaryColor1),
              SizedBox(width: Spacing.medium),
              Text(
                title,
                style: boldTextStyle(size: 20, color: primaryColor1),
              ),
            ],
          ),
          SizedBox(height: Spacing.small),
          Divider(color: grey.withOpacity(0.3), thickness: 1),
          SizedBox(height: Spacing.small),
          Text(
            content,
            style: primaryTextStyle(size: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  // Helper method to build the contact section
  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_mail, size: 28, color: primaryColor1),
              SizedBox(width: Spacing.medium),
              Text(
                "Contact Us",
                style: boldTextStyle(size: 20, color: primaryColor1),
              ),
            ],
          ),
          SizedBox(height: Spacing.small),
          Divider(color: grey.withOpacity(0.3), thickness: 1),
          SizedBox(height: Spacing.small),
          Text(
            "For more information, reach out to the Ethiopian Road Administration:",
            style: primaryTextStyle(size: 16, color: Colors.grey[800]),
          ),
          SizedBox(height: Spacing.medium),
          _buildContactItem(Icons.email, "info@era.gov.et"),
          SizedBox(height: Spacing.small),
          _buildContactItem(Icons.phone, "+251 11 551 7171"),
        ],
      ),
    );
  }

  // Helper method to build contact items
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: primaryColor1),
        SizedBox(width: Spacing.medium),
        Text(
          text,
          style: primaryTextStyle(size: 16, color: primaryColor1, weight: FontWeight.w600),
        ),
      ],
    );
  }
}