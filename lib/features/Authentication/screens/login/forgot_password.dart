import 'package:covid_tracker/common%20widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../common widgets/text_form_field.dart';
import '../../../../resources/color.dart';
import '../../../../utils/utils.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  bool isResettingPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryMaterialColor,
        title: Text("Recover your Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your Email to get the password reset link",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 30),
            InputTextFormField(
              myController: emailController,
              focusNode: emailFocusNode,
              icon: Icon(Icons.email, color: AppColors.primaryMaterialColor),
              onFiledSubmittedValue: (value) {},
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              hint: "Enter your Email",
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "your.email@example.com",
                prefixIcon: Icon(Icons.email),
              ),
              onValidator: (value) {
                return value.isEmpty ? "Enter email" : null;
              },
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: isResettingPassword
                  ? CircularProgressIndicator()
                  : RoundButton(
                title: "Reset Password",
                onPress: () {
                  resetPassword(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    setState(() {
      isResettingPassword = true;
    });

    try {
      await auth.sendPasswordResetEmail(email: emailController.text.toString());
      showResetEmailSentDialog(context);
    } catch (error) {
      utils().toastMessage(error.toString());
    } finally {
      setState(() {
        isResettingPassword = false;
      });

      // Clear the text fields
      emailController.clear();
    }
  }

  void showResetEmailSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Password Reset Email Sent",
            style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "An email with instructions to reset your password has been sent to your email address.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
