import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import './wave_wig.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth.dart';

String name = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool checkVersion = false;

  final formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCoupon = TextEditingController();

  late String _name;
  late String _email;
  late String _phonenumber;
  late String _password;

  Future<void> signInWithEmailAndPassword() async {
    name = _controllerName.text;
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future checkCoupon() async {
    final couponref = await FirebaseFirestore.instance
        .collection('version')
        .doc('coupons')
        .get();
    setState(() {
      checkVersion = couponref.data()!.entries.any((element) =>
          element.key == _controllerCoupon.text.trim() &&
          element.value == 'notset');
    });
    print(checkVersion);
  }

  Future StartUser() async {
    final ref = FirebaseFirestore.instance
        .collection('dataStore')
        .doc(Auth().currentUser!.email);
    await ref.collection('pond1').doc("system1").set({});
    await ref
        .collection('pond1')
        .doc("pondDetail")
        .set({'coverage': 1500, "systemsCount": 1});
    await ref.set({
      'ponds': {
        'pond1': ["system1"]
      },
      'system1': {'PH': 7, 'DO': 10, 'TEMP': 27, 'TDS': 6}
    });
  }

  void saveData() async {
    String name = _controllerName.text;
    String phoneNumber = _controllerPhone.text;
    String email = _controllerEmail.text;

    Map<String, dynamic> data = {
      'name': name,
      'phone number': phoneNumber,
      'email': email,
      'password': _controllerPassword.text.trim(),
      'version': checkVersion ? 'proVersion' : 'lightVersion'
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(email) // replace userID with the user's ID or a unique identifier
        .set(data);
    checkVersion
        ? await FirebaseFirestore.instance
            .collection('version')
            .doc('coupons')
            .set({_controllerCoupon.text.trim(): email},
                SetOptions(merge: false))
        : null;
    await FirebaseFirestore.instance
        .collection('version')
        .doc(checkVersion ? 'proVersion' : 'lightVersion')
        .set({_controllerEmail.text.trim(): _controllerName.text.trim()});
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      name = _controllerName.text;
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }

      saveData();
      StartUser();
    }
  }

  Widget _errorMessage() {
    return Center(
      child: Text(
        errorMessage!,
        style: const TextStyle(
            color: Colors.red, fontSize: 14, fontFamily: 'SF-Pro'),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        isLogin ? 'Not a member?' : 'Already having account?',
        style: TextStyle(
          fontFamily: 'SF-Pro',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin ? 'Register' : 'Login',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerCoupon.dispose();
    _controllerEmail.dispose();
    _controllerName.dispose();
    _controllerPassword.dispose();
    _controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    final size = MediaQuery.of(context).size;
    // final model = Provider.of<HomeModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffDADEEC),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(children: [
            WaveWidget(
                size: size, yOffset: size.height / 1.25, color: Colors.blue),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 75,
                ),
                isLogin
                    ? Image.asset(
                        'images/user.png',
                        height: 100,
                        width: 100,
                      )
                    : Container(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 35,
                      color: Color(0xff0C2551),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF-Pro',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    isLogin ? 'Sign to continue' : 'Create an account',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF-Pro',
                    ),
                  ),
                ),
                SizedBox(
                  height: isLogin ? 15 : 15,
                ),
                //
                Visibility(
                  visible: !isLogin,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(.8),
                              fontFamily: 'SF-Pro',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: TextFormField(
                          controller: _controllerName,
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 25),
                            focusColor: const Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Username is invalid";
                            } else {
                              null;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: isLogin ? 10 : 2,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0, bottom: 8),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SF-Pro',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: TextFormField(
                          controller: _controllerPhone,
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter your phone no.",
                            hintStyle: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontSize: 18,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 25),
                            focusColor: const Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone number can't be empty";
                            } else if (value.length < 10) {
                              return 'Phone number should have at least 10 digits';
                            } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                              return 'Phone number should contain only digits';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: isLogin ? 10 : 2,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0, bottom: 8),
                          child: Text(
                            "Coupon code",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SF-Pro',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: TextField(
                          onSubmitted: (value) {
                            checkCoupon();
                            // print(checkVersion);
                          },
                          controller: _controllerCoupon,
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter the coupon code (Not required)",
                            hintStyle: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontSize: 18,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 25),
                            focusColor: const Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: isLogin ? 10 : 2,
                      ),
                    ],
                  ),
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 8),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SF-Pro',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: TextFormField(
                    controller: _controllerEmail,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter your email id",
                      hintStyle: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 18,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 25),
                      focusColor: const Color(0xff0962ff),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: isLogin ? 10 : 2,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 8),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextFormField(
                    controller: _controllerPassword,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "8+ Characters,1 Capital letter",
                      hintStyle: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 18,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 25),
                      focusColor: const Color(0xff0962ff),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                        return 'Password should contain at least 1 uppercase letter';
                      } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
                        return 'Password should contain at least 1 lowercase letter';
                      } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                        return 'Password should have atleast 8 letters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                _errorMessage(),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: scrWidth / 2,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      if (isLogin) {
                        signInWithEmailAndPassword();
                      } else {
                        createUserWithEmailAndPassword();
                      }
                    },
                    child: Text(
                      isLogin ? 'Login' : 'Register',
                      style: const TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _loginOrRegisterButton(),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
