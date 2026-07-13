import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'themes/app_theme.dart';
import 'helpers/api_helper.dart';
import 'provider/auth_provider.dart';
import 'provider/dashboard_provider.dart';
import 'provider/committee_provider.dart';
import 'provider/loan_provider.dart';
import 'provider/installment_provider.dart';
import 'provider/lottery_provider.dart';
import 'provider/profile_provider.dart';
import 'provider/material_provider.dart';
import 'provider/notification_provider.dart';

void main() {
  // Ensure system navigation/status bar styling matches app theme
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Dark icons for light splash screen
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CommitteeProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => InstallmentProvider()),
        ChangeNotifierProvider(create: (_) => LotteryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Janta Trader',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: ApiHelper.navigatorKey,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
