import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Ad.dart';

class HomeSlider extends StatelessWidget {
final  List<Ad> ads ;
  const HomeSlider({Key? key , required this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _current = 0;
    final CarouselController _controller = CarouselController();

    return CarouselSlider(
        carouselController: _controller,

        options: CarouselOptions(height: 200.0,autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 3.0,
          viewportFraction: 1.0,

        ),

        items: ads.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage("https://nwader.ejad-dev.com/banner.png"),
                        fit: BoxFit.fill),
                    color: Colors.amber,borderRadius: BorderRadius.circular(15.0),
                  ),

                  child: Text(
                    '',
                    style: TextStyle(fontSize: 16.0),
                  )
              );
            },
          );
        }).toList());
  }
}
