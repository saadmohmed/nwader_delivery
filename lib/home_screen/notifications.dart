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


  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
// Create an instance variable.


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
        body: NotificationsStatless(),
      ),
    );
  }

}
class NotificationsStatless extends StatelessWidget {

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child:Column(
        children: [
          FutureBuilder(
            future: _api.get_user_notification(),
            builder: (context, snapshot) {
              // print(data);

              if(snapshot.hasData){
                dynamic data = snapshot.data ;
                print(data);
                if(data['notifications'] != null){
                  return Column(
                      children: data['notifications'].map<Widget>((e) {
                        WidgetsBinding.instance.addPostFrameCallback((_){


                        });

                        return   NotificationBody(title: e['title'], body: e['message'], created_at: e['created_text'],);
                      }).toList()



                  );
                }else{
                  return Center(child: Text("الأشعارت فارغة"),);
                }

              }else{
                return Center(child: CircularProgressIndicator());
              }

            },
          ),
        ],
      ) ,
    );
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key? key , required this.title , required this.body , required this.created_at}) : super(key: key);
  final String title ;
  final String body ;
  final String created_at ;


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
                      top: 2,
                      right: 22,
                      child: Container(
                          height:120,
                          width:3,
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
                      Text(widget.title,   style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: AppTheme.white,
                        ),
                      ),),
                      Text(widget.created_at,   style: GoogleFonts.getFont(
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
                SizedBox(width: MediaQuery.of(context).size.width/4.5,),
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
                child: Text(widget.body),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
