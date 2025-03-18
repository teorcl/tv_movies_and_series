import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Provider.of(context);
    final user = sessionController.state!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${user.username}'),
            TextButton(
              onPressed: () async {
                await sessionController.signOut();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.signIn,
                    (route) => false,
                  );
                }
              },
              child: const Text('Sign Out'),
            ),
            Text('User ID: ${user.id}'),
          ],
        ),
      ),
    );
  }
}
