import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';

part 'presentation/full_datetime_page.dart';
part 'presentation/full_datetime_spinner_page.dart';
part 'presentation/time_only_dropdown_page.dart';
part 'presentation/time_only_spinner_page.dart';
part 'presentation/date_only_page.dart';
part 'presentation/customize_picker_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateTime Range Picker Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/full_datetime_dropdown': (context) =>
            const FullDateTimeDropdownPage(),
        '/full_datetime_spinner': (context) => const FullDateTimeSpinnerPage(),
        '/time_only_dropdown': (context) => const TimeOnlyDropdownPage(),
        '/time_only_spinner': (context) => const TimeOnlySpinnerPage(),
        '/date_only': (context) => const DateOnlyPage(),
        '/customized': (context) => const CustomizedPickerPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTime Range Picker Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureCard(
            context,
            title: 'Full DateTime (Dropdown)',
            description: 'Select date and time with dropdown time picker',
            route: '/full_datetime_dropdown',
          ),
          _buildFeatureCard(
            context,
            title: 'Full DateTime (Spinner)',
            description: 'Select date and time with spinner time picker',
            route: '/full_datetime_spinner',
          ),
          _buildFeatureCard(
            context,
            title: 'Time Only (Dropdown)',
            description: 'Select only time with dropdown time picker',
            route: '/time_only_dropdown',
          ),
          _buildFeatureCard(
            context,
            title: 'Time Only (Spinner)',
            description: 'Select only time with spinner time picker',
            route: '/time_only_spinner',
          ),
          _buildFeatureCard(
            context,
            title: 'Date Only',
            description: 'Select only date range',
            route: '/date_only',
          ),
          _buildFeatureCard(
            context,
            title: 'Fully Customized',
            description: 'Spinner with custom styling, intervals, seconds',
            route: '/customized',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
