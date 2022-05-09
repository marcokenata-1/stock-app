import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/BLoC/auth_bloc.dart';
import 'package:stock_app/UI/main_screen.dart';
import 'package:stock_app/UI/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Log In Error")));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is Unauthenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sign In",
                          style: TextStyle(
                              fontSize: 38, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: const InputDecoration(
                                    hintText: 'email',
                                    border: OutlineInputBorder()),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != null &&
                                          !EmailValidator.validate(value)
                                      ? 'Enter a valid email'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: 'password',
                                    border: OutlineInputBorder()),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != null && value.length < 6
                                      ? 'Enter min 6 characters'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _authenticateWithEmailAndPassword(context);
                                  },
                                  child: const Text('Sign In'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _authenticateWithGoogle(context);
                        },
                        icon: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const Text("Don't have an account?"),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const SignupScreen()));
                        },
                        child: const Text("Sign Up"),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(emailController.text, passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
