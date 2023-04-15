import 'dart:io';
import 'package:flutter_template/data/tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
  final String authority;

  const HttpHelper(this.authority);

  static HttpHelper HttpHelperWithoutAuthority() {
    return HttpHelper("example.odatafy.gang-of-fork.de");
  }

  Future<List> getServiceEntryPoint() async {
    Uri uri = Uri.https(authority, '/');
    http.Response res = await http.get(
      uri,
    );

    return jsonDecode(res.body)["value"] as List;
  }

  getMetadata() async {
    Uri uri = Uri.https(authority, '/\$metadata');
    http.Response res = await http.get(
      uri,
    );

    return jsonDecode(res.body);
  }

  Future<List<Tile>> getMetadataFormatted() async {
    Uri uri = Uri.https(authority, '/\$metadata');
    http.Response res = await http.get(
      uri,
    );

    List<Tile> tiles = [];

    jsonDecode(res.body)["definitions"]?.keys.forEach((key) {
          var json = '{"' +
              key +
              '":' +
              jsonEncode(jsonDecode(res.body)["definitions"][key]) +
              "}";

          tiles.add(Tile.fromJSON(jsonDecode(json)));
        }) ??
        [];

    return tiles;
  }

  getDefinitionMetadata(String path) async {
    Uri uri = Uri.https(authority, '/\$metadata');

    http.Response res = await http.get(
      uri,
    );

    print(jsonDecode(res.body).toString());

    return jsonDecode(res.body)["definitions"][path];
  }

  getData(String path, String search) async {
    Uri uri;
    if (search == "") {
      uri = Uri.parse('https://$authority/$path?\$top=30');
    } else {
      uri = Uri.parse('https://$authority/$path?\$top=30&\$search=$search');
      print(uri.toString());
    }
    print(uri.toString());
    http.Response res = await http.get(
      uri,
    );

    return jsonDecode(res.body)["data"] as List;
  }

  Future<void> updateCategory(String id, Map<String, dynamic> body) async {
    Uri uri = Uri.https(authority, '/categories/$id');
    print('Mein Body: ${jsonEncode(body)}');

    final response = await http.put(
      uri,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      print(response.statusCode);
      print('Category updated successfully');
    } else {
      print('Failed to update category. Status code: ${response.statusCode}');
    }
  }
}
