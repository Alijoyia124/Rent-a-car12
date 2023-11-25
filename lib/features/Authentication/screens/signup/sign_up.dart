import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/admin/admin.dart';
import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:covid_tracker/common%20widgets/text_form_field.dart';
import 'package:covid_tracker/features/Authentication/screens/PostScreen.dart';
import 'package:covid_tracker/features/Authentication/screens/login/login.dart';
import 'package:covid_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../resources/color.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  bool isAdmin = false;


  bool loading=false;
  final formkey=GlobalKey<FormState>();
  final usernameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  final ageController=TextEditingController();
  final addressController=TextEditingController();

  final usernameFocusNode=FocusNode();
  final emailFocusNode=FocusNode();
  final passFocusNode=FocusNode();
  final confirmPasswordFocusNode=FocusNode();
  final ageFocusNode=FocusNode();
  final addressFocusNode=FocusNode();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth=FirebaseAuth.instance;

  void dispose() {
    super.dispose();

    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    addressController.dispose();

    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    ageFocusNode.dispose();
    addressFocusNode.dispose();
  }

// Function to check if a user is an admin based on their email
  bool checkIfUserIsAdmin(String email) {
    // Implement your logic to check if the user is an admin.
    // For example, you can check the email address for admin users.
    return email.endsWith("admin@123gmail.com");
  }

// Function to handle login
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => loginScreen()));
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
  }
  Future<void> signUp() async {
    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String userUID = userCredential.user!.uid;
        String uniqueId = userUID; // You can use the user's UID as a unique ID
        usernameController.text = usernameController.text.trim();


        // Link userUID and uniqueId to Firestore document for additional user data
        await addUserDetails(
          userUID,
          uniqueId, // Set the Firestore document ID to uniqueId
          usernameController.text.trim(),
          emailController.text.trim(),
          int.parse(ageController.text.trim()),
          addressController.text.trim(),
          isAdmin,
        );

        // Show success message
        _showSuccessDialog();
      }

      setState(() {
        loading = false;
      });
    } catch (error) {
      print("Error during sign up: $error");
      utils().toastMessage("Error during sign up: $error");
      setState(() {
        loading = false;
      });
    }
  }

  Future addUserDetails(
      String userUID,
      String id, // Add id as a parameter
      String username,
      String email,
      int age,
      String address,
      bool isAdmin,
      ) async {
    await FirebaseFirestore.instance.collection('users').doc(userUID).set({
      'id': id, // Store the id in Firestore
      'username': username,
      'email': email,
      'age': age,
      'address': address,
      'isAdmin': isAdmin,
    });
  }



  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: AlertDialog(
            title: Text("Sign-Up Successful",style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,
            ),),
            content: Text("You have successfully signed up!",style: Theme.of(context).textTheme.headline6,),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => loginScreen()),
                  ); // Navigate to the login page
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar:AppBar(
            leading: null,
            title:Text("Sign Up"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 35,),
                    Form(
                        key:formkey,
                        child:Column(
                      children: [

                        SizedBox(height: 30,),
                        //Username//
                        InputTextFormField(
                            myController:usernameController,
                            focusNode:  usernameFocusNode,
                            icon: Icon(Icons.person,color: AppColors.primaryMaterialColor,),

                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onFiledSubmittedValue: (value){

                            },
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            hint: "Username",
                            onValidator: (value){
                              return value.isEmpty ? "Enter Username " : null;

                            }
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // User Email
                        InputTextFormField(
                            myController: emailController,
                            focusNode:  emailFocusNode,
                            icon: Icon(Icons.email,color: AppColors.primaryMaterialColor,),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onFiledSubmittedValue: (value){

                            },
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            hint: "Email",
                            onValidator: (value){
                              return value.isEmpty ? "Enter email" : null;

                            }
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // User password
                        InputTextFormField(
                            myController:passwordController,
                            focusNode: passFocusNode,
                            icon: Icon(Icons.password_sharp,color: AppColors.primaryMaterialColor,),

                            onFiledSubmittedValue: (value){

                            },
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            hint: "Password",
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onValidator: (value){
                              return value.isEmpty ? "Enter Password" : null;

                            }
                        ),
                        // Add this to your form
                        // CheckboxListTile(
                        //   title: Text("Sign up as admin"),
                        //   value: isAdmin, // Create a variable isAdmin to track admin selection
                        //   onChanged: (value) {
                        //     setState(() {
                        //       isAdmin = value!;
                        //     });
                        //   },
                        // ),

                        SizedBox(
                          height: 20,
                        ),

                        // User age
                        InputTextFormField(
                            myController:ageController,
                            focusNode: ageFocusNode,
                            icon: Icon(Icons.numbers_sharp,color: AppColors.primaryMaterialColor,),

                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onFiledSubmittedValue: (value){
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            hint: "Age",
                            onValidator: (value){
                              return value.isEmpty ? "Enter Age" : null;

                            }
                        ),
                        SizedBox(height: 20,),

                        // User address
                        InputTextFormField(
                            myController:addressController,
                            focusNode: addressFocusNode,
                            icon: Icon(Icons.home,color: AppColors.primaryMaterialColor,),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onFiledSubmittedValue: (value){

                            },

                            keyboardType: TextInputType.streetAddress,
                            obscureText: false,
                            hint: "Address",
                            maxLines: 2,
                            onValidator: (value){
                              return value.isEmpty ? "Enter Address" : null;

                            }
                        )])),
                        SizedBox(
                          height:80
                        ),

                        RoundButton(title: 'Sign Up',
                            loading: loading, // Pass the loading state to the RoundButton
                            onPress: () {
                              if (formkey.currentState!.validate()) {
                                signUp();
                                   }
                            }
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));}, child: Text("Login",style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize:15,
                              decoration:TextDecoration.underline,
                            ),)),
                          ],
                        ),
                      ],
                    )),
            ),
            );
  }
}

