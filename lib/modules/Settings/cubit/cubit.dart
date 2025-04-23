import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits/modules/Settings/cubit/states.dart';
import 'package:visits/shared/network/local/cache_helper.dart';

class settingsCubit extends Cubit<SettingsStates> {
  settingsCubit() : super(SettingsInitialState());

  static settingsCubit get(context) => BlocProvider.of(context);

  bool isActive = true;

  void toggleSwitch(bool value) {
    isActive = value;

    if (isActive) {
      // Enable GIFs
      print('GIFs are enabled');
      CacheHelper.saveData(key: 'gifs', value: value);
    } else {
      // Disable GIFs
      print('GIFs are disabled');
      CacheHelper.saveData(key: 'gifs', value: value);
    }

    emit(SettingsChangeState());
  }


}