import 'dart:ffi';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with TickerProviderStateMixin {
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
            'الأشعارات',
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
                Navigator.pop(context,true);
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
              NotificationBody(),
              NotificationBody(),
              NotificationBody(),
              NotificationBody(),





            ],
          ),
        ),
      ),
    );
  }

}

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _visiable = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ()async{
            setState(() {
              if(_visiable == false){
                _visiable = true ;

              }else{
                _visiable = false ;

              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppTheme.green,
              ),
              child: Row(children: [
                Stack(
                  children: [
                    Container(
                        height:90,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.all(Radius.circular(10)),

                        )),
                    Positioned(
                      top: 0,
                      right: 22,
                      child: Container(
                          height:160,
                          width:2,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: AppTheme.white,
                          )),
                    ),

                    Positioned(
                      top: 30,
                      right: 10,
                      child: Container(    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: AppTheme.redAcc,
                      ),child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.notifications , color: AppTheme.green,),
                      )),
                    ),
                  ],
                ),
                SizedBox(width: 9,) ,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("لقد تم قبول طلبك رقم 7676",   style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: AppTheme.white,
                        ),
                      ),),
                      Text("12/98/2022     98:98 am",   style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.5,
                          color: AppTheme.grey,
                        ),
                      )),

                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width/8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Icon(Icons.arrow_downward_sharp , size: 30,color: AppTheme.white,),
                ),

              ],),
            ),
          ),
        ),
        Visibility(
          visible: _visiable,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppTheme.background_c,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("لقد تم قبول طلبك رقم 7676"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
