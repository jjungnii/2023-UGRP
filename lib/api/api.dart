class API {
  static const hostConnect = "http://192.168.0.103/api_delivery"; //IPV4 주소 할당
  static const hostConnectDelivery = "$hostConnect/delivery";

  static const addOrder = "$hostConnect/delivery/addOrder.php";
  static const getOrders = "$hostConnect/delivery/getOrders.php";

  static const addItem = "$hostConnect/storage/addItem.php";
  static const getItems = "$hostConnect/storage/getItems.php";
}
