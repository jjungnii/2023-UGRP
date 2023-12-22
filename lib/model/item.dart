class Item {
  int itemId;
  int studentId;
  String itemLocation;
  String itemDate;
  String itemCategory;

  Item(this.itemId, this.studentId, this.itemLocation, this.itemDate,
      this.itemCategory);

  Map<String, dynamic> toJson() => {
        'itemId': itemId.toString(),
        'studentId': studentId.toString(),
        'itemLocation': itemLocation,
        'itemDate': itemDate,
        'itemCategory': itemCategory
      };

  Item.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        studentId = json['studentId'],
        itemLocation = json['itemLocation'],
        itemDate = json['itemDate'],
        itemCategory = json['itemCategory'];
}
