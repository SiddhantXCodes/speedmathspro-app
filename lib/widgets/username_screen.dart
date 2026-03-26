import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/local_user_provider.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _error;

  Future<void> _submit() async {
    final user = context.read<LocalUserProvider>();

    try {
      await user.setUsername(_nameController.text.trim());
      // RootGate handles navigation
    } catch (_) {
      setState(() {
        _error = "Username must be at least 3 characters";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO
              Image.asset(
                "assets/images/speedmathspro-transparent.png",
                height: 90,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              // CARD
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Welcome to SpeedMaths Pro",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Pick a username to get started.\nNo login. No account. No internet required.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color.fromARGB(255, 81, 81, 81),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 26),

                    // INPUT
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      maxLength: 15,
                      decoration: InputDecoration(
                        hintText:
                            "Create username (e.g. sinchan123)",
                        helperText:
                            "By this name you will be identified in leaderboard",
                        errorText: _error,
                        counterText: "",
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
