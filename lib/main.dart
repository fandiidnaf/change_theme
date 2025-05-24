import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:test/theme/app_colors.dart';
import 'package:test/theme/cubit/theme_cubit.dart';

const String themeBox = "themeApp";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox(themeBox);
  if (box.isEmpty) {
    await box.add('system');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(themeBox);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(box.getAt(0).toString().toThemeMode),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              state.changeSystemUi(context);

              return MaterialApp(
                // theme: ThemeData.light(),
                // darkTheme: ThemeData.dark(),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state,
                debugShowCheckedModeBanner: false,
                home: HomeScreen(selectedTheme: state),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.selectedTheme});
  final ThemeMode selectedTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeMode selectedTheme = widget.selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please let us know your gender:'),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: selectedTheme,
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(value!);

                  setState(() {
                    selectedTheme = value;
                  });
                },
              ),
              title: const Text('Light'),
            ),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: selectedTheme,
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(value!);

                  setState(() {
                    selectedTheme = value;
                  });
                },
              ),
              title: const Text('Dark'),
            ),
            ListTile(
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: selectedTheme,
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(value!);
                  setState(() {
                    selectedTheme = value;
                  });
                },
              ),
              title: const Text('System'),
            ),
          ],
        ),
      ),
    );
  }
}
