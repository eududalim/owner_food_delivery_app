class UserAdminModel {
  String phone;
  String titleStore;
  String name;
  String email;
  String uid;
  Map address = {
    'cidade': '',
    'bairro': '',
    'estado': '',
    'complemento': '',
    'referencia': '',
    'rua': '',
    'numRua': '',
  };

  UserAdminModel(
      {this.phone,
      this.titleStore,
      this.email,
      this.name,
      this.uid,
      this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'titleStore': titleStore,
      'name': name,
      'email': email,
      'address': address
    };
  }
}
