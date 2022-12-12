
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader_devlivery/home_screen/myorders.dart';
import 'package:nwader_devlivery/home_screen/notifications.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../auth_screen/Login.dart';
// import '../home_screen/home_screen.dart';
import '../home_screen/info_page.dart';
import '../profile/profile.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ApiProvider _apiProvider = new ApiProvider();
  AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.green,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.green,
            ),
            child: Center(
              child: Image.asset('assets/icons/img.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child:FutureBuilder<dynamic>(
                    future: _apiProvider.getName(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return   GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: SizedBox(),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Profile()),
                            );
                          },
                          child:       Text(
                            'مرحبا بك ...',
                            style: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                letterSpacing: 0.5,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )


           ,
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: FutureBuilder<dynamic>(
                      future: _apiProvider.getName(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) {
                          return  SizedBox();
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Profile()),
                              );
                            },
                            child: Text(
                              snapshot.data.toString(),
                              style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrders()),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/icons/order-icon-2.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'الطلبات',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            color: AppTheme.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/icons/snapchat-icon.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'الأشعارات',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            color: AppTheme.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: ()async{
                    dynamic data = await  _apiProvider.getPage('get_about_page');
                    if(data['status'] == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PageInfo(page_title: data['page']['title'], page_body:data['page']['text'])),
                      );
                    }

                  },
                  child: Row(
                    children: [
                      Image.asset('assets/icons/info-icon.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'عن التطبيق',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            color: AppTheme.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: ()async{
                    dynamic data = await  _apiProvider.getPage('get_polices_page');
                    if(data['status'] == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PageInfo(page_title: data['page']['title'], page_body:data['page']['text'])),
                      );
                    }

                  },
                  child: Row(
                    children: [
                      Image.asset('assets/icons/info-icon.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'سياسة التطبيق',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            color: AppTheme.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/chat-icon.png'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'تواصل معنا',
                      style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: AppTheme.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/order-icon-2.png'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'طلباتي',
                      style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: AppTheme.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<dynamic>(
                  future: _apiProvider.getName(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return  GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icons/user-icon.png'),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'تسجيل الدخول',
                              style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: AppTheme.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      if (snapshot.data != null) {
                        return GestureDetector(
                          onTap: () async {
                            await _apiProvider.logout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset('assets/icons/logout-icon.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'تسجيل الخروج',
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    letterSpacing: 0.5,
                                    color: AppTheme.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset('assets/icons/user-icon.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    letterSpacing: 0.5,
                                    color: AppTheme.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox( height:MediaQuery.of(context).size.height / 7) ,
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: AppTheme.orange,
                        highlightColor: AppTheme.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                Image.asset('assets/icons/facebook-icon.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        splashColor: AppTheme.orange,
                        highlightColor: AppTheme.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                Image.asset('assets/icons/twitter-icon.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        splashColor: AppTheme.orange,
                        highlightColor: AppTheme.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                                'assets/icons/instagram-icon.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        splashColor: AppTheme.orange,
                        highlightColor: AppTheme.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                Image.asset('assets/icons/snapchat-icon.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'التصميم والتطوير \n بواسطة شركة ايجاد للحلول الرفمية',
                    style: GoogleFonts.getFont(
                      AppTheme.fontName,
                      textStyle: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                        color: AppTheme.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
