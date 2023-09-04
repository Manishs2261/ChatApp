class ChatModel {
  String? msg;
  String? read;
  String? told;
  Type? type;
  String? fromid;
  String? send;

  ChatModel(
      {this.msg, this.read, this.told, this.type, this.fromid, this.send});

  ChatModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image: Type.text;
    fromid = json['fromid'].toString();
    send = json['send'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['told'] = this.told;
    data['type'] = this.type?.name;
    data['fromid'] = this.fromid;
    data['send'] = this.send;
    return data;
  }

}

enum Type{text,image}