
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../CONSTANT.dart';
import '../model/Ad.dart';

class ApiProvider {
  Future getPage(page) async {
    final storage = new FlutterSecureStorage();

    final http.Response response = await http.get(
      Uri.parse('${GET_PAGE}/'+page),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
    return null;
  }
  Future get_config() async {
    final storage = new FlutterSecureStorage();

    final http.Response response = await http.get(
      Uri.parse('${CONFIGURATION}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
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
  Future update_driver_location(String lat , String lng) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${UPDATE_DRIVER_LOCATION}');
    if(user_id != null){
      url =   Uri.parse('${UPDATE_DRIVER_LOCATION}?driver_id='+user_id!);
    }
    final http.Response response = await http.post(
      Uri.parse('${CHANGE_ORDER_STATUS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
      body: {
        'driver_id': user_id,
        'lat': lat,
        'lng':lng
      },
    );

    return json.decode(response.body);

    return null;
  }

  Future change_order_status(String order_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${GET_ORDERS}');
    if(user_id != null){
      url =   Uri.parse('${CHANGE_ORDER_STATUS}?driver_id='+user_id!);
    }
    final http.Response response = await http.post(
      Uri.parse('${CHANGE_ORDER_STATUS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
      body: {
        'driver_id': user_id,
        'order_id': order_id,
      },
    );

    return json.decode(response.body);

    return null;
  }

  Future login(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('${LOGIN_API}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',

      },
      body: {
        'drivername': email,
        'password': password,
      },
    );

      return json.decode(response.body);

    return null;
  }

  Future get_order(String id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final http.Response response = await http.get(
      Uri.parse('${GET_ORDER_DETAILS}?order_id=' + id),
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
  Future get_driver_order() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${GET_ORDERS}');
    if(user_id != null){
      url =   Uri.parse('${GET_ORDERS}?driver_id='+user_id!);
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
      }else if(data['status'] == true){
        return data;
      }
      return null;
    }else{
      return json.decode(response.body);

    }
    return null;
  }
  Future get_user_notification() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    dynamic url =  Uri.parse('${USER_NOTIFICATION}');
    if(user_id != null){
      url =    Uri.parse('${USER_NOTIFICATION}?driver_id='+user_id!);
    }
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;

    }
    return null;
  }
  Future get_driver_archieved_order() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${GET_ARCHIEVED_ORDERS}');
    if(user_id != null){
      url =   Uri.parse('${GET_ARCHIEVED_ORDERS}?driver_id='+user_id!);
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
      }else if(data['status'] == true){
        return data;
      }
      return null;
    }else{
      return json.decode(response.body);

    }
    return null;
  }

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
