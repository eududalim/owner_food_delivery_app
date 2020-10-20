class UserAdminModel {
  String phone;
  String titleStore;
  String cpf;
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
  };

  UserAdminModel(
      {this.phone,
      this.titleStore,
      this.email,
      this.name,
      this.uid,
      this.cpf,
      this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'titleStore': titleStore,
      'name': name,
      'email': email,
      'cpf': cpf,
      'address': address
    };
  }
}
