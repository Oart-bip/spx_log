import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Indicador de carregamento: quadrado laranja pulsando + texto em monoespaçada.
class SignalLoader extends StatefulWidget {
  const SignalLoader({super.key});

  @override
  State<SignalLoader> createState() => _SignalLoaderState();
}

class _SignalLoaderState extends State<SignalLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _controller,
            child: Container(width: 12, height: 12, color: AppColors.signal),
          ),
          const SizedBox(height: 16),
          const Text('ADQUIRINDO SINAL', style: AppText.label),
        ],
      ),
    );
  }
}

// Mensagem para erro ou lista vazia, com botão opcional de ação.
class StateMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.display.copyWith(fontSize: 34)),
          const SizedBox(height: 12),
          Text(message, style: AppText.body),
          if (actionLabel != null) ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(border: Border.all(color: AppColors.signal)),
                child: Text(actionLabel!, style: AppText.label.copyWith(color: AppColors.signal)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
