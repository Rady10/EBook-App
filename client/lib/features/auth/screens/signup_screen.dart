import 'package:ebbok/core/common/widgets/custom_button.dart';
import 'package:ebbok/features/auth/screens/login_screen.dart';
import 'package:ebbok/features/auth/services/auth_service.dart';
import 'package:ebbok/core/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuhtService auhtService = AuhtService();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    auhtService.signUpUser(
      context: context, 
      email: emailController.text, 
      name: nameController.text, 
      password: passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                  const Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                  const SizedBox(height: 15,),
                  const Text(
                    'Discover Limitless Choices and Unmatched Conveince',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController, 
                          hintText: 'Name', 
                          obscureText: false, 
                          icon: const Icon(Iconsax.user)
                        ),
                        const SizedBox(height: 20,),
                        CustomTextField(
                          controller: emailController, 
                          hintText: 'Email', 
                          obscureText: false, 
                          icon: const Icon(Iconsax.direct_right)
                        ),
                        const SizedBox(height: 20,),
                        CustomTextField(
                          controller: passwordController, 
                          hintText: 'Password', 
                          obscureText: true, 
                          icon: const Icon(Iconsax.password_check)
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          text: 'SignUp', 
                          onTap: (){
                            if(formKey.currentState!.validate()){
                              signUpUser();
                            }
                          }
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}