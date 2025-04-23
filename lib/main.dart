import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/modules/Home/home_screen.dart';
import 'modules/Auth/cubit/cubit.dart';
import 'modules/Auth/login/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/styles/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await dotenv.load(fileName: ".env");

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  // Access environment variables
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseKey = dotenv.env['SUPABASE_KEY']!;

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  Widget widget;

  final TOKEN = CacheHelper.getData(key: 'loggedIn') ?? false;

  final isAdmin = CacheHelper.getData(key: 'admin') ?? false;

  if (TOKEN) {
    widget = HomeScreen(is_admin: isAdmin,);
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {


  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit()..getUsers(),
      child: ToastificationWrapper(
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ar'),
          ],
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: startWidget,
        ),
      ),
    );
  }

}