import 'package:flutter/material.dart';
import 'package:noteappusingapi/main.dart';

import '../componets/curd.dart';
import '../componets/customtext.dart';
import '../componets/valid.dart';
import '../constant/linkapi.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Curd _curd = Curd();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    login() async {
      if (_formKey.currentState!.validate()) {
        var response = await _curd.postrequest(linkLogin, {
          'username': _usernameController.text,
          'password': _passwordController.text,
        });
        if (response['status'] == 'success') {
          prefs.setString('id', response['data']['id'].toString());
          prefs.setString('username', response['data']['username'].toString());
          prefs.setString('email', response['data']['email'].toString());
          Navigator.of(context)
              .pushNamedAndRemoveUntil('home', (route) => false);
        }
        return response;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  CustomTextFormSign(
                    validator: (val) {
                      return valid(val!, 4, 30);
                    },
                    hintText: 'username',
                    lableText: 'username',
                    controller: _usernameController,
                  ),
                  CustomTextFormSign(
                    validator: (val) {
                      return valid(val!, 6, 40);
                    },
                    hintText: 'Password',
                    lableText: 'Password',
                    controller: _passwordController,
                  ),
                  MaterialButton(
                    minWidth: 100,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: Text('Login'),
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      MaterialButton(
                        child: Text('Sign Up'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('signup');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
