
import 'package:covid_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class signUpController with ChangeNotifier{


  FirebaseAuth auth=FirebaseAuth.instance;
  bool _loading= false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading=value;
    notifyListeners();
  }


  void signup(String username,String email,String password)async{

  setLoading(true);

  try {
    auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      utils().toastMessage(' User Created Successful');
      setLoading(false);
    }).onError((error, stackTrace) {
      utils().toastMessage(error.toString());
      setLoading(false);
    });
  }

    catch(e)
  {
  utils().toastMessage(e.toString());
  }
}
    }
