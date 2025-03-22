import 'dart:async';
import 'dart:convert';
import 'package:event_prokit/screens/EASplashScreen.dart';
import 'package:event_prokit/store/AppStore.dart';
import 'package:event_prokit/utils/AppTheme.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Initialize AppStore
AppStore appStore = AppStore();

// GlobalKey to access ScaffoldMessenger for showing SnackBars
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Timer for refreshing token
Timer? refreshTokenTimer;

// Background message handler (must be top-level)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Background message: ${message.notification?.title}');
}

// Function to refresh the access token
Future<void> refreshAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refreshToken');

  if (refreshToken == null) {
    print('No refresh token available, stopping refresh.');
    refreshTokenTimer?.cancel();
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/user/refreshToken'), // Replace with your API domain
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newAccessToken = data['accessToken'];
      await prefs.setString('accessToken', newAccessToken);
      print('Access token refreshed at ${DateTime.now()}: $newAccessToken');
    } else {
      print('Refresh failed: ${response.statusCode}');
      refreshTokenTimer?.cancel();
      await prefs.setBool('isLoggedIn', false);
      // Optionally navigate to login screen
    }
  } catch (e) {
    print('Error refreshing token: $e');
  }
}

// Start the token refresh timer
void startTokenRefreshTimer() {
  refreshTokenTimer?.cancel(); // Cancel any existing timer
  refreshTokenTimer = Timer.periodic(Duration(minutes: 8), (timer) {
    refreshAccessToken(); // Refresh token every 8 minutes
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up FCM
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions (mainly for iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // Get and print FCM token
  String? fcmToken = await messaging.getToken();
  print('FCM Token: $fcmToken');

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received');
    if (message.notification != null) {
      print('Notification: ${message.notification?.title} - ${message.notification?.body}');
      // Show a SnackBar or custom dialog in the app
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('${message.notification?.title}: ${message.notification?.body}'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  });

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle when the app is opened from a terminated state via notification
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    print('App opened from terminated state: ${initialMessage.notification?.title}');
  }

  // Handle when the app is opened from a background state via notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('App opened from background: ${message.notification?.title}');
  });

  // Your existing initialization
  await initialize(aLocaleLanguageList: languageList());
  appStore.toggleDarkMode(value: getBoolAsync('isDarkModeOnPref'));

  // Start token refresh timer if logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isLoggedIn') == true) {
    startTokenRefreshTimer(); // Start refreshing token on app launch
  }

  defaultRadius = 10;
  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '${'Event'}${!isMobile ? ' ${platformName()}' : ''}',
        home: EASplashScreen(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
        scaffoldMessengerKey: scaffoldMessengerKey, // Already present
      ),
    );
  }
}