import 'package:bookmark/core/api_helper/api_service_helper.dart';
import 'package:bookmark/core/repositories/user_data_repository.dart';
import 'package:bookmark/core/view_models/users_view_model.dart';
import 'package:bookmark/router_map.dart';
import 'package:bookmark/ui/res/style.dart';
import 'package:bookmark/ui/routes/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: ApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsersViewModel(
            userDataSourceRepository: UserDataSourceRepository(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BookMark',
        debugShowCheckedModeBanner: false,
        theme: ThemeChanger().lightTheme,
        onGenerateRoute: RouterNavigation.generateRoute,
        home: SplashScreen(),
      ),
    );
  }
}
