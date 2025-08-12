class Contact {
  String name;
  String phoneNo;

  Contact(
    this.name,
    this.phoneNo,
  );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phoneNo": phoneNo,
    };
  }


}
