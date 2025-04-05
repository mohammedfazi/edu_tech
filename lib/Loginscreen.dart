
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Signup.dart';
import 'Widget/Alerttoastdialog.dart';
import 'Widget/commontextfield.dart';
import 'common/Color_Constant.dart';
import 'common/Commonsize.dart';
import 'common/Textstyle.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  final TextEditingController emailcontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();

  bool pass=false;

  // final FirebaseAuthservice _auth=FirebaseAuthservice();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color_Constant.primarycolor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(child: Text("E-Campus",style: commonstylepoppins(size: 30,weight: FontWeight.w800),)),
             ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Center(child: Image.asset("Assets/logo.png",height: displayheight(context)*0.30,)),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Welcome Back To \nLogin",style: commonstylepoppins(size: 30,weight: FontWeight.w700),),
            ),
            SizedBox(height: displayheight(context)*0.03,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Email Id",style: commonstylepoppins(weight: FontWeight.w500),),
            ),
            commontextfield("Enter your emailid", emailcontroller),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Password",style: commonstylepoppins(weight: FontWeight.w500),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                controller: passwordcontroller,
                obscureText: pass,
                style: commonstylepoppins(size: 15,weight: FontWeight.w500,color:Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  isDense: true,
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      pass=!pass;
                    });
                  }, icon: Icon(pass?CupertinoIcons.eye:CupertinoIcons.eye_slash,color: Colors.white,)),
                  contentPadding: EdgeInsets.all(12),
                  hintStyle: commonstylepoppins(size: 14,color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Color_Constant.primarycolorlight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    onPressed: (){
                      if(emailcontroller.text=="admin@connectdoctor.com" && passwordcontroller.text=="123456"){
                        // Get.to(Adminscreen());
                        alerttoastgreen(context, "Admin Logged In Successfully");
                      }else if(emailcontroller.text.isEmpty && passwordcontroller.text.isEmpty){
                        alerttoastred(context, "Required Field is Empty");
                      }
                      else{
                        // signIn();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("LOGIN",style: commonstylepoppins(size: 15,weight: FontWeight.w700),),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: InkWell(
                  onTap: (){
                    Get.to(Signup());
                  },
                  child: Text("Create New Account",style: commonstylepoppins(weight: FontWeight.w800),))),
            ),
          ],
        ),
      ),
    );
  }

  // void signIn()async{
  //
  //   String email=emailcontroller.text;
  //   String password=passwordcontroller.text;
  //
  //   User?user=await _auth.signUpwithEmailandPassword(email, password);
  //
  //   if(user==null){
  //     print("somehing error");
  //     alerttoastred(context, "Incorrect Email and Password");
  //     // StackDialog.show("Explore Easy", "Incorrect Email and Password", Icons.verified_outlined, Colors.black);
  //   }
  //   else{
  //     alerttoastgreen(context, "Sucessfully Logged In");
  //     // StackDialog.show("Explore Easy", "Sucessfully Logged In", Icons.verified_outlined, Colors.black);
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));
  //     print("User is created");
  //   }
  // }
}
