import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' hide log;
import 'package:google_fonts/google_fonts.dart';
import 'package:podverse_app/Databases/shared_pref.dart';
import 'package:podverse_app/view/SignIn_Page.dart';
import 'package:podverse_app/view/bottom_naviagtion_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _beamController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startApp();
  }

  void _initializeControllers() {
    // initialize all animation controllers first
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _fadeController.forward();
  }

  Future<void> _startApp() async {
    final sp = SharedPref();
    await sp.getSharedPrefData();

    // optional delay for splash effect
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => sp.isLoggedIn ? BottomNavigation() : SigninPage(),
      ),
    );
  }

  @override
  void dispose() {
    // Safely dispose only if initialized
    _fadeController.dispose();
    _beamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _beamController,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xFF0A0A0A), Colors.black],
                  ),
                ),
              ),

              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: BeamPainter(_beamController.value),
              ),

              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/podverse-New-logo-1 bg.png",
                        height: 140,
                        width: 300,
                        fit: BoxFit.contain,
                      ),
                      // const SizedBox(height: 20),
                      // Text(
                      //   "Powered By KeyConnect",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w300,
                      //     color: Colors.white,
                      //     letterSpacing: 2.0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BeamPainter extends CustomPainter {
  final double animationValue;
  BeamPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.05), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2;

    final random = Random(42);
    for (int i = 0; i < 20; i++) {
      double startX = size.width * random.nextDouble();
      double startY = size.height * random.nextDouble();
      double endX = startX + 100 * animationValue;
      double endY = startY + 100 * animationValue;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant BeamPainter oldDelegate) => true;
}
