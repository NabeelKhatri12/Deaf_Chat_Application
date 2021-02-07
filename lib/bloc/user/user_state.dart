part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
  
  
  
  
  
  Stream<List<UserEntity>> getAllUsers(){
   final userColl= Firestore.instance.collection("users");
   final da=userColl.snapshots().map((event) => null);

       final data= userColl.snapshots().map((event) => event.documents.map((e) {
          return UserEntity.fromSnapshot(e);
        })).toList();

  }
}

class UserEntity{
  final name;
  final email;

  UserEntity({this.name, this.email});


  factory UserEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return UserEntity(
      name: snapshot.data['name'],
      email: snapshot.data['email'],
    );
  }

}

