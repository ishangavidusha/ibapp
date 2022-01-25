import 'package:flutter/material.dart';
import 'package:ibapp/home.dart';
import 'package:ibapp/service/employee.dart';
import 'package:ibapp/utils/app_theme.dart';
import 'package:ibapp/utils/keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences,));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppTheme appTheme;
  late EmployeeService employeeService;

  @override
  void initState() {
    appTheme = AppTheme();
    employeeService = EmployeeService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppTheme>(create: (_) => appTheme),
        ChangeNotifierProvider<EmployeeService>(create: (_) => employeeService)
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: "Induwaree Batik",
            color: context.select((AppTheme appTheme) => appTheme.primary),
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: context.select((AppTheme appTheme) => appTheme.colorScheme)
            ),
            scaffoldMessengerKey: scaffoldMessengerKey,
            home: const HomePage(),
          );
        }
      ),
    );
  }
}