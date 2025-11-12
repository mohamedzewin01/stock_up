class AddBarcodeEntity {
  final String? status;

  final String? message;

  final int? productId;

  final String? barcode;

  final String? barcodeType;

  final int? unitQuantity;

  final double? unitPrice;

  AddBarcodeEntity({
    this.status,
    this.message,
    this.productId,
    this.barcode,
    this.barcodeType,
    this.unitQuantity,
    this.unitPrice,
  });
}

class DeleteBarcodeEntity {
  final String? status;

  final String? message;

  final int? productId;

  final String? barcode;

  DeleteBarcodeEntity({
    this.status,
    this.message,
    this.productId,
    this.barcode,
  });
}
