import 'package:flutter/cupertino.dart';

import '../../request_base.dart';

class AddGroupRequestBody extends RequestBodyBase {
  final String name;

  AddGroupRequestBody({@required this.name});

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
