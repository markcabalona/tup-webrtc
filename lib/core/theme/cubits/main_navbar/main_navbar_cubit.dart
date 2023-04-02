import 'package:bloc/bloc.dart';

enum SelectedTab { home, inbox, booking, casinoGo, okadaPay }

class MainNavbarCubit extends Cubit<SelectedTab> {
  MainNavbarCubit() : super(SelectedTab.home);

  void updateTab({SelectedTab? selectedTab}) {
    emit(selectedTab ?? state);
  }
}
