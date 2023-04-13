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

  getData(String path, String search, List filter) async {
    Uri uri;
    String filterString = "";
    if (filter.isNotEmpty) {
      filterString = "\$filter=";
      var counter = 0;
      for (var expr in filter) {
        counter = counter + 1;
        if (counter != filter.length) {
          filterString +=
              "${expr.toString().replaceFirst("=", "eq").replaceFirst("≠", "ne").replaceFirst("<", "lt").replaceFirst(">", "gt").replaceFirst("≤", "le").replaceFirst("≥", "ge")} and ";
        } else {
          filterString += expr
              .toString()
              .replaceFirst("=", "eq")
              .replaceFirst("≠", "ne")
              .replaceFirst("<", "lt")
              .replaceFirst(">", "gt")
              .replaceFirst("≤", "le")
              .replaceFirst("≥", "ge");
        }
      }
    }

    if (search == "") {
      String searchParse = 'https://$authority/$path?';
      if (filterString != "") {
        searchParse += filterString;
      }
      uri = Uri.parse(searchParse);
    } else {
      String searchParse = 'https://$authority/$path?\$search=$search';
      if (filterString != "") {
        searchParse += "&" + filterString;
      }
      uri = Uri.parse(searchParse);
    }
    print(uri.toString());
    http.Response res = await http.get(
      uri,
    );

    return (jsonDecode(res.body)["data"] ?? []) as List;
  }
}
