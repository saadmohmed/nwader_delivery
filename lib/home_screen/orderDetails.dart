
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import 'navigation_screen.dart';
import 'notifications.dart';
import 'order_tracking_page.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key , required this.order}) : super(key: key);
  final dynamic order ;
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
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
    print(widget.order);
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            'تفاصيل الطلب',
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

            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppTheme.background_c,
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("رقم الطلب ${widget.order['order_number']}",   style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: AppTheme.darkText,
                          ),
                        ),),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text(" حالة الطلب: ",   style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: AppTheme.darkText,
                                ),
                              ),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text("${widget.order['status']} ",   style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: AppTheme.orange,
                                ),
                              ),),
                            ),

                            SizedBox(width: MediaQuery.of(context).size.width/4,),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.background_c,
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => OrderDetails()),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(),
                                ),
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                  )
                  ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppTheme.background_c,
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("بيانات صاحب  الطلب",   style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: AppTheme.darkText,
                          ),
                        ),),
                        Text("الاسم : ${widget.order['name']}",   style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: AppTheme.darkText,
                          ),
                        ),),

                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text("الجوال : ",   style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: AppTheme.darkText,
                                ),
                              ),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text("${widget.order['mobile']}",   style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: AppTheme.orange,
                                ),
                              ),),
                            ),

                            SizedBox(width: MediaQuery.of(context).size.width/4,),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.green,
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => OrderDetails()),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.phone ,color: AppTheme.white,)),
                                ),
                              ),
                            )

                          ],
                        ),
                        Text("الوقت المحتمل للتوصيل",   style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: AppTheme.darkText,
                          ),
                        ),),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Text("${widget.order['expected_delivery_date']}",   style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                  color: AppTheme.darkText,
                                ),
                              ),),
                            ),


                            SizedBox(width: MediaQuery.of(context).size.width/12,),
                            widget.order["status_id"] == 4 ?    Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.orange,
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  print('llll' +widget.order.toString());
                                  if(widget.order['address']['lat'] > 0 && widget.order['address']['lng']  > 0){
                                    Location location = Location();
                                    location.getLocation().then((location){
                                      print(location.longitude);
                                      print(widget.order['address']['lat']);
                                      if(location != null){
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>NavigationScreen(widget.order['address']['lat'] ,widget.order['address']['lat'],
                                        //       LatLng(location!.latitude! , location!.longitude!))),
                                        // );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OrderTrackingPage(latlng: LatLng(widget.order['address']['lat'] ,
                                                  widget.order['address']['lng']), order_id: widget.order['id'].toString(),myLocation:LatLng(location!.latitude! , location!.longitude!))),
                                        );
                                      }

                                    });

                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.location_on_outlined ,color: AppTheme.white,)),
                                ),
                              ),
                            ) : SizedBox()

                          ],
                        ),

                      ],
                    ),
                  )
                  ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppTheme.background_c,
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                     widget.order["status_id"] == 3 ?   GestureDetector(
                       onTap: ()async{
                         dynamic data = await _api.change_order_status(widget.order['id'].toString());
                         print(data);
                         if(data['status'] == true){
                           dynamic data = await _api.get_order(widget.order['id'].toString());
                           if(data['status'] == true){

                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(
                                   builder: (context) => OrderDetails(order: data['order'],)),
                             );
                           }
                         }
                       },
                       child: Container(
                    decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: AppTheme.green,
                ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text('بدا التوصيل' ,
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    color: AppTheme.white,
                                  ),
                                ),)),
                            ),
                          ),
                     ) : SizedBox(),
                        widget.order["status_id"] == 4 ?      GestureDetector(
                          onTap: ()async{
                            dynamic data = await _api.change_order_status(widget.order['id'].toString());
                            print(data);
                            if(data['status'] == true){
                              dynamic data = await _api.get_order(widget.order['id'].toString());
                              if(data['status'] == true){

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetails(order: data['order'],)),
                                );
                              }
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              color: AppTheme.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text('تم الأستلام' ,
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    color: AppTheme.white,
                                  ),
                                ),)),
                            ),
                          ),
                        ) : SizedBox(),

                      ],
                    ),
                  )
                  ,),
              ),

            ],
          ),
        ),
      ),
    );
  }

}

