
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Services/ApiManager.dart';
import '../Wrapper.dart';
import '../app_theme.dart';

class RestPassword extends StatelessWidget {
  RestPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final storage = new FlutterSecureStorage();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: ()async{

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(

                          'تسجبل حساب جديد',
                          style: GoogleFonts.getFont(
                            AppTheme.fontName,
                            textStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w700,
                              fontSize: 23,
                              letterSpacing: 0.5,
                              color: AppTheme.orange,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 100,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(

                        'تخطي',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            letterSpacing: 0.5,
                            color: AppTheme.grey,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            //page content here
            Expanded(
              flex: 9,
              child: buildCard(context, size),
            ),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  TextEditingController phone = TextEditingController();

  Widget buildCard(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: AppTheme.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //header text
            Text(
              'تعيين كلمة المرور',
              style: GoogleFonts.getFont(
                AppTheme.fontName,
                textStyle: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  letterSpacing: 0.5,
                  color: AppTheme.white,
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //email & password section
                      passwordFeild(size),

                      SizedBox(
                        height: 50,
                      ),
                      cpasswordFeild(size),

                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  alignment: Alignment.center,
                  height: size.height / 11,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFEFEFEF),
                    ),
                  ),
                  child: InkWell(
                    onTap: ()async{
                      if (_formKey.currentState!.validate()) {
                        ApiProvider _api = new ApiProvider();
                        dynamic _loginData =
                        await _api.login(email.text, password.text);
                        final storage = new FlutterSecureStorage();
                        if (_loginData['data'] != null) {
                          dynamic data = _loginData['data'];
                          await storage.write(key: 'name', value: data['name']);
                          await storage.write(
                              key: 'id', value: data['id'].toString());
                          await storage.write(key: 'email', value: data['email']);
                          await storage.write(
                              key: 'api_token', value: data['api_token']);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Wrapper()),
                          );                      }else{
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "خطأ",
                            desc: "",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "متابعة",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      }

                    },
                    child: Text('حفظ كلمة المرور',style: GoogleFonts.getFont(
                      AppTheme.fontName,
                      textStyle: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppTheme.green,
                      ),
                    ),),
                  )),
            ),


            SizedBox(
              height: 200,
            ),


            //footer section. sign up text here
          ],
        ),
      ),
    );
  }

  Widget cpasswordFeild(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: email,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب كلمة مرور صحيحة';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            color: AppTheme.grey,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: ' تاكيد كلمة المرور',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordFeild(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: email,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب كلمة مرور صحيحة';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            color: AppTheme.grey,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'كلمة المرور',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
