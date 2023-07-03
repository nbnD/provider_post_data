class LoginResponse {
  int? id;
  String? token;
  String? error;

  LoginResponse({this.id, this.token, this.error});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['error'] = error;
    return data;
  }
}
