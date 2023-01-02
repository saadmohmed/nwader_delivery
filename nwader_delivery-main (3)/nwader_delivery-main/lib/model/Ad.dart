class Ad {
  dynamic id;

  dynamic title;

  dynamic image;


  Ad({this.id ,this.title,this.image});

  factory Ad.fromJson(Map<String , dynamic> json){
    return Ad(
      id : json["id"],
      title:  json["name"],
      image:  json["image"],


    );
  }

}