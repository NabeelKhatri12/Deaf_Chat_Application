import 'package:bloc/bloc.dart';
import 'package:deafchatapp/services/auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthMethods _authMethods=AuthMethods();
  AuthCubit() : super(AuthInitial());

  Future<void> appStarted()async{
    try{
     final isSignIn= await _authMethods.isSignIN();
     if (isSignIn){
       emit(Authenticated());
     }else{
       emit(UnAuthenticated());
     }
    }catch(_){
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedIn() async{
    try{
   final uid= await  _authMethods.getCurrentUid();
   emit(Authenticated());
    }catch(_){}
  }
  Future<void> loggedOut() async{
    emit(UnAuthenticated());
  }
}

