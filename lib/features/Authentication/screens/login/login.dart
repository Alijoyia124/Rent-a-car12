import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:covid_tracker/common%20widgets/text_form_field.dart';
import 'package:covid_tracker/features/Authentication/screens/PostScreen.dart';
import 'package:covid_tracker/features/Authentication/screens/login/forgot_password.dart';
import 'package:covid_tracker/features/Authentication/screens/signup/sign_up.dart';
import 'package:covid_tracker/resources/color.dart';
import 'package:covid_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../admin/admin.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}
class _loginScreenState extends State<loginScreen> {

  bool isAdmin = false;

  bool _isPasswordVisible = false;
  bool loading=false;
  final formkey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final emailFocusNode=FocusNode();
  final passFocusNode=FocusNode();

  FirebaseAuth _auth=FirebaseAuth.instance;

  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
  }

  bool checkIfUserIsAdmin(String email) {
    // Implement your logic to check if the user is an admin.
    // For example, you can check the email address for admin users.
    return email.endsWith("admin@123gmail.com");
  }


  void login() {
    setState(() {
      loading = true;
    });

    _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((value) {
      if (value.user != null) {
        // Check if the logged-in user is an admin
        String? userEmail = value.user!.email;
        if (userEmail != null) {
          bool isAdmin = checkIfUserIsAdmin(userEmail);
          if (isAdmin) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => adminPanel()));
            // For example, you can use Navigator to navigate to an admin screen
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
          }
        } else {
          // Handle the case where the user's email is null (this should rarely happen)
          print("User email is null");
          // You can display an error message to the user or handle it as needed.
        }
      }

      setState(() {
        loading = false;
      });
    }).catchError((error) {
      print("Error during login: $error");
      utils().toastMessage("Error during login: $error");
      setState(() {
        loading = false;
      });
    });
  } @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Stack(
        children: [
        Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffB81736),
            Color(0xff281537),
          ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 60.0, left: 22),
          child: Text(
              'Welcomeback\nSign in!',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white
              )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputTextFormField(
                   myController:emailController,
                   focusNode: emailFocusNode,
                   obscureText: false, // Set obscureText to true
                   icon: Icon(Icons.email,color:AppColors.primaryMaterialColor,
                   ),
                   decoration: InputDecoration(
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   onFiledSubmittedValue: (value){
               utils.fieldFocus(context, emailFocusNode, passFocusNode);
                   },
                   keyboardType: TextInputType.emailAddress,
                   // obscureText: false,
                   hint: "Enter your Email",
                   onValidator: (value){
                     return value.isEmpty ? "Enter email" : null;

                   }
               ),

                        SizedBox(
                         height: height *.02,
                        ),
                      InputTextFormField(
                        myController: passwordController,
                        focusNode: passFocusNode,
                        obscureText: true, // Set obscureText to true
                        icon: Icon(Icons.password_sharp,color:AppColors.primaryMaterialColor),
                        decoration: InputDecoration(
                        ),
                        onFiledSubmittedValue: (value) {},
                        keyboardType: TextInputType.visiblePassword,
                        hint: "Enter your Password",
                        onValidator: (value) {
                          return value.isEmpty ? "Enter Password" : null;
                        },
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        //     color: Theme.of(context).primaryColor,
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       _isPasswordVisible = !_isPasswordVisible;
                        //     });
                        //   },
                        // ),
                      ),

                      SizedBox(height: height*.02,),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children:[

                         GestureDetector(
                           onTap:(){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                     },
                           child: Text(
                              "Forgot Password",
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                fontSize:15,
                                fontWeight: FontWeight.bold,
                                decoration:TextDecoration.underline,
                              ),
                            ),
                         ),
                        ]),
                     ),
                  SizedBox(height: 60),
                  RoundButton(
                      title: 'Login',
                      loading: loading, // Pass the loading state to the RoundButton
                      onPress: () {
                        if (formkey.currentState!.validate()) {
                          login();
                        }
                      }
                  ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()));}, child: Text("Sign up",style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize:15,
                              decoration:TextDecoration.underline,
                            ),)),
                          ],
                        ),
//                     InkWell(
//                       onTap: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));
//                       },
//                       child: Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
// border: Border.all(color: Colors.black)
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Login with Phone"
//                           ),
//                         ),
//                       ),
//                     )
                    ],

                  ),
            )),

            ),
      )
      ]));
  }
}

