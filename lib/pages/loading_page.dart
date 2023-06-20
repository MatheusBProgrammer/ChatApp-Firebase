import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Carregando...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Container(
              width: 120,
              child: LinearProgressIndicator(
                  minHeight: 1,
              backgroundColor: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
