class InvoiceResponseModel {
  final bool? success;
  final String? message;
  final String? invoiceNo;
  final String? invoiceUrl;

  InvoiceResponseModel({
    this.success,
    this.message,
    this.invoiceNo,
    this.invoiceUrl,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoiceResponseModel(
      success: json['success'],
      message: json['message'],
      invoiceNo: json['invoice_no'],
      invoiceUrl: json['invoice_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'invoice_no': invoiceNo,
      'invoice_url': invoiceUrl,
    };
  }
}
