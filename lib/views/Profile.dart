import 'package:adronze/Models/model.dart';
import 'package:adronze/services/firebaseuserdataservice.dart';
import 'package:adronze/views/Aboutproject.dart';
import 'package:adronze/views/Contactus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import "dart:io";

class profilepage extends StatefulWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {

  Userdata ud = Userdata("","","","","","");
  bool loading = true;
  bool selected = false;
  File? image ;
  var picker = ImagePicker();

  Userd() async{

    userdataservice serv = userdataservice();
    var userd = await serv.showuserdata(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      ud = userd;
      loading = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Userd();
  }
  Future _imgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      await userdataservice().UpdateCoverPhoto(image!, FirebaseAuth.instance.currentUser!.uid);
      Userd();

      print("done reading");
      // return ByteData.view(bytes.buffer);

    } else {
      print('No image selected.');
    }
  }

  _imgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // selected = true;
        image = File(pickedFile.path);
      });
      await userdataservice().UpdateCoverPhoto(image!, FirebaseAuth.instance.currentUser!.uid);
      Userd();
      // var bytes =  (await pickedFile.readAsBytes());
      // bytes = Uint8List.fromList(bytes);

      // return ByteData.view(bytes.buffer);

    } else {
      print('No image selected.');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(

                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(" Profile "),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff29A9AB), // appbar color.
        foregroundColor: Colors.white,
      ),
        // backgroundColor: Colors.cyan[50],
      body:
      loading ?
          SizedBox.expand(
            child: Center(child: CircularProgressIndicator( color: Color(0xff29A9AB),),),
          ):
      ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 58,
                  backgroundImage:
          ud.img == "" && ud.img!.isEmpty ?
                  AssetImage("assets/images/profileimg.png")  :
                  Image.network('${ud.img}').image,
                  child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: InkWell(child: Icon(Icons.add_circle_outline),onTap: (){
                              _showPicker(context);
                            },),
                          ),
                        ),
                      ]
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${ud.Name}',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Color(0xff29A9AB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${ud.Email}',
                    style: TextStyle(
                      fontSize: 18,

                    ),
                  ),
                ),
                Divider(),
                ListTile(
                leading: Icon(Icons.contact_page),
                  title: Text('Contact Us'),
                  onTap: () => {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => contactus(),
                  ),
                  )
                  }
                  ),
                Divider(),
                ListTile(
                    leading: Icon(Icons.account_box_outlined),
                    title: Text('About me'),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => about(),
                        ),
                      )
                    }
                ),
                Divider(),
                ListTile(
                    leading: Icon(Icons.logout,color:  Color(0xff29A9AB),),
                    title: Text('Logout',style: TextStyle(color:  Color(0xff29A9AB),)),
                    onTap: ()async  {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondScreen(),
                        ),
                      );
                    }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
