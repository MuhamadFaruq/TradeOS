import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import 'home_dashboard.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                'Welcome to\nTradeOS',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to your professional trading space.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              
              // Email Input
              const GlassCard(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    border: InputBorder.none,
                    icon: Icon(Icons.email_outlined, color: AppColors.textTertiary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password Input
              const GlassCard(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none,
                    icon: Icon(Icons.lock_outline_rounded, color: AppColors.textTertiary),
                    suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textTertiary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              GlowingButton(
                text: 'SIGN IN',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeDashboard()),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white10)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: AppColors.textTertiary)),
                  ),
                  Expanded(child: Divider(color: Colors.white10)),
                ],
              ),
              const SizedBox(height: 40),
              
              // Social Login
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.apple, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Apple', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 32),
                          const SizedBox(width: 4),
                          Text('Google', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
