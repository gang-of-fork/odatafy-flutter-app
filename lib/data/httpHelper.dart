import 'dart:io';
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

  getDefinitionMetadata(String path) async {
    Uri uri = Uri.https(authority, '/\$metadata');
    http.Response res = await http.get(
      uri,
    );

    print(jsonDecode(res.body).toString());

    return jsonDecode(res.body)["definitions"][path];
  }

  getData(String path) async {
    Uri uri = Uri.https(authority, path);
    http.Response res = await http.get(
      uri,
    );

    return res.body;
  }
}
