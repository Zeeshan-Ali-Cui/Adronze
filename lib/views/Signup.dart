import 'package:adronze/Models/model.dart';
import 'package:adronze/services/firebaseauthservice.dart';
import 'package:adronze/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/firebaseuserdataservice.dart';



class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  var emailcont = TextEditingController();
  var passwordcont = TextEditingController();
  var namecont = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp"),
          backgroundColor: const Color(0xff29A9AB),
          // backgroundColor: Colors.cyan, // appbar color.
          foregroundColor: Colors.white
      ),
      // backgroundColor: const Color(0xff29A9AB),
      body:
      loading ?
      Center(
        child: SpinKitThreeInOut(color: Color(0xff29A9AB),),
      ):
      SingleChildScrollView(
        child:
        SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                      width: 120,
                      margin: EdgeInsets.all(30),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                            // color: Colors.orangeAccent,
                            child: Image.asset('assets/images/logo.jpg'),
                          )
                      )
                  ),
                ]),
                Padding(
                padding: EdgeInsets.all(32.0),
                child: TextField(
                  controller: namecont,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 3, color: Colors.cyan), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    labelText: 'Name',
                  ))),
                      Container(
                        child: Padding(
                      padding: EdgeInsets.all(32.0),
                       child: TextField(
                         controller: emailcont,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Colors.cyan), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                          labelText: 'Email',
                          ),
                          ),
                      ),
                      ),
                    Container(
                    child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: TextField(
                      controller: passwordcont,
                    decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(width: 3, color: Colors.cyan), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.white,
                    labelText: 'Password',
                    )))),
                Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color:  Color(0xff29A9AB),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: FlatButton(
                    child: Text(
                      'SignUp',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () async{
                      setState(() {
                        loading = true;
                      });
                      firebaseauthservice auth_serv = firebaseauthservice();

                      bool check = await auth_serv.signup(emailcont.text, passwordcont.text);
                      if(check){
                       Userdata data = Userdata(FirebaseAuth.instance!.currentUser!.uid,namecont.text, emailcont.text,"","","");
                       userdataservice().datastoreonsignup(data);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Successfull")));
                        setState(() {
                          loading = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return home();
                            }));

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Creating user")));
                      }
                      setState(() {
                        loading = true;
                      });
                    },
                  ),
                ),
              ]

          ),
        ),
      ),

    );
  }
}
