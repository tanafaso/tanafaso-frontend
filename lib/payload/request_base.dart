import 'package:azkar/payload/response_error.dart';

abstract class RequestBase<C extends RequestBase<C>> {

  Map<String, dynamic> toJson();

}
