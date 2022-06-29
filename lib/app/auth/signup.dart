import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:noteappusingapi/app/componets/curd.dart';
import 'package:noteappusingapi/app/componets/valid.dart';
import 'package:noteappusingapi/app/constant/linkapi.dart';

import '../componets/customtext.dart';
import '../componets/reuseable.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Curd _curd = Curd();
    bool isloading = false;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _username = TextEditingController();
    _signup() async {
      if (_formKey.currentState!.validate()) {
        isloading = true;
        setState(() {});

        var response = await _curd.postrequest(linkSingUp, {
          'username': _username.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });
        isloading = false;
        setState(() {});
        if (response['status'] == 'success') {
          showdialog(context,
              'تم التسجيل بنجاح الرجاء التوجه لصفحة تسجيل الدخول للمتابعة', () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          });
        }
        return response;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                          hintText: 'User Name',
                          lableText: 'User Name',
                          controller: _username,
                        ),
                        CustomTextFormSign(
                          validator: (val) {
                            return valid(val!, 15, 40);
                          },
                          hintText: 'Email',
                          lableText: 'Email',
                          controller: _emailController,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            _signup();
                          },
                          child: Text('Register'),
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('have an account?'),
                            MaterialButton(
                              child: Text('Login'),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/');
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
