import 'package:adronze/main.dart';
import 'package:adronze/views/selectscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';
class screen1 extends StatefulWidget {
  const screen1({Key? key}) : super(key: key);

  @override
  State<screen1> createState() => _screen1State();
}

class _screen1State extends State<screen1> {
  @override
  Widget build(BuildContext context) {
    return
      AnnotatedRegion
      <SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Color(0xff29A9AB)),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff29A9AB),
            body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(top: 230,right: 5,),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Imager.fromLocal("assets/images/screen1.png",height: 373.h,width: 256.w,),
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
                        height: 200.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 30.5,right: 150.5,top: 50),
                              child: TextButton(onPressed:()
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SecondScreen(),
                                    )
                                );
                              } , child: Text("Skip",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                  color: Colors.white),)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: InkWell(
                                child: Container(
                                    padding: const EdgeInsets.only(right: 41.5,top: 17,bottom: 17,left: 41.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFBFBFB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Text("Next",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                        color: Color(0xff2BCFD1)),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => selectscreen(),
                                      )
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
        ),
      );
  }
}
