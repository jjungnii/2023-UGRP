class Order {
  int orderId;
  String restaurantName;
  String orderTime;
  String orderLink;

  Order(this.orderId, this.restaurantName, this.orderTime, this.orderLink);

  Map<String, dynamic> toJson() => {
        'orderId': orderId.toString(),
        'restaurantName': restaurantName,
        'orderTime': orderTime,
        'orderLink': orderLink
      };

  Order.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        restaurantName = json['restaurantName'],
        orderTime = json['orderTime'],
        orderLink = json['orderLink'];
}
