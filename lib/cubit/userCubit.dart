import 'package:bloc/bloc.dart';

class UserCubit extends Cubit<String?> {
  UserCubit() : super(null);

  void setUid(String newUid) {
    emit(newUid);
  }

  String? getUid() {
    return state;
  }

 
}
