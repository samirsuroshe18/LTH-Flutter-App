import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _taglineController;
  late AnimationController _loadingController;
  late AnimationController _glowController;
  late AnimationController _shimmerController;
  late AnimationController _progressController;

  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _taglineAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(AuthGetUser());
    });

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    ));

    _taglineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start animations with delays
    _startAnimations();
  }

  void _startAnimations() {
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      _titleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _taglineController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _loadingController.forward();
    });

    // Repeating animations
    _glowController.repeat(reverse: true);
    _shimmerController.repeat();
    _progressController.repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    _loadingController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserSuccess) {
            _handleSuccessNavigation(state);
          }
          if (state is AuthGetUserFailure) {
            _handleErrorNavigation(state);
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1e3c72),
                  Color(0xFF2a5298),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _glowController.value * 2 * math.pi,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.25, 0.25),
                              radius: 0.5,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value * 0.2 + 0.8,
                            child: Transform.translate(
                              offset: Offset(0, (1 - _logoAnimation.value) * 30),
                              child: Opacity(
                                opacity: _logoAnimation.value,
                                child: _buildLogo(),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Title
                      AnimatedBuilder(
                        animation: _titleAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, (1 - _titleAnimation.value) * 20),
                            child: Opacity(
                              opacity: _titleAnimation.value,
                              child: const Text(
                                'ComplaintFlow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Tagline
                      AnimatedBuilder(
                        animation: _taglineAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, (1 - _taglineAnimation.value) * 20),
                            child: Opacity(
                              opacity: _taglineAnimation.value,
                              child: Text(
                                'Empowering Smart Complaint Resolution',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Loading indicator at bottom
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _loadingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - _loadingAnimation.value) * 20),
                        child: Opacity(
                          opacity: _loadingAnimation.value,
                          child: _buildLoadingIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: _glowAnimation.value),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),

        // Logo container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFf0f7ff),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shimmer effect
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: _shimmerAnimation.value * 240 - 120,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Logo icon
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_glowController.value - 0.45) * 0.1,
                      child: const Icon(
                        Icons.flash_on,
                        size: 48,
                        color: Color(0xFF2a5298),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                final delay = index * 0.16;
                final progress = (_progressController.value + delay) % 1.0;
                final scale = 0.8 + (math.sin(progress * 2 * math.pi) * 0.4);
                final opacity = 0.5 + (math.sin(progress * 2 * math.pi) * 0.5);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: opacity),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),

        const SizedBox(height: 20),

        // Progress bar
        Container(
          width: 120,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 120 * _progressAnimation.value,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleSuccessNavigation(AuthGetUserSuccess state) {
    if (state.response.role == 'superadmin') {
      Navigator.pushNamedAndRemoveUntil(context, '/super-admin-home', (Route<dynamic> route) => false);
    }else if (state.response.role == 'sectoradmin') {
      Navigator.pushNamedAndRemoveUntil(context, '/sector-admin-home', (Route<dynamic> route) => false);
    } else if (state.response.role == 'technician') {
      Navigator.pushNamedAndRemoveUntil(context, '/technician-home', (Route<dynamic> route) => false);
    }
  }

  void _handleErrorNavigation(AuthGetUserFailure state) async {
    // Store context in variable to avoid issues with async gaps
    final currentContext = context;

    // Function to safely navigate if still mounted
    void safeNavigate(String route, {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            currentContext,
            route,
            predicate ?? (route) => false,
            arguments: arguments
        );
      }
    }

    // Define onRetryCallback that's safe to use
    onRetryCallback() {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            currentContext,
            '/',
                (route) => false
        );
      }
    }

    switch (state.errorType) {
      case AuthErrorType.unauthorized:
        safeNavigate('/login');
        break;

      case AuthErrorType.noInternet:
        final token = await getAccessToken();
        if (!mounted) return; // Check mounted after await

        if (token != null) {
          safeNavigate(
              '/error',
              arguments: {
                'errorType': 'noInternet',
                'message': 'No internet connection. Please check your connectivity.',
                'showLoginOption': false,
                'showRetryOption': true,
                'onRetry': onRetryCallback,
              }
          );
        } else {
          safeNavigate('/login');
        }
        break;

      case AuthErrorType.serverError:
        safeNavigate(
            '/error',
            arguments: {
              'errorType': 'serverError',
              'message': 'Our servers are currently experiencing issues. Please try again later.',
              'showLoginOption': true,
              'showRetryOption': true,
              'onRetry': onRetryCallback,
            }
        );
        break;

      case AuthErrorType.unexpectedError:
        final token = await getAccessToken();
        if (!mounted) return; // Check mounted after await

        if (token != null) {
          safeNavigate(
              '/error',
              arguments: {
                'errorType': 'unexpectedError',
                'message': 'Something went wrong. ${state.message}',
                'showLoginOption': true,
                'showRetryOption': true,
                'onRetry': onRetryCallback,
              }
          );
        } else {
          safeNavigate('/login');
        }
        break;
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}