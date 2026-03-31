// import 'package:day5_app/data/api/Loginapi.dart';
import 'package:day5_app/data/services/auth_service.dart';
import 'package:day5_app/screens/home_page.dart';
import 'package:day5_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This widget is the root of your application.
  final _formKey = GlobalKey<FormBuilderState>();
  // final ApiClient apiClient = ApiClient();
  final AuthService authService = AuthService();

  String? token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Screen',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            /// Name
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(labelText: 'email'),
                    validator: FormBuilderValidators.required(),
                  ),

                  SizedBox(height: 10),

                  FormBuilderTextField(
                    name: 'password',
                    decoration: InputDecoration(labelText: 'password'),
                    validator: FormBuilderValidators.required(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// Button
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                final isValid = _formKey.currentState?.saveAndValidate();

                if (isValid!) {
                  final data = _formKey.currentState!.value;

                  final result = await authService.login(
                    data['email'],
                    data['password'],
                  );

                  if (result != null) {
                    token = result['token'];
                    print("Token: $token");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                  } else {
                    print("Login Failed");
                  }
                }
              },
              child: const Text('Login'),
            ),

            Text("Don't have an account ? "),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RegisterPage(title: 'RegisterPage'),
                  ),
                );
              },
              child: Text("Register Now"),
            ),
          ],
        ),
      ),
    );
  }
}
