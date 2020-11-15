import 'response_base.dart';

abstract class RequestBase<C extends RequestBase<C>> {

  Map<String, dynamic> toJson();

}
