import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'Common/Color_Constant.dart';
import 'Loginscreen.dart';
import 'Widget/Alerttoastdialog.dart';
import 'Widget/commontextfield.dart';
import 'common/Commonsize.dart';
import 'common/Textstyle.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final TextEditingController emailcontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();
  final TextEditingController confirmcontroller=TextEditingController();
  final TextEditingController usernamecontroller=TextEditingController();
  final TextEditingController mobilecontroller=TextEditingController();

  // final FirebaseAuthservice _auth=FirebaseAuthservice();

  bool pass=false;
  bool confirm=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color_Constant.primarycolor,
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Text("Welcome To Registration",style: commonstylepoppins(size: 30,weight: FontWeight.w700),),
              ),
              SizedBox(height: displayheight(context)*0.03,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Username",style: commonstylepoppins(weight: FontWeight.w500),),
              ),
              commontextfield("Enter your name", usernamecontroller),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Email Id",style: commonstylepoppins(weight: FontWeight.w500),),
              ),
              commontextfield("Enter your emailid", emailcontroller),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Mobile Number",style: commonstylepoppins(weight: FontWeight.w500),),
              ),
              commontextfield("Enter your mobile number", mobilecontroller),

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
                  style:commonstylepoppins(size: 15,weight: FontWeight.w500,color:Colors.black),
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
                child: Text("Confirm Password",style: commonstylepoppins(weight: FontWeight.w500),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  controller: confirmcontroller,
                  obscureText: confirm,
                  style: commonstylepoppins(size: 15,weight: FontWeight.w500,color:Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter Confirm Password",
                    isDense: true,
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        confirm=!confirm;
                      });
                    }, icon: Icon(confirm?CupertinoIcons.eye:CupertinoIcons.eye_slash,color: Colors.white,)),
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
                        if(emailcontroller.text.isEmpty&&passwordcontroller.text.isEmpty&&usernamecontroller.text.isEmpty&&mobilecontroller.text.isEmpty&&confirmcontroller.text.isEmpty){
                          alerttoastred(context, "Required Field");
                        }else if(passwordcontroller.text!=confirmcontroller.text){
                          alerttoastred(context, "Password Didn't Match");
                        }else{
                          // signup();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("REGISTER",style: commonstylepoppins(size: 15,weight: FontWeight.w700),),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: InkWell(
                    onTap: (){
                      Get.to(Loginscreen());
                    },
                    child: Text("Already Have Account",style: commonstylepoppins(weight: FontWeight.w800),))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void signup()async{
  //   String email=emailcontroller.text;
  //   String password=passwordcontroller.text;
  //
  //   User?user=await _auth.signinwithEmailandPassword(email, password);
  //
  //   if(user==null){
  //     alerttoastred(context, "Unable to create User");
  //   }
  //   else{
  //     alerttoastgreen(context, "Account Has Been Sucessfully Created");
  //     emailcontroller.text='';
  //     passwordcontroller.text='';
  //     usernamecontroller.text='';
  //     mobilecontroller.text='';
  //     confirmcontroller.text='';
  //
  //   }
  // }
}
