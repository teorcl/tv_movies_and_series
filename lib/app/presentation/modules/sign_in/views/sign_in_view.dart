import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enums.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../controller/sign_in_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Builder(builder: (context) {
                final signInController = Provider.of<SignInController>(context);

                return AbsorbPointer(
                  absorbing: signInController.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          signInController.onUserNameChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Username',
                        ),
                        validator: (text) {
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          signInController.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (text) {
                          text = text?.replaceAll(' ', '') ?? '';
                          if (text.length < 4) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (signInController.fetching)
                        const CircularProgressIndicator()
                      else
                        MaterialButton(
                          onPressed: () {
                            final isValid = Form.of(context).validate();
                            if (isValid) {
                              // Codigo para que se cominuque con la api de TMDV y determine si el inicio de session es satisfactorio
                              _submit(context);
                            }
                          },
                          color: Colors.blue,
                          child: const Text('Sign In'),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    //final signInController = Provider.of<SignInController>(context); esto tiene el listen en true y generaria un error
    final signInController = context.read<SignInController>();
    signInController.onFetchingChanged(true);

    final result =
        await Provider.of<AuthenticationRepository>(context, listen: false)
            .signIn(
      signInController.username,
      signInController.password,
    );

    if (!mounted) return;

    result.when(
      (failure) {
        signInController.onFetchingChanged(false);
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
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
