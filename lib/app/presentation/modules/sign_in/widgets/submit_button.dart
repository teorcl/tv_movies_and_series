import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enums.dart';
import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';
import '../controller/sign_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final signInController = Provider.of<SignInController>(context);
    //La linea anterior funcionara siempre que SubmitButton sea hijo de un widget que tenga un ChangeNotifierProvider<SignInController> como ancestro

    if (signInController.state.fetching) {
      return const CircularProgressIndicator();
    } else {
      return MaterialButton(
        onPressed: () {
          final isValid = Form.of(context).validate();
          if (isValid) {
            // Codigo para que se cominuque con la api de TMDV y determine si el inicio de session es satisfactorio
            _submit(context);
          }
        },
        color: Colors.blue,
        child: const Text('Sign In'),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    //final signInController = Provider.of<SignInController>(context); esto tiene el listen en true y generaria un error
    // Diria que se esta intentando escuchar un valor expuesto por un provider, desde fuera del arbol de widgets.
    final signInController = context.read<SignInController>();
    final result = await signInController.submit();

    if (!signInController.mounted) return;

    result.when(
      (failure) {
        final message = {
          SignInFailure.notFound: 'Not found',
          SignInFailure.unauthorized: 'Invalid Password',
          SignInFailure.unknown: 'Error',
          SignInFailure.network: 'Network error',
        }[failure];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
      (user) {
        final sessionController = context.read<SessionController>();
        sessionController.setUser(user);
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
