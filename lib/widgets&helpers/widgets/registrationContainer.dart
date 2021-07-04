import 'package:armotaleadmin/models/adminModel.dart';
import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/views/auth/login.dart';
import 'package:armotaleadmin/views/auth/registration.dart';
import 'package:armotaleadmin/views/home/homePage.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/changeScreen.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RegistrationForm extends StatefulWidget {
  final double height;
  final double width;
  final double padding;
  final Color color;
  final double radius;

  const RegistrationForm({Key key, this.height, this.width, this.padding, this.color, this.radius}) : super(key: key);
  @override
  RegistrationFormState createState() => new RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  final formKey = GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();
  final phoneController = new TextEditingController();
  AdminServices adminServices = new AdminServices();
  bool loading = false;
  bool obsucrePassword = true;
  bool obsucreConfirmPassword = true;

  List adminEmails = [];
  List<AdminModel> administrators = [];
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
          maxLines: 2,
          color: white,
          size: 17,
          fontWeight: FontWeight.normal,
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
                  // color: widget.color ?? white,
                  gradient: LinearGradient(colors: [
                    white,
                    grey[200],
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
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
                      CustomText(text: 'Sign Up With email and password', fontWeight: FontWeight.w700),
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
                      InkWell(onTap: () => changeScreenReplacement(context, Login()), child: CustomText(text: 'Login')),
                      SizedBox(height: 20),
                      CustomRegisterTextField(
                        // radius: 10,
                        text: 'Email Address',
                        controller: emailController,
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Email Cannot be empty';
                          }
                          if (adminEmails.contains(emailController.text)) return 'This email is already registered';
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(v))
                            return 'Please make sure your email address format is valid';
                          else
                            return null;
                        },
                      ),
                      // CustomRegisterTextField(
                      //   text: 'PhoneNumber',
                      //   controller: phoneController,
                      //   validator: (v) {
                      //     if (v.isEmpty) return 'the phone number cannot be empty';
                      //   },
                      // ),
                      CustomRegisterTextField(
                        controller: passwordController,
                        obscure: obsucrePassword,
                        validator: Validators.compose([
                          Validators.required('password field cannot be empty'),
                          Validators.minLength(6, 'The password must be greater than 6'),
                          Validators.patternRegExp(RegExp(r'[!@#$%^&*(),.?":{}|<>]'), 'Password must have one special character'),
                          Validators.patternRegExp(RegExp(r'[a-z]'), 'Password must have at least one lower case letter'),
                          Validators.patternRegExp(RegExp(r'[A-Z]'), 'Password must have at least one upper case letter'),
                          Validators.patternRegExp(RegExp(r'[0-9]'), 'Password must have at least one integer')
                        ]),
                        suffixIcon: InkWell(
                          child: Icon(obsucrePassword == true ? Icons.visibility_off : Icons.visibility),
                          onTap: () {
                            print(obsucrePassword.toString());
                            setState(() {
                              obsucrePassword = !obsucrePassword;
                            });
                          },
                        ),
                        text: 'Password',
                      ),
                      CustomRegisterTextField(
                        controller: confirmPasswordController,
                        validator: (v) {
                          if (v.isEmpty) return 'the password cannot be empty';
                          if (confirmPasswordController.text != passwordController.text) return 'the passwords do not match';
                        },
                        obscure: obsucreConfirmPassword,
                        text: 'Confirm Password',
                      ),
                      SizedBox(height: 20),
                      Container(
                          child: loading == true
                              ? SpinKitThreeBounce(
                                  color: black,
                                  size: 20,
                                )
                              : InkWell(onTap: () => registerAdministrator(), child: CustomText(text: 'Proceed'))),
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

  registerAdministrator() async {
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await Future.delayed(Duration(seconds: 2)).then((value) {
        adminServices.createUser(emailController.text, passwordController.text, context);
      });
      //

    }
  }
}
