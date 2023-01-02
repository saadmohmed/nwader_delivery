import 'dart:ffi';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../auth_screen/Login.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? animationController;

  Animation<double>? topBarAnimation;

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;

  dynamic _state = '';
  bool status = true;
  int quantity = 0;

  double address_opacity = 1;
  double payment_opacity = 1;

  Icon arrow_down = Icon(
    Icons.arrow_downward_sharp,
    color: AppTheme.white,
  );
  Icon arrow_up = Icon(Icons.arrow_upward_sharp, color: AppTheme.white);

  String? payment_method = 'ar';
  String? address;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController old_password = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController phone = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.green,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () async {
              _key.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset('assets/icons/menu-icon.png'),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_sharp,
                  color: AppTheme.green,
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //to give space from top

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (payment_opacity == 0) {
                            payment_opacity = 1;
                          } else {
                            payment_opacity = 0;
                          }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppTheme.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/user-icon.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "بيانات الحساب",
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.1,
                              ),
                              payment_opacity == 1 ? arrow_down : arrow_up
                            ],
                          ),
                        ),
                      ),
                    ),
                    //page content here
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: payment_opacity == 1 ? true : false,
                      child: Opacity(
                        opacity: payment_opacity,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: AppTheme.background_c,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<dynamic>(
                                future: _api.user(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    dynamic data = snapshot.data["user_data"];
                                    if(snapshot.data['status'] == true){
                                      return Column(
                                        children: [
                                          nameTextField(data['name'] == null ? '' : data['name']),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          phoneFeild(data['mobile'] == null ? '' : data['mobile']),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          emailTextField(data['email'] == null ? '' : data['email']),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Radio<String>(
                                                    value: 'ar',
                                                    groupValue: payment_method,
                                                    // TRY THIS: Try setting the toggleable value to false and
                                                    // see how that changes the behavior of the widget.
                                                    toggleable: true,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        payment_method = value;
                                                      });
                                                    }),
                                                Text(
                                                  'عربي',
                                                  style: GoogleFonts.getFont(
                                                    AppTheme.fontName,
                                                    textStyle: TextStyle(
                                                      fontFamily:
                                                      AppTheme.fontName,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: AppTheme.darkText,
                                                    ),
                                                  ),
                                                ),
                                                Radio<String>(
                                                    value: 'en',
                                                    groupValue: payment_method,
                                                    // TRY THIS: Try setting the toggleable value to false and
                                                    // see how that changes the behavior of the widget.
                                                    toggleable: true,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        payment_method = value;
                                                      });
                                                    }),
                                                Text(
                                                  'English',
                                                  style: GoogleFonts.getFont(
                                                    AppTheme.fontName,
                                                    textStyle: TextStyle(
                                                      fontFamily:
                                                      AppTheme.fontName,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: AppTheme.darkText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: ()async {
                                              ApiProvider _api = new ApiProvider();
                                              dynamic update_Data =
                                              await _api.update_profile(name.text , email.text , phone.text );
                                              print(update_Data);
    final storage = new FlutterSecureStorage();
    if (update_Data['status'] == true) {
      dynamic data = update_Data['user_data'];
      await storage.write(key: 'name', value: data['name']);
      await storage.write(
          key: 'token', value: data['token'].toString());
      await storage.write(
          key: 'email', value: data['email'].toString());
      await storage.write(
          key: 'mobile', value: data['mobile'].toString());
      Alert(
        context: context,
        type: AlertType.success,
        title: data['response_message'].toString(),
        desc: "",
        buttons: [
          DialogButton(
            child: Text(
              "متابعة",
              style: TextStyle(
                  color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }else{
      Alert(
        context: context,
        type: AlertType.success,
        title: data['response_message'].toString(),
        desc: "",
        buttons: [
          DialogButton(
            child: Text(
              "متابعة",
              style: TextStyle(
                  color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(5)),
                                                    color: AppTheme.green,
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          4.0),
                                                      child: Text(
                                                        "حفظ",
                                                        style:
                                                        GoogleFonts.getFont(
                                                          AppTheme.fontName,
                                                          textStyle: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 16,
                                                            color: AppTheme.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                  oldPasswordFeild(),
                                  SizedBox(
                                  height: 10,
                                  ),
                                          passwordFeild(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: ()async {
                                              ApiProvider _api = new ApiProvider();
                                              dynamic update_Data =
                                              await _api.update_password(password.text , old_password.text);
                                              print(update_Data);
                                              final storage = new FlutterSecureStorage();
                                              if (update_Data['status'] == true) {
                                                dynamic data = update_Data['user_data'];
                                                await storage.write(key: 'name', value: data['name']);
                                                await storage.write(
                                                    key: 'token', value: data['token'].toString());
                                                await storage.write(
                                                    key: 'email', value: data['email'].toString());
                                                await storage.write(
                                                    key: 'mobile', value: data['mobile'].toString());
                                                password.text = '';
                                                old_password.text = '';
                                                Alert(
                                                  context: context,
                                                  type: AlertType.success,
                                                  title: update_Data['response_message'].toString(),
                                                  desc: "",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "متابعة",
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 20),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      width: 120,
                                                    )
                                                  ],
                                                ).show();
                                              }else{

                                                Alert(
                                                  context: context,
                                                  type: AlertType.error,
                                                  title: update_Data['response_message'].toString(),
                                                  desc: "",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "متابعة",
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 20),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      width: 120,
                                                    )
                                                  ],
                                                ).show();
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(5)),
                                                    color: AppTheme.green,
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          4.0),
                                                      child: Text(
                                                        "تغير كلمة السر",
                                                        style:
                                                        GoogleFonts.getFont(
                                                          AppTheme.fontName,
                                                          textStyle: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 16,
                                                            color: AppTheme.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      );

                                    }else{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Login()),
                                      );
                                      return CircularProgressIndicator();
                                    }
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (address_opacity == 0) {
                            address_opacity = 1;
                          } else {
                            address_opacity = 0;
                          }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppTheme.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/truck.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "عناوين التوصيل",
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.4,
                              ),
                              address_opacity == 1 ? arrow_down : arrow_up
                            ],
                          ),
                        ),
                      ),
                    ),
                    //page content here
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: address_opacity == 1 ? true : false,
                      child: Opacity(
                        opacity: address_opacity,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: AppTheme.background_c,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                    future: _api.getUserAddress(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        dynamic data = snapshot.data;
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            data.length,
                                            (index) => Row(
                                              children: [
                                                Flexible(
                                                  child: Radio<String>(
                                                      value:
                                                          '${data[index]["id"]}',
                                                      groupValue: address,
                                                      // TRY THIS: Try setting the toggleable value to false and
                                                      // see how that changes the behavior of the widget.
                                                      toggleable: true,
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          address = value;
                                                        });
                                                      }),
                                                ),
                                                Flexible(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                        '${data[index]["address_name"]} '),
                                                    Text(
                                                        '${data[index]["address_text"]} ')
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameTextField(String nameData) {
    name.text = nameData;
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.green,
        ),
      ),
      child: TextFormField(
        controller: name,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: ' الاسم',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget emailTextField(String emailData) {
    email.text = emailData;
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.green,
        ),
      ),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب بريد الكتروني صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: ' البريد الألكتروني',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget phoneFeild(String phoneData) {
    phone.text = phoneData;
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.green,
        ),
      ),
      child: TextFormField(
        controller: phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب رقم جوال  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'رقم الجوال',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordFeild() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.green,
        ),
      ),
      child: TextFormField(
        controller: password,
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
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: ' اكلمة المرور الجديدة',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
  Widget oldPasswordFeild() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 16,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.green,
        ),
      ),
      child: TextFormField(
        controller: old_password,
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
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'كلمة المرور القديمة',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
