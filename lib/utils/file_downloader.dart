import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

downloadFile(var filePath, var documentUrl) async {
  try {
    /// setting filename
    final filename = filePath;
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (await File('$dir/$filename').exists()) return File('$dir/$filename');

    String url = documentUrl;

    /// requesting http to get url
    var request = await HttpClient().getUrl(Uri.parse(url));

    /// closing request and getting response
    var response = await request.close();

    /// getting response data in bytes
    var bytes = await consolidateHttpClientResponseBytes(response);

    /// generating a local system file with name as 'filename' and path as '$dir/$filename'
    File file = new File('$dir/$filename');

    /// writing bytes data of response in the file.
    await file.writeAsBytes(bytes);

    return file;
  } catch (err) {
    print(err);
  }
}
