import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_eat_e_commerce_app/pages/splash.dart';

import 'firebase_options.dart';




/// Firebase background handler
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification?.title);
}

// Create local notification instance
local_notifications.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
local_notifications.FlutterLocalNotificationsPlugin();

/// Initialize Local Notifications
void initializeLocalNotification() async {
  const androidSettings = local_notifications.AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = local_notifications.InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

/// Show local notification
void showLocalNotification(RemoteMessage message) async {
  const androidDetails = local_notifications.AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: local_notifications.Importance.max,
    priority: local_notifications.Priority.high,
  );

  final platformDetails = local_notifications.NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  usePathUrlStrategy();

  // 🔔 Initialize local notifications
  initializeLocalNotification();

  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.requestPermission();
  }

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("Opened from notification");
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print("Notification opened from terminated state");
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message: ${message.notification?.title}");
    if (message.notification != null) showLocalNotification(message);
  });

  runApp(MyApp());
}

// ───────────────────────────────────────────────────────────
// APPLICATION ROOT
// ───────────────────────────────────────────────────────────
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.light;

  void setLocale(String language) {
    setState(() => _locale = Locale(language));
  }

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoEatDriverApp',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
        Locale('hi'),
        Locale('es'),
        Locale('ur'),
      ],
      themeMode: _themeMode,
      theme: ThemeData(brightness: Brightness.light),
      routes: {
        "/": (context) => SplashScreen(),
      },
    );
  }
}

// ───────────────────────────────────────────────────────────
// MAIN NAVIGATION BAR PAGE
// ───────────────────────────────────────────────────────────
// class NavBarPage extends StatefulWidget {
//   final String? initialPage;
//   final Widget? page;
//
//   NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);
//
//   @override
//   _NavBarPageState createState() => _NavBarPageState();
// }
//
// class _NavBarPageState extends State<NavBarPage> {
//   String _currentPageName = 'HomePage';
//   Widget? _currentPage;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentPageName = widget.initialPage ?? _currentPageName;
//     _currentPage = widget.page;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tabs = {
//       'HomePage': HomePageWidget(),
//       'MenuPage': MyEarningPageWidget(),
//       'AllReviews': AllReviewsWidget(),
//       'PastOrdersPage': PastOrdersPageWidget(),
//       'Side_bar': SideBarWidget(),
//     };
//
//     final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
//
//     return Scaffold(
//       body: _currentPage ?? tabs[_currentPageName],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: (i) {
//           setState(() {
//             _currentPage = null;
//             _currentPageName = tabs.keys.toList()[i];
//           });
//         },
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset('assets/images/home_unselect_icon.svg', width: 24),
//             activeIcon: SvgPicture.asset('assets/images/home_icon.svg', width: 24),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset('assets/images/earning_img.svg', width: 24),
//             activeIcon: SvgPicture.asset('assets/images/select_earning.svg', width: 24),
//             label: "Earnings",
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset('assets/images/reiew.svg', width: 24),
//             activeIcon: SvgPicture.asset('assets/images/select_review.svg', width: 24),
//             label: "Reviews",
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset('assets/images/order_.svg', width: 24),
//             activeIcon: SvgPicture.asset('assets/images/select_order.svg', width: 24),
//             label: "Orders",
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset('assets/images/profile_icon.svg', width: 24),
//             activeIcon: SvgPicture.asset('assets/images/fill_profile_icon.svg', width: 24),
//             label: "Account",
//           ),
//         ],
//       ),
//     );
//   }
// }
