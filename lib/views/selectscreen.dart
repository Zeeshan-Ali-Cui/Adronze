import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';

import '../main.dart';
import 'Signup.dart';
class selectscreen extends StatefulWidget {
  const selectscreen({Key? key}) : super(key: key);

  @override
  State<selectscreen> createState() => _selectscreenState();
}

class _selectscreenState extends State<selectscreen> {
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff29A9AB),
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 230),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Imager.fromLocal("assets/images/screen2.png",height: 373.h,width: 256.w,),
                    Container(
                      child: Text(" Welcome to Adronze ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20.sp,color: Colors.white),),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 21,right: 20),
                      child: Text("Get your daily chores taken care of "
                          "at the push of a button while you "
                          "focus on your life.",style: TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 14.sp,color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 150.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30,left: 39),
                            child:
                            InkWell(
                              child: Container(
                                  padding: const EdgeInsets.only(right: 90,top: 18,bottom: 18,left: 90),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFBFBFB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(" Create an Account ",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                      color: Color(0xff2BCFD1)),
                                    textAlign: TextAlign.center,
                                  )
                              ),
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => signup(),
                                    )
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 96,right: 90),
                      child: Row(
                        children: [
                          Text("Already have an Account?",style:
                          TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,
                              color: Color(0xff4F4F4F)),),
                          TextButton(onPressed:()
                          {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SecondScreen(),
                                )
                            );
                          },
                              child: Text("Login",style:
                              TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF)),)),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      );
  }
}
