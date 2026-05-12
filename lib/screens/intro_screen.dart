// lib/screens/intro_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login_screen.dart'; // TAMBAH IMPORT INI

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _popupFadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _showContinueText = false;
  bool _showPopup = false;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _popupFadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 800 + 3000));

    setState(() {
      _showContinueText = true;
    });

    _fadeController.forward();
  }

  void _showPopupDialog() async {
    if (!_showContinueText) return;

    setState(() {
      _isFadingOut = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _showPopup = true;
    });

    _popupFadeController.forward();
  }

  void _closePopupAndContinue(BuildContext context) async {
    await _popupFadeController.reverse();

    setState(() {
      _showPopup = false;
      _isFadingOut = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _popupFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _showPopupDialog,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            AnimatedOpacity(
              opacity: _isFadingOut ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundTime.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value * screenHeight),
                    child: Container(
                      height: screenHeight,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                );
              },
            ),

            AnimatedOpacity(
              opacity: _isFadingOut ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Positioned.fill(
                child: Center(
                  child: Text(
                    'on.time',
                    style: AppTextStyles.kasteloLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            if (_showContinueText && !_isFadingOut)
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Text(
                          'Click anywhere to continue',
                          style: AppTextStyles.kasteloSmall.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

            if (_showPopup)
              AnimatedBuilder(
                animation: _popupFadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _popupFadeController.value,
                    child: Container(
                      color: AppColors.backgroundColor,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  );
                },
              ),

            if (_showPopup)
              AnimatedBuilder(
                animation: _popupFadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _popupFadeController.value,
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TimeQue',
                              style: AppTextStyles.kasteloMedium.copyWith(
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Must Read!',
                              style: AppTextStyles.kasteloMedium.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 25),

                            Text(
                              'This app is still in-progress, any bug or glitches could happen at anytime.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.kasteloSmall.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 15),

                            Text(
                              'Please report to us at @timeque.k8 for any bug or glitches that you found.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.kasteloSmall.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _closePopupAndContinue(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Understood',
                                  style: AppTextStyles.kasteloButton,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
