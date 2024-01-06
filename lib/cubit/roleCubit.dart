import 'package:bloc/bloc.dart';

class RoleCubit extends Cubit<String?> {
  RoleCubit() : super(null);


  //  for setUserRole
  void setUserRole(String role) {
    emit(role);
  }

  //for getUserRole
  String? getUserRole() {
    return state;
  }
}
