
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../CONSTANT.dart';
import '../model/Ad.dart';

class ApiProvider {
  Future<List<Ad>> ads() async {
    List<Ad> ads = [];

    final http.Response response = await http.get(
      Uri.parse('${ADS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      body["ads"].forEach((elemnt) {
        ads.add(new Ad(
          id: elemnt['id'],
          title: elemnt['title'],
          image: elemnt['preview'],
        ));
      });
    }
    return ads;
  }

  Future cat_wtith_products() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    dynamic url =  Uri.parse('${CAT_WITH_PRODUCTS}');
    if(user_id != null){
      Uri.parse('${CAT_WITH_PRODUCTS}?user_id='+user_id!);
    }

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['cats'];
      }
      return null;
    }
    return null;
  }

  Future getProductData(String id) async {
    final storage = new FlutterSecureStorage();
  final api_token = await storage.read(
  key: 'token',
  );
    final http.Response response = await http.get(
      Uri.parse('${PRODUCT_DATA}?product_id=' + id),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['product'];
      }
      return null;
    }
    return null;
  }
  Future add_to_favorite(String product_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final http.Response response = await http.post(
      Uri.parse('${ADD_TO_FAVORITE}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'product_id': product_id,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future get_user_favorite() async {
      final storage = new FlutterSecureStorage();
        final api_token = await storage.read(
          key: 'token',
        );
      final user_id = await storage.read(
        key: 'id',
      );
      dynamic url =  Uri.parse('${GET_FAVORITES}');
      if(user_id != null){
     url =    Uri.parse('${GET_FAVORITES}?user_id='+user_id!);
      }
    final http.Response response = await http.get(
    url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
      print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future get_user_cart() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${CAT_WITH_PRODUCTS}');
    if(user_id != null){
      Uri.parse('${GET_CART}?user_id='+user_id!);
    }
    final http.Response response = await http.get(
    url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future add_to_cart(String product_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${CAT_WITH_PRODUCTS}');
    if(user_id != null){
      Uri.parse('${ADD_TO_CART}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'product_id': product_id,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future update_password(String new_password , String old_password ) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${UPDATE_PASSWORD}');
    if(user_id != null){
      url =    Uri.parse('${UPDATE_PASSWORD}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'old_password': old_password,
        'new_password': new_password,


      },
    );
    print(json.decode(response.body));
    return json.decode(response.body);

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   if (data['status'] == true) {
    //     return data;
    //   }
    //   return null;
    // }
    // return null;
  }

  Future update_profile(String name , String email , String phone ) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${UPDATE_PROFILE}');
    if(user_id != null){
   url =    Uri.parse('${UPDATE_PROFILE}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'name': name,
        'email': email,
        'mobile': phone,

      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future get_products(String category_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final http.Response response = await http.get(
      Uri.parse('${GET_PRODUCTS}?category_id='+category_id),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future get_categoires() async {
    final http.Response response = await http.get(
      Uri.parse('${CATEGORES}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['categories'];
      }
      return null;
    }
    return null;
  }

  Future login(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('${LOGIN_API}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: {
        'username': email,
        'password': password,
      },
    );

      return json.decode(response.body);

    return null;
  }

  // Future check_coupon(dynamic code) async {
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   final http.Response response = await http.post(
  //     Uri.parse('${CHECKCOUPON}?api_token=$api_token'),
  //     headers: <String, String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //     body: {
  //       'coupon':code
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   }
  //   return null;
  // }
  // Future add_to_cart(String book_id) async {
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   final http.Response response = await http.post(
  //     Uri.parse('${ADD_TO_CART}?api_token=$api_token'),
  //     headers: <String, String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //     body: {
  //       'book_id': book_id,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   }
  //   return null;
  // }
  // Future<List<Book>> mybooks( ) async{
  //
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   List<Book> books = [];
  //   final http.Response response = await http.get(
  //     Uri.parse(MY_BOOKS+"?api_token="+api_token!),
  //     headers:<String , String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //
  //   );
  //   if (response.statusCode == 200) {
  //
  //     dynamic body = json.decode(response.body);
  //     body["data"].forEach((elemnt){
  //       books.add(new Book(
  //           id: elemnt['id'],
  //           title: elemnt['title'] ,
  //           price: elemnt["price"],
  //           image: elemnt['preview'],
  //           discount: elemnt["price"],
  //           data_file: elemnt["file_data"],
  //           content: elemnt["content"]
  //
  //       ));
  //
  //     });
  //
  //
  //   }
  //   return books;
  // }
  // Future<List<Book>> getCart( ) async{
  //
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   List<Book> books = [];
  //   final http.Response response = await http.get(
  //     Uri.parse(CART+"?api_token="+api_token!),
  //     headers:<String , String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //
  //   );
  //   if (response.statusCode == 200) {
  //     dynamic body = json.decode(response.body);
  //     body["data"].forEach((elemnt){
  //       elemnt = elemnt['book'];
  //       books.add(new Book(
  //           id: elemnt['id'],
  //           title: elemnt['title'] ,
  //           price: elemnt["price"],
  //           image: elemnt['preview'],
  //           discount: elemnt["price"],
  //           data_file: elemnt["file_data"],
  //           content: elemnt["content"]
  //
  //       ));
  //
  //     });
  //
  //
  //   }
  //   return books;
  // }
  // Future add_order() async {
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   final http.Response response = await http.post(
  //     Uri.parse('${ADD_ORDER}?api_token='+api_token!),
  //     headers: <String, String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //     body: {
  //       'make_order': "true",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   }
  //   return null;
  // }
  //
  // Future<List<Book>> getBooks(dynamic type  ,dynamic limit ) async{
  //
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   List<Book> books = [];
  //   final http.Response response = await http.get(
  //     Uri.parse(BOOKS+"?api_token="+api_token!),
  //     headers:<String , String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //
  //   );
  //   if (response.statusCode == 200) {
  //
  //
  //     dynamic body = json.decode(response.body);
  //     body["data"].forEach((elemnt){
  //       books.add(new Book(
  //           id: elemnt['id'],
  //           title: elemnt['title'] ,
  //           price: elemnt["price"],
  //           image: elemnt['preview'],
  //           discount: elemnt["price"],
  //           data_file: elemnt["file_data"],
  //           content: elemnt["content"]
  //
  //       ));
  //
  //     });
  //
  //
  //   }
  //   return books;
  // }
  // Future<Book> book(dynamic id  ) async{
  //
  //   final storage = new FlutterSecureStorage();
  //   final api_token = await storage.read(
  //     key: 'api_token',
  //   );
  //   Book book = new Book() ;
  //   final http.Response response = await http.get(
  //     Uri.parse(BOOKS+"?api_token="+api_token!+'&id='+id),
  //     headers:<String , String>{
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Access-Control-Allow-Origin': '*'
  //     },
  //
  //   );
  //   if (response.statusCode == 200) {
  //
  //
  //     dynamic body = json.decode(response.body);
  //     body["data"].forEach((elemnt){
  //       book = new Book(
  //           id: elemnt['id'],
  //           title: elemnt['title'] ,
  //           price: elemnt["price"],
  //           image: elemnt['preview'],
  //           discount: elemnt["price"],
  //           data_file: elemnt["file_data"],
  //           content: elemnt["content"]
  //
  //       );
  //
  //     });
  //
  //
  //   }
  //   return book;
  // }
  //
  Future<dynamic> user() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    try {
      final http.Response response = await http.get(
        Uri.parse(USER_API +'?user_id='+user_id!),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  Future getName() async {
    final storage = new FlutterSecureStorage();
    final name = await storage.read(
      key: 'name',
    );
    return name;
  }
  Future get_token() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(
      key: 'token',
    );
    return token;
  }



  Future getUserAddress() async {
    final storage = new FlutterSecureStorage();
    final addresses = await storage.read(
      key: 'addresses',
    );
    return jsonDecode(addresses!);
  }

  Future logout() async {
    final storage = new FlutterSecureStorage();
     await storage.deleteAll();

    return true;
  }

  Future register(String phone, String password, String name) async {
    final http.Response response = await http.post(
      Uri.parse('${REGISTER_API}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: {'mobile': phone, 'password': password, 'name': name},
    );

    return json.decode(response.body);
  }
}
