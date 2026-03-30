import 'package:day5_app/screen/register_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                    name: 'name',
                    decoration: InputDecoration(labelText: 'name'),
                    validator: FormBuilderValidators.required(),
                  ),

                  SizedBox(height: 10),

                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(labelText: 'email'),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
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
              onPressed: () {
                // Validate and save the form values
                _formKey.currentState?.saveAndValidate();
                debugPrint(_formKey.currentState?.value.toString());

                // On another side, can access all field values without saving form with instantValues
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
