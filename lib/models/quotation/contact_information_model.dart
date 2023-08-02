class ContactInformationModel {
  String? companyName;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? remarks;
  Map<String, dynamic> toJson() => {
        'company': companyName,
        'mobile': mobile,
        'contactPerson': name,
        'address': address,
        'email': email,
        'remarks': remarks,
      };
  factory ContactInformationModel.fromJson(Map<String, dynamic> map) =>
      ContactInformationModel(
        companyName: map['company'],
        name: map['contactPerson'],
        mobile: map['mobile'],
        address: map['address'],
        email: map['email'],
        remarks: map['remarks'],
      );
  ContactInformationModel({
    this.companyName,
    this.name,
    this.mobile,
    this.email,
    this.address,
    this.remarks,
  });
}
