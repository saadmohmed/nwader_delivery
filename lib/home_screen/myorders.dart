
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader_devlivery/home_screen/notifications.dart';
import 'package:nwader_devlivery/home_screen/orderDetails.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';

class MyOrders extends StatefulWidget {
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? animationController;

  Animation<double>? topBarAnimation;

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();

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
            'الطلبات',
            style: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.darkText,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Notifications()),
                );              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/icons/alert-icon.png'),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(

            children: [
              Row(
                children: [   Container(
                    width: MediaQuery.of(context).size.width/2,
                    decoration: const BoxDecoration(
                      color: AppTheme.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('طلبات جديدة' ,
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: AppTheme.white,
                          ),
                        ),)),
                    ),
                ),
                  Container(
                      width: MediaQuery.of(context).size.width/2,
                      decoration: const BoxDecoration(
                        color: AppTheme.background_c,
                      )
                  ,                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('طلبات تم توصيلها', style: GoogleFonts.getFont(
                      AppTheme.fontName,
                      textStyle: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: AppTheme.green,
                      ),
                    ),)),
                  ),

                  ),                ],
              ),
              Column(
                children: <Widget>[

OrderBody(),
                  OrderBody(),





                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class OrderBody extends StatefulWidget {
  const OrderBody({Key? key}) : super(key: key);

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
    return GestureDetector(
      onTap: ()async{

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
                      height:200,
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
                    child: Image.asset('assets/icons/green-order.png'),
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
                  Text("رقم الطلب  NAQ-3434",   style: GoogleFonts.getFont(
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
                    Row(children: [
                      Text("حالة الطلب : تم التجهيز",   style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          color: AppTheme.white,
                        ),
                      ),),
                         SizedBox(width: MediaQuery.of(context).size.width/8.5,),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        decoration: const BoxDecoration(
                          color: AppTheme.white,
                        ),
                        child: GestureDetector(
                          onTap: ()async{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetails()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('عرض تفاصيل الطلب' ,
                              style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                  letterSpacing: 0.5,
                                  color: AppTheme.green,
                                ),
                              ),)),
                          ),
                        ),
                      )
                    ],),

                ],
              ),
            ),


          ],),
        ),
      ),
    );
  }
}

