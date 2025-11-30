import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/login_page.dart';
import 'package:watchmans_gazette/screens/main_screen.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      _init();
    });
  }

  void _init() async {
    await autoLogin(
      onSuccess: () {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainScreen();
              },
            ),
          );
        });
      },
      onFail: (message) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          color: AppColors.background,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

Future<void> autoLogin({
  required Function() onSuccess,
  Function(String)? onFail,
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    onSuccess();
    return;
  }

  if (onFail != null) {
    onFail("Unable to login automatically");
  }
}
