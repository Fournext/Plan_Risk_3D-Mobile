import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/view/glb_viewer_page.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/view/signin_screen.dart';
import '../screens/auth/view/sign_up_screen.dart';
import '../screens/auth/view/forgot_password_screen.dart';
import '../screens/main/main_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgot = '/forgot';
  static const home = '/home';
  static const viewer = '/viewer';

  static final pages = <GetPage>[
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signin, page: () => SigninScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
/*     GetPage(name: forgot, page: () => ForgotPasswordScreen()), */
    GetPage(name: home, page: () => MainScreen()),
    GetPage(name: viewer, page: () => const GlbViewerPage()),
  ];
}
