import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../domain/enums.dart';
import '../../../routes/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _userName = '', _password = '';
  bool _fecthing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fecthing,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(() {
                        _userName = text.trim().toLowerCase();
                      });
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
                      setState(() {
                        _password = text.replaceAll(' ', '').toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (text) {
                      text = text?.replaceAll(' ', '').toLowerCase() ?? '';
                      if (text.length < 4) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    //Importante este contexto si es necesario repetir video
                    if (_fecthing) {
                      return const CircularProgressIndicator();
                    }
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
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fecthing = true;
    });

    final result = await Injector.of(context).authenticationRepository.signIn(
          _userName,
          _password,
        );

    if (!mounted) return;

    result.when(
      (failure) {
        setState(() {
          _fecthing = false;
        });
        final message = {
          SignInFailure.notFound: 'Not found',
          SignInFailure.unauthorized: 'Invalid Password',
          SignInFailure.unknown: 'Error',
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
