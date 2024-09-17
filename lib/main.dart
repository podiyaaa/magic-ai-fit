import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/workout/presentation/viewmodels/workout_list_viewmodel.dart';
import 'features/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'features/workout/presentation/views/workout_list_view.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<WorkoutListViewModel>()..loadWorkouts(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WorkoutViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Workout Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WorkoutListView(),
      ),
    );
  }
}
