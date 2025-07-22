import 'package:ebbok/core/common/widgets/bottom_bar.dart';
import 'package:ebbok/core/theme/theme.dart';
import 'package:ebbok/features/auth/screens/login_screen.dart';
import 'package:ebbok/features/auth/services/auth_service.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:ebbok/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AuhtService authService = AuhtService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EBook',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? const BottomBar()
              : const LoginScreen()
    );
  }
}
