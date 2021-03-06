import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:openfoodfacts/model/ProductResult.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductsProvider extends ChangeNotifier {
  List<String> _scannedBarcodes = [];

  List<Product> _products = [];
  List<Product> get products => _products;

  Future findProductFromBarcode(String barcode) async {
    // If the camera captures the barcode multiple times in a short span of time,
    // we ensure that we will not add multiple times the same item.
    if (_scannedBarcodes.contains(barcode)) return;

    _scannedBarcodes.add(barcode);

    final ProductResult result =
        await OpenFoodAPIClient.getProduct(barcode, User.LANGUAGE_FR);

    if (result.status != 1) return;

    // Inserted at the first position to be visible from the scanner
    _products.insert(0, result.product);

    notifyListeners();
  }
}
