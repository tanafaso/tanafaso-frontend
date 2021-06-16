import 'package:azkar/net/payload/response_base.dart';

class FacebookFriendsResponse extends ResponseBase {
  List<FacebookFriend> facebookFriends;
  Paging paging;
  Summary summary;

  FacebookFriendsResponse({this.facebookFriends, this.paging, this.summary});

  FacebookFriendsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      facebookFriends = [];
      json['data'].forEach((v) {
        facebookFriends.add(new FacebookFriend.fromJson(v));
      });
    }
    paging =
        json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.facebookFriends != null) {
      data['data'] = this.facebookFriends.map((v) => v.toJson()).toList();
    }
    if (this.paging != null) {
      data['paging'] = this.paging.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary.toJson();
    }
    return data;
  }
}

class FacebookFriend {
  String name;
  String id;

  FacebookFriend({this.name, this.id});

  FacebookFriend.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class Paging {
  Cursors cursors;

  Paging({this.cursors});

  Paging.fromJson(Map<String, dynamic> json) {
    cursors =
        json['cursors'] != null ? new Cursors.fromJson(json['cursors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cursors != null) {
      data['cursors'] = this.cursors.toJson();
    }
    return data;
  }
}

class Cursors {
  String before;
  String after;

  Cursors({this.before, this.after});

  Cursors.fromJson(Map<String, dynamic> json) {
    before = json['before'];
    after = json['after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['before'] = this.before;
    data['after'] = this.after;
    return data;
  }
}

class Summary {
  int totalCount;

  Summary({this.totalCount});

  Summary.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    return data;
  }
}
