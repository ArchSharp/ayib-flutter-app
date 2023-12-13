class PaymentLinkPayload {
  ICustomer customer;
  String txRef;
  String amount;
  String currency;
  String redirectUrl;
  IMeta meta;
  ICustomizations customization;

  PaymentLinkPayload({
    required this.customer,
    required this.txRef,
    required this.amount,
    required this.currency,
    required this.redirectUrl,
    required this.meta,
    required this.customization,
  });

  // You might want to add a factory constructor to convert from JSON
  factory PaymentLinkPayload.fromJson(Map<String, dynamic> json) {
    return PaymentLinkPayload(
      customer: ICustomer.fromJson(json['customer']),
      txRef: json['tx_ref'],
      amount: json['amount'],
      currency: json['currency'],
      redirectUrl: json['redirect_url'],
      meta: IMeta.fromJson(json['meta']),
      customization: ICustomizations.fromJson(json['customization']),
    );
  }

  // You can also add a method to convert the class instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(),
      'tx_ref': txRef,
      'amount': amount,
      'currency': currency,
      'redirect_url': redirectUrl,
      'meta': meta.toJson(),
      'customization': customization.toJson(),
    };
  }
}

class ICustomer {
  String email;
  String? phoneNumber;
  String name;

  ICustomer({
    required this.email,
    required this.phoneNumber,
    required this.name,
  });

  factory ICustomer.fromJson(Map<String, dynamic> json) {
    return ICustomer(
      email: json['email'],
      phoneNumber: json['phonenumber'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phonenumber': phoneNumber,
      'name': name,
    };
  }
}

class IMeta {
  int consumerId;
  String consumerMac;

  IMeta({
    required this.consumerId,
    required this.consumerMac,
  });

  factory IMeta.fromJson(Map<String, dynamic> json) {
    return IMeta(
      consumerId: json['consumer_id'],
      consumerMac: json['consumer_mac'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consumer_id': consumerId,
      'consumer_mac': consumerMac,
    };
  }
}

class ICustomizations {
  String title;
  String logo;
  String description;

  ICustomizations({
    required this.title,
    required this.logo,
    required this.description,
  });

  factory ICustomizations.fromJson(Map<String, dynamic> json) {
    return ICustomizations(
      title: json['title'],
      logo: json['logo'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'logo': logo,
      'description': description,
    };
  }
}
