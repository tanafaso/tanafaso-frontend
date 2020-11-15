import '../../response_base.dart';

class GetAzkarResponse extends ResponseBase {
  List<String> azkar;

  static GetAzkarResponse fromJson(Map<String, dynamic> json) {
    GetAzkarResponse response = new GetAzkarResponse();
    response.setError(json);

    response.azkar = json['data'].cast<String>();
    return response;
  }
}
