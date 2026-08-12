import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarCubit extends Cubit<bool> {
  SidebarCubit() : super(true); // Open by default

  void toggle() => emit(!state);
  void show() => emit(true);
  void hide() => emit(false);
}
