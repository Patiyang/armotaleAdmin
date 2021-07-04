import 'package:armotaleadmin/models/adminModel.dart';
import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/views/auth/registration.dart';
import 'package:armotaleadmin/views/home/homePage.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/changeScreen.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginForm extends StatefulWidget {
  final double height;
  final double width;
  final double padding;
  final Color color;
  final double radius;

  const LoginForm({Key key, this.height, this.width, this.padding, this.color, this.radius}) : super(key: key);
  @override
  LoginFormState createState() => new LoginFormState();
}

class LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  final formKey = GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  AdminServices adminServices = new AdminServices();
  List<String> adminEmails = [];
  List<AdminModel> administrators = [];
  bool loading = false;
  bool obscurePassword = true;
  @override
  void initState() {
    super.initState();
    checkEmailAddresses();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: const Offset(0.0, 0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Admin Login',
          color: white,
          size: 25,
          fontWeight: FontWeight.w200,
        ),
        SizedBox(height: 10),
        CustomText(
          text: 'Sign up to get started with tracking your employees, sales statistics, earnings, user traffic and plenty more...',
          color: white,
          size: 17,
          maxLines: 2,
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
        // SizedBox(height: 15),
        SlideTransition(
          position: _animation,
          transformHitTests: true,
          textDirection: TextDirection.ltr,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 400,
                padding: EdgeInsets.all(widget.padding ?? 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 5)),
                  color: widget.color ?? white,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        HelperClass.logo,
                        height: 100,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10),
                      CustomText(text: 'Login With email and password', fontWeight: FontWeight.w700),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 1, width: 50, color: grey),
                          SizedBox(width: 4),
                          CustomText(text: 'OR'),
                          SizedBox(width: 4),
                          Container(height: 1, width: 50, color: grey),
                        ],
                      ),
                      SizedBox(height: 10),
                      InkWell(onTap: () => changeScreenReplacement(context, Register()), child: CustomText(text: 'Create an Account')),
                      SizedBox(height: 20),
                      CustomRegisterTextField(
                        text: 'Email Address',
                        controller: emailController,
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Email Cannot be empty';
                          }
                          if (!adminEmails.contains(emailController.text)) return 'This email is not yet registered';
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(v))
                            return 'Please make sure your email address format is valid';
                          else
                            return null;
                        },
                      ),
                      CustomRegisterTextField(
                        obscure: obscurePassword,
                        text: 'Password',
                        controller: passwordController,
                        suffixIcon: InkWell(
                          child: Icon(obscurePassword == true ? Icons.visibility_off : Icons.visibility),
                          onTap: () {
                            print(obscurePassword.toString());
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'The password field cannot be empty';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                          child: loading == true
                              ? SpinKitThreeBounce(
                                  color: black,
                                  size: 20,
                                )
                              : InkWell(onTap: () => loginAdministrator(), child: CustomText(text: 'Proceed'))),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  checkEmailAddresses() async {
    administrators = await adminServices.getAllAdministrators();
    for (int i = 0; i < administrators.length; i++) {
      adminEmails.add(administrators[i].email);
    }
    print(adminEmails);
    setState(() {});
  }

  loginAdministrator() async {
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await Future.delayed(Duration(seconds: 2)).then((value) => adminServices.loginUser(emailController.text, passwordController.text, context).then((val) {
            setState(() {
              loading = false;
            });
          }));
    }
  }
}
