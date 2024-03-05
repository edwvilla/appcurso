import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  static const String kWishlist = "wishlist";

  CollectionReference<Map<String, dynamic>> get collection =>
      instance.collection(kWishlist);

  // create
  createFavorite(Product product) async {
    try {
      final ref = await collection.add(product.toJson());
      log(ref.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  // read all
  Future<List<Product>> getFavorites() async {
    try {
      final data = await collection.get();
      final products = productsFromJson(data.docs);
      return products;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  // update

  // delete

  deleteFavorite(Product product) async {
    final documentId =
        (await collection.where('id', isEqualTo: product.id).get())
            .docs
            .first
            .id;
    return collection.doc(documentId).delete();
  }
}
