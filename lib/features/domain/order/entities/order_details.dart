class OrderDetails {
  final int id;
  final String code;
  final int userId;
  final ShippingAddress shippingAddress;
  final String paymentType;
  final String paymentStatus;
  final String paymentStatusString;
  final String deliveryStatus;
  final String deliveryStatusString;
  final String grandTotal;
  final double planeGrandTotal;
  final String couponDiscount;
  final String shippingCost;
  final String subtotal;
  final String tax;
  final String date;
  final bool cancelRequest;

  OrderDetails({
    required this.id,
    required this.code,
    required this.userId,
    required this.shippingAddress,
    required this.paymentType,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
    required this.grandTotal,
    required this.planeGrandTotal,
    required this.couponDiscount,
    required this.shippingCost,
    required this.subtotal,
    required this.tax,
    required this.date,
    required this.cancelRequest,
  });
}

class ShippingAddress {
  final String name;
  final String? email;
  final String address;
  final String country;
  final String state;
  final String city;
  final String postalCode;
  final String phone;

  ShippingAddress({
    required this.name,
    this.email,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'] ?? '',
      email: json['email'],
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}