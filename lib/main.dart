import 'dart:async';
import 'package:adronze/services/firebaseauthservice.dart';
import 'package:adronze/views/Signup.dart';
import 'package:adronze/views/home.dart';
import 'package:adronze/views/screen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 954),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {

        return MaterialApp(
          title: 'Adronze',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: child,
          debugShowCheckedModeBanner: false,
        );
      },
      child: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void check_if_user_login(){
    if(FirebaseAuth.instance.currentUser != null){
      Timer(
          const Duration(seconds: 8),
              () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => home())));
    }else{
      Timer(
          const Duration(seconds: 8),
              () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const screen1())));
    }
  }

  @override
  void initState() {
    super.initState();
    check_if_user_login();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff29A9AB),
      // child: Image.asset('assets/images/Logo.png'),
      child: Image.asset('assets/images/dronedeliveryview.gif'),
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width / 2.5,
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  var emailcont = TextEditingController();
  var passwordcont = TextEditingController();
  bool obs = true;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Login"),
            backgroundColor: const Color(0xff29A9AB), // appbar color.
            foregroundColor: Colors.white),
        // backgroundColor: Colors.cyan[100],
        body:  loading ? Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
             Color(0xff29A9AB),),
          ),
        ):
        SingleChildScrollView(
          child:
          Column(children: [
            SizedBox(height: 10),
            Column(children: [
              Container(
                padding: EdgeInsets.only(top: 30),
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: TextField(
                    controller: emailcont,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(width: 3, color: Colors.cyan), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.white,
                      labelText: 'Username',
                    ),
                  ),
                ),

                Container(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: TextField(
                      controller: passwordcont,
                      obscureText: obs,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Colors.cyan), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          labelText: ' Password ',
                          suffixIcon:
                          InkWell(
                              onTap: () {
                                setState(() {
                                  obs = !obs;
                                });
                              },
                              child: obs
                                  ? Icon(Icons.lock)
                                  : Icon(Icons.lock_open))),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color:  Color(0xff29A9AB),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: FlatButton(
                    child: Text(
                      'LogIn',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () async{
                      setState(() {
                        loading = true;
                      });
                      firebaseauthservice auth_serv = firebaseauthservice();

                      bool check = await auth_serv.Signin(emailcont.text, passwordcont.text);
                      if(check){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Successfull")));
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return home();
                            }));

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email or Password is incorrect")));
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 100,left: 50,right: 50),
                  child: Row(
                    children: [
                      SizedBox(width: 50),
                      Container(child: Text("Create New Account ?")),
                      Container(
                        child: TextButton(
                            child: Text(
                              "SignUp",
                              style: TextStyle(fontSize: 17,color:  Color(0xff29A9AB),),
                            ),
                            onPressed: () {

                             firebaseauthservice auth_serv = firebaseauthservice();
                             auth_serv.signup("email@gmail.com", "password");
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (BuildContext context) {
                                   return signup();
                                 }));
                            }),
                      )
                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     SizedBox(width: 40),
                //     Container(child: Text("Forgotten password ?")),
                //     Container(
                //       child: TextButton(
                //           child: Text(
                //             "Forget Password",
                //             style: TextStyle(fontSize: 15),
                //           ),
                //           onPressed: () {}),
                //     )
                //   ],
                // ),
              ],
            ),
          ]),
        ));
  }
}
// AIzaSyAZXm_Ed8SHUjhAqcyh9d5OQOl09sebFKY