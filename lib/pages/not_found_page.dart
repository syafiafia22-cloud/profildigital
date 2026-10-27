import 'package:flutter/material.dart';

import '../app/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oops!')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off, size: 64),
            const SizedBox(height: 12),
            const Text('Halaman tidak ditemukan'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.profile,
                (route) => false,
              ),
              child: const Text('Ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
