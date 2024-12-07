import 'package:clientapp/features/screens/new/home.dart';
import 'package:clientapp/features/screens/new/hours.dart';
import 'package:clientapp/features/screens/new/main_page.dart';
import 'package:clientapp/features/screens/new/services.dart';
import 'package:clientapp/features/screens/new/splash.dart';
import 'package:get/get.dart';

class AppPages {
  static String splash = '/';
  static String signIn = '/sign_in';
  static String mainPage = '/main_page';
  static String services = '/services';
  static String hours = '/hours';
}

final appRouter = [
  GetPage(
    name: AppPages.splash,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppPages.signIn,
    page: () => const SignInScreen(),
  ),
  GetPage(
    name: AppPages.mainPage,
    page: () => const MainPageScreen(),
  ),
  GetPage(
    name: AppPages.services,
    page: () => const ServiceScreen(),
  ),
  GetPage(
    name: AppPages.hours,
    page: () => const HoursScreen(),
  ),
];
