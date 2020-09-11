class UserAdminModel {
  String cpf;
  String nameStore;
  String name;
  String email;
  String password;
  String uid;

  UserAdminModel(
      {this.cpf,
      this.nameStore,
      this.email,
      this.name,
      this.password,
      this.uid});

  Map<String, dynamic> toMap(String uid) {
    return {
      'uid': uid,
      'cpf': cpf,
      'nameStore': nameStore,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
