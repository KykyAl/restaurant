import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restauran_app/controller/controller_detail.dart';
import 'package:restauran_app/controller/controller_page.dart';
import 'package:restauran_app/controller/controller_search.dart';
import 'package:restauran_app/helper/navigator_helper.dart';
import 'package:restauran_app/widget/card_screen.dart';
import 'package:restauran_app/widget/detail_list_page.dart';
import 'package:restauran_app/widget/list_page.dart';
import 'package:restauran_app/widget/list_search.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RestauranApp());
}

class RestauranApp extends StatelessWidget {
  RestauranApp({super.key});
  final NavigatorHelper navigatorHelper = NavigatorHelper();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List Restaurant',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialBinding: Dependency(),
      getPages: [
        GetPage(name: navigatorHelper.root, page: () => RestauranApp()),
        GetPage(
          name: navigatorHelper.listPage,
          page: () => ListPage(),
        ),
        GetPage(
          name: navigatorHelper.detailPage,
          page: () => RestaurantDetailScreen(),
        ),
        GetPage(
          name: navigatorHelper.searchPage,
          page: () => SearchPage(),
        ),
        GetPage(name: navigatorHelper.splashScreen, page: () => SplashScreen()),
        GetPage(name: navigatorHelper.cardScreen, page: () => CartScreen())
      ],
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<RestaurantController>();
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: SpinKitWave(
          controller: _controller,
          color: Colors.brown,
          size: 50.0,
        ),
        nextScreen: ListPage(),
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 200,
      ),
    );
  }
}

class Dependency implements Bindings {
  @override
  void dependencies() {
    Get.put<RestaurantController>(RestaurantController());
    Get.put<RestaurantDetailController>(RestaurantDetailController());
    Get.put<RestaurantSearchController>(RestaurantSearchController());
  }
}
