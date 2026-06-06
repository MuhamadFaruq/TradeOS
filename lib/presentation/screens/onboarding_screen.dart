import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/auth_provider.dart';
import 'auth_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  late List<OnboardingQuestion> _questions;
  final Map<int, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _questions = [
      OnboardingQuestion(
        title: 'What do you trade?',
        options: ['Forex', 'Crypto', 'Stocks', 'Futures'],
        icon: Icons.currency_exchange_rounded,
      ),
      OnboardingQuestion(
        title: 'Experience level?',
        options: ['Beginner', 'Intermediate', 'Professional', 'Institutional'],
        icon: Icons.trending_up_rounded,
      ),
      OnboardingQuestion(
        title: 'Trading Style?',
        options: ['Scalping', 'Day Trading', 'Swing Trading', 'Position'],
        icon: Icons.timer_rounded,
      ),
      OnboardingQuestion(
        title: 'Are you a Prop Firm trader?',
        options: ['Yes, actively', 'Starting soon', 'No, personal capital'],
        icon: Icons.account_balance_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                children: List.generate(_questions.length, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: index <= _currentStep ? AppColors.primary : Colors.white10,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 60),
              
              // Icon & Title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(question.icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                question.title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 40),
              
              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedAnswers[_currentStep] == question.options[index];
                    return _buildOptionCard(
                      question.options[index],
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedAnswers[_currentStep] = question.options[index]),
                    );
                  },
                ),
              ),
              
              // Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Back', style: TextStyle(color: AppColors.textSecondary)),
                    )
                  else
                    const SizedBox(),
                  
                  SizedBox(
                    width: 150,
                    child: GlowingButton(
                      text: _currentStep == _questions.length - 1 ? 'FINISH' : 'NEXT',
                      onPressed: _selectedAnswers[_currentStep] != null ? () {
                        if (_currentStep < _questions.length - 1) {
                          setState(() => _currentStep++);
                        } else {
                          // Save onboarding data
                          ref.read(authProvider.notifier).saveOnboardingData(
                            tradingType: _selectedAnswers[0] ?? 'Forex',
                            experienceLevel: _selectedAnswers[1] ?? 'Beginner',
                            tradingStyle: _selectedAnswers[2] ?? 'Scalping',
                            isPropFirmTrader: _selectedAnswers[3] == 'Yes, actively',
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AuthScreen()),
                          );
                        }
                      } : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String label, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24)
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class OnboardingQuestion {
  final String title;
  final List<String> options;
  final IconData icon;

  OnboardingQuestion({required this.title, required this.options, required this.icon});
}
