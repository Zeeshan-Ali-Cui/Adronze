class Userdata {
  String? id;
  String? Name;
  String? Email;
  String? Lat;
  String? Long;
  String? img;

  Userdata( this.id, this.Name, this.Email, this.Lat, this.Long, this.img);

  Userdata.fromjson(Map<String, dynamic> json){
    id = json["id"];
    Name = json["Name"];
    Email = json["Email"];
    Lat = json["Lat"];
    Long = json["Long"];
    img = json["img"] ?? '';
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.Name;
    data['Email']= this.Email;
    data['Lat']= this.Lat;
    data['Long']= this.Long;
    data['img'] = this.img;
    return data;
  }

}

// List<User> Userdata = [
//   User(id: 1, Name: "Zeeshan", Email: "email@gmail.com"),
//   User(id: 2, Name: "Ali", Email: "newemail@gmail.com")
// ]; //list that stores objects


// void main() {
//   for (var item in Userdata) {
//     print(item.id);
//     print(item.Name);
//     print(item.Email);
//   }
// }
