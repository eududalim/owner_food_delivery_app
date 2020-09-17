import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  UserAdminModel userAdminModel;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product, this.userAdminModel}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] = List.of(product.data["sizes"]);

      _createdController.add(true);
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "sizes": [],
        "titleStore": userAdminModel.titleStore,
        'adminId': userAdminModel.uid,
        "category": categoryId
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveDescription(String description) {
    unsavedData["description"] = description;
  }

  void savePrice(String price) {
    unsavedData["price"] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData["images"] = images;
  }

  void saveSizes(List sizes) {
    unsavedData["sizes"] = sizes;
  }

  Future<bool> saveProduct() async {
    //  String adminId;
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        unsavedData['adminId'] = userAdminModel.uid;
        unsavedData['titleStore'] = userAdminModel.titleStore;
        unsavedData['category'] = categoryId;
        //add to products list principal
        DocumentReference dr = await Firestore.instance
            .collection("products")
            .add(Map.from(unsavedData)..remove("images"));
        //add reference to list of categorys
        await Firestore.instance
            .collection('category')
            .document(categoryId)
            .collection('items')
            .document(dr.documentID)
            .setData({'productId': dr.documentID});
        //add reference to list of admin products
        await Firestore.instance
            .collection('admins')
            .document(userAdminModel.uid)
            .collection('products')
            .document(dr.documentID)
            .setData({'productId': dr.documentID});
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      print('ERRO: ' + e.toString());
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["images"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
