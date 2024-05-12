import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'package:semsar/Models/add_new_house_model.dart';
import 'package:semsar/Models/get_house.dart';
import 'package:http/http.dart' as http;
import 'package:semsar/Models/search_values_model.dart';
import 'package:semsar/constants/backend_url.dart';
import 'package:semsar/constants/tokens.dart';
import 'package:semsar/services/Authentication/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseServices {
  final Authentication _auth = Authentication();

  Future<bool> refreshToken() async {
    final pref = await SharedPreferences.getInstance();

    final refToken = pref.getString("refreshToken");

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "refreshToken": refToken,
          },
        ),
      );
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['accessToken'];

        final refreshToken = jsonDecode(response.body)['refreshToken'];

        Tokens.token = token;

        Tokens.refToken = refreshToken;

        await pref.setString('token', token);

        await pref.setString('refreshToken', refreshToken);

        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  //get requests
  Future<List<GetHouse>> getAllHouses(String city, SearchFilter filters) async {
    Authentication auth = Authentication();

    final userId = await auth.getUserId();
    // ignore: avoid_print
    print(Tokens.token ?? "");

    final Map<String, dynamic> query = {
      'userId': userId,
      'city': city,
      'category': filters.category,
      'stars': (filters.stars != null && filters.stars! > 1)
          ? (filters.stars! - 2).toString()
          : null,
      'min': (filters.min == 0) ? null : filters.min?.toString(),
      'max': (filters.max == 0) ? null : filters.max?.toString(),
    };
    try {
      final response = await http.get(
        Uri.parse(
          '$backendUrl/api/Houses',
        ).replace(
          queryParameters: query,
        ),
        headers: {
          "Authorization": 'Bearer ${Tokens.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<GetHouse> houses = await Isolate.run(
          () {
            final List<dynamic> body = json.decode(response.body);

            return body
                .map(
                  (dynamic item) => GetHouse.fromJson(item),
                )
                .toList();
          },
        );
        return houses;
      } else if (response.statusCode == 401) {
        final bool isRefreshed = await refreshToken();

        if (isRefreshed) {
          return await getAllHouses(city, filters);
        }
      }
      final body = jsonDecode(response.body);

      throw Exception(body);
    } catch (e) {
      return [];
    }
  }

  Future<List<GetHouse>> getHouseByCategory(String category) async {
    if (Tokens.token == null) {
      await refreshToken();
    }
    try {
      final token = Tokens.token;

      final response = await http.get(
        Uri.parse(
          '$backendUrl/api/houses/GetByCategory?Category=$category',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);

        return body
            .map(
              (items) => GetHouse.fromJson(
                items,
              ),
            )
            .toList();
      } else if (response.statusCode == 401) {
        await refreshToken();

        return await getHouseByCategory(category);
      }
      throw Exception(
        '${response.statusCode}',
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getHouseMedia(int houseId, int excludedMediaId) async {
    final token = Tokens.token;
    if (token == null) {
      refreshToken();
    }
    try {
      final response = await http.get(
        Uri.parse(
          '$backendUrl/api/Houses/GetMedia',
        ).replace(
          queryParameters: {
            'HouseId': '$houseId',
            'excludedMediaId': '$excludedMediaId',
          },
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((e) => e['media']).toList();
      }
      throw Exception(response.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<GetHouse>> getSavedHouses() async {
    final token = Tokens.token;

    if (token == null) {
      await refreshToken();
    }
    try {
      final userId = await _auth.getUserId();

      final response = await http.get(
        Uri.parse(
          '$backendUrl/api/Houses/GetSavedHouses',
        ).replace(
          queryParameters: {'userId': userId},
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> savedHouses = jsonDecode(response.body);

        return savedHouses.map((e) => GetHouse.fromJson(e)).toList();
      }
      if (response.statusCode == 401) {
        return await getSavedHouses();
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<GetHouse>> getMyPosts() async {
    final token = Tokens.token;

    if (token == null) {
      await refreshToken();
    }
    try {
      final userId = await _auth.getUserId();

      final response = await http.get(
        Uri.parse(
          '$backendUrl/api/Houses/GetMyPosts',
        ).replace(
          queryParameters: {'userId': userId},
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> savedHouses = jsonDecode(response.body);

        return savedHouses.map((e) => GetHouse.fromJson(e)).toList();
      }
      if (response.statusCode == 401) {
        return await getSavedHouses();
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //post requests;
  Future<bool> uploadHouse(AddNewHouseModel newHouse) async {
    final token = Tokens.token;

    if (token == null) {
      await refreshToken();
    }
    try {
      final jsonData = jsonEncode(newHouse.toJson());
      final response = await http.post(
        Uri.parse(
          '$backendUrl/api/houses/AddHouse',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        await refreshToken();

        return await uploadHouse(
          newHouse,
        );
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> savePost(int houseId) async {
    final token = Tokens.token;
    if (token == null) {
      await refreshToken();
    }

    try {
      final userId = await _auth.getUserId();

      final encodedBody = jsonEncode(
        {
          'userId': userId,
          'houseId': houseId,
        },
      );

      final response = await http.post(
        Uri.parse(
          '$backendUrl/api/Houses/SaveHouse',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        if (response.body == "Saved") {
          return true;
        } else {
          return false;
        }
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> checkIfSaved(int houseId) async {
    final token = Tokens.token;
    if (token == null) {
      await refreshToken();
    }

    try {
      final userId = await _auth.getUserId();

      final encodedBody = jsonEncode(
        {
          'userId': userId,
          'houseId': houseId,
        },
      );

      final response = await http.post(
        Uri.parse(
          '$backendUrl/api/Houses/CheckIfSaved',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //put requests
  Future<bool> updateHouse(int houseId, AddNewHouseModel newHouse) async {
    final token = Tokens.token;
    if (token == null) {
      await refreshToken();
    }
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/api/Houses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'houseId': houseId,
            ...newHouse.toJson(),
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        await refreshToken();
        return updateHouse(houseId, newHouse);
      }
      throw Exception(response.body);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
