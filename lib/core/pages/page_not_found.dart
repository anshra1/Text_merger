import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display an error icon
            const Icon(Icons.error_outline, size: 100, color: Colors.red),
            const SizedBox(height: 20), // Add spacing
            // Display the "Page Not Found" message
            const Text(
              'Oops! Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Add spacing
            // Add a description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'The page you are looking for does not exist. Please return to the home screen.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40), // Add spacing
            // Home Button
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
