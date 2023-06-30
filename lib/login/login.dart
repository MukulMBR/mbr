import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../addons/constant.dart';
import '../pages/home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,this.onTap});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { 

  String animationURL='login.riv';
  Artboard? artboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;

    final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    initArtboard();//start animation
  }
  
  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }
    initArtboard(){
    rootBundle.load(animationURL).then((value){
      final file=RiveFile.import(value);
      final art=file.mainArtboard;
      stateMachineController=StateMachineController.fromArtboard(art, "Login Machine")!;
      if(stateMachineController!=null){
        art.addController(stateMachineController!);
        for(var element in stateMachineController!.inputs){

         if(element.name=="isChecking"){
           isChecking=element as SMIBool;
         }
         else if(element.name=="isHandsUp"){
           isHandsUp=element as SMIBool;
         }
         else if(element.name=="trigSuccess"){
           successTrigger=element as SMITrigger;
         }
         else if(element.name=="trigFail"){
           failTrigger=element as SMITrigger;
         }
         else if(element.name=='lookNum'){
           lookNum=element as SMINumber;
         }
        }
      }
      setState(() {
        artboard=art;
      });
    });
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    lookNum?.change(0);
  }

  void moveEyeBalls(val) {
    lookNum?.change(val.length.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (artboard != null)
              SizedBox(
                width: 400,
                height: 300,
                child: Rive(
                  artboard: artboard!,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 50),
             Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Login to your Account',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextField(
                          onTap: lookOnTheTextField,
                          onChanged: moveEyeBalls,
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 14),
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusColor: Color(0xffb04863),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb04863),
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        TextField(
                          onTap: handsOnTheEyes,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _obscured,
                          controller: password,
                          focusNode: textFieldFocusNode,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never, //Hides label on focus or if filled
                            labelText: "Password",
                            filled: true, // Needed for adding a fill color
                            isDense: true,  // Reduces height a bit
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,              // No border
                              borderRadius: BorderRadius.circular(12),  // Apply corner radius
                            ),
                            prefixIcon: Icon(Icons.lock_rounded, size: 24),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: GestureDetector(
                                onTap: _toggleObscured,
                                child: Icon(
                                  _obscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
  
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return loading
                                  ? MaterialButton(
                                      onPressed: () async {
                                        if (email.text.isNotEmpty) {
                                          if (password.text.isNotEmpty) {
                                            setState(() {
                                              loading = !loading;
                                            });
                                          } else {
                                            newSnackBar(context,
                                                title:
                                                    'Email and Password Required!');
                                          }
                                        } else {
                                          newSnackBar(context,
                                              title: 'Email Required!');
                                        }

                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: email.text,
                                                  password: password.text)
                                              .then((value) {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage(),
                                              ),
                                            );

                                            setState(() {
                                              loading = !loading;
                                            });
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            newSnackBar(context,
                                                title:
                                                    'No user found for that email.');
                                            setState(() {
                                              loading = !loading;
                                            });
                                          } else if (e.code == 'wrong-password') {
                                            newSnackBar(context,
                                                title:
                                                    'Wrong password provided for that user.');
                                            setState(() {
                                              loading = !loading;
                                            });
                                          }
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: blue,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 15, 0, 15),
                                            child: Text(
                                              'Sign In',
                                              style: TextStyle(color: white),
                                            ),
                                          ),
                                        ],
                                      ))
                                  : Center(
                                      child: MaterialButton(
                                        onPressed: () {},
                                        shape: const CircleBorder(),
                                        color: blue,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  UserRegister(onTap: () {  },),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  customFormFeild({
    controller,
    labelText,
    keyboardType,
    textInputAction,
    obscureText,
  }) {
    return Material(
      elevation: 2,
      shadowColor: black,
      color: white,
      borderRadius: BorderRadius.circular(5.0),
      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: black,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: black),
          contentPadding: const EdgeInsets.all(8),
          border: InputBorder.none,
        ),
      ),
    );
  }
}