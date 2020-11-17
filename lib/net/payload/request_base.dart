abstract class RequestBodyBase<C extends RequestBodyBase<C>> {
  Map<String, dynamic> toJson();
}
