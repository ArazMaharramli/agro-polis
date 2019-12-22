class UserModel {
  String fullname;
  String profilePictureUrl;
  String city;
  String phoneNumber;
  String uid;
  UserModel(
      {this.fullname,
      this.profilePictureUrl,
      this.city,
      this.phoneNumber,
      this.uid});

  Map<String, String> toMap() {
    return {
      "FullName": this.fullname,
      "ProfilePictureUrl": this.profilePictureUrl,
      "City": this.city,
      "PhoneNumber": this.phoneNumber
    };
  }

  UserModel.fromJson(json){
    if (json != null) {
        this.fullname = json["FullName"];
        this.city = json["City"];
        this.phoneNumber = json["PhoneNumber"];
        this.uid = json["Uid"];
      }
  }
      
}
