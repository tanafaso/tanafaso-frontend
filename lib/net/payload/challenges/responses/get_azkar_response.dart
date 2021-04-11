import 'package:azkar/models/zekr.dart';

import '../../response_base.dart';

class GetAzkarResponse extends ResponseBase {
  List<Zekr> azkar;

  static GetAzkarResponse fromJson(Map<String, dynamic> json) {
    GetAzkarResponse response = new GetAzkarResponse();
    response.setError(json);

    if (response.hasError()) {
      return response;
    }

    response.azkar = [];
    for (var listItem in json['data']) {
      response.azkar.add(Zekr.fromJson(listItem));
    }
    return response;
  }
}
