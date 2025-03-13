class EAForYouModel {
  String? hashtag;
  String? name;
  double? rating;
  String? add;
  String? attending;
  String? time;
  String? image;
  String? price;
  double? distance;
  bool? fev;

  EAForYouModel({this.hashtag, this.name, this.rating, this.add, this.attending, this.time, this.image, this.distance, this.price, this.fev = false});

  get country => null;

  static fromJson(eventJson) {}
}

class EAMessageModel {
  int? senderId;
  int? receiverId;
  String? msg;
  String? time;

  EAMessageModel({this.senderId, this.receiverId, this.msg, this.time});
}

class EAForYouModel2 {
  String? id;
  String? name;
  String? email;
  String? image;
  String? status;
  String? country;
  String? event;
  String? payment;

  EAForYouModel2({
    this.id,
    this.name,
    this.email,
    this.image,
    this.status,
    this.country,
    this.event,
    this.payment,
  });

  // Factory method to create an instance of EAForYouModel from JSON
  factory EAForYouModel2.fromJson(Map<String, dynamic> json) {
    return EAForYouModel2(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      status: json['status'],
      country: json['country'],
      event: json['Event'],
      payment: json['Paymnet'],
    );
  }
}

