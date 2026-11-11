import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mensaje de error con botón de reintentar.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBEDEC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0CFCB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Algo salió mal',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.red)),
          const SizedBox(height: 4),
          Text(message, style: const TextStyle(color: AppColors.text)),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ],
      ),
    );
  }
}

/// Cargando...
class LoadingView extends StatelessWidget {
  final String label;
  const LoadingView({super.key, this.label = 'Cargando...'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

/// Muestra qué API/endpoint usa cada pantalla (útil para exponer).
class EndpointNote extends StatelessWidget {
  final String text;
  const EndpointNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blueSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
