import 'package:flutter/material.dart';

mixin QuantityManagementMixin<T extends StatefulWidget> on State<T> {
  Map<int, int> _productQuantities = {};

  int getQuantityForProduct(int productId) {
    return _productQuantities[productId] ?? 1;
  }

  void setQuantityForProduct(int productId, int quantity) {
    if (_productQuantities[productId] != quantity && mounted) {
      setState(() {
        _productQuantities[productId] = quantity;
      });
    }
  }

  void incrementQuantity(int productId) {
    int currentQty = getQuantityForProduct(productId);
    setQuantityForProduct(productId, currentQty + 1);
  }

  void decrementQuantity(int productId) {
    int currentQty = getQuantityForProduct(productId);
    if (currentQty > 1) {
      setQuantityForProduct(productId, currentQty - 1);
    }
  }

  void resetQuantities() {
    if (mounted) {
      setState(() {
        _productQuantities.clear();
      });
    }
  }
}