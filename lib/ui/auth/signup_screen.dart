import 'package:appointment_booking_1/providers/hide_password_provider.dart';
import 'package:appointment_booking_1/providers/loading_provider.dart';
import 'package:appointment_booking_1/routes/app_navigation.dart';
import 'package:appointment_booking_1/routes/app_navigation_routes.dart';
import 'package:appointment_booking_1/utils/app_colors.dart';
import 'package:appointment_booking_1/utils/utils.dart';
import 'package:appointment_booking_1/widgets/round_button.dart';
import 'package:appointment_booking_1/widgets/theme_change_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: AppColors.whiteTextColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          ThemeChangerButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<HidePasswordProvider>(
                      builder: (context, value, child) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: value.isObscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () {
                              value.setObscure();
                            },
                            icon: value.isObscurePassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility)),
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        } else {
                          return null;
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Consumer<LoadingProvider>(builder: (context, value, child) {
              return RoundButton(
                loading: value.loading,
                title: 'Sign up',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    value.setLoader();
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      );
                      Utils().toastMessage(
                          '${emailController.text.toString()} is registered!');

                      AppNavigation.navigateTo(
                          routeName: AppNavRoutes.loginScreen);

                      value.setLoader();
                    } on FirebaseAuthException catch (e) {
                      Utils().toastMessage(e.toString());
                      value.setLoader();
                    }
                  }
                },
              );
            }),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    AppNavigation.navigateTo(
                        routeName: AppNavRoutes.loginScreen);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
