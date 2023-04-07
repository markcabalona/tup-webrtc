// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
final String name;
final String email;
final String profileImgUrl;
final String userID;
  const User({
    required this.name,
    required this.email,
    required this.profileImgUrl,
    required this.userID,
  });

  @override
  List<Object> get props => [name, email, profileImgUrl, userID];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profileImgUrl': profileImgUrl,
      'userID': userID,
    };
  }

  factory User.fromFirebase(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      profileImgUrl: map['profileImgUrl'] as String,
      userID: map['userID'] as String,
    );
  }

  factory User.fromFBAuth(Map<String, dynamic> map){
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      profileImgUrl: map['picture']['data']['url'] as String,
      userID: map['id'] as String,
    );
  }
}
