class UserAdminModel {
  String phone;
  String titleStore;
  String name;
  String email;
  String uid;

  UserAdminModel(
      {this.phone, this.titleStore, this.email, this.name, this.uid});

  Map<String, dynamic> toMap(String uid) {
    return {
      'uid': uid,
      'phone': phone,
      'titleStore': titleStore,
      'name': name,
      'email': email,
    };
  }
}
