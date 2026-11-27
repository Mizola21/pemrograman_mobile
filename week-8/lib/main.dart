import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'screens/admin_tab.dart';
import 'screens/user_tab.dart';
import 'services/admin_service.dart';
import 'services/api_service.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChanged;
  const HomePage({super.key, required this.onLocaleChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _refresh = 0;

  Future<void> _reset() async {
    await ApiService.resetToDefault();
    await AdminService.resetToDefault();
    if (!mounted) return;
    setState(() => _refresh++);
    showMessage(context, AppLocalizations.of(context)!.dataReset);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.appTitle),
          actions: [
            IconButton(
              tooltip: l.resetData,
              icon: const Icon(Icons.restart_alt),
              onPressed: _reset,
            ),
            PopupMenuButton<Locale>(
              tooltip: l.language,
              icon: const Icon(Icons.language),
              onSelected: widget.onLocaleChanged,
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: Locale('id'),
                  child: Text('Bahasa Indonesia'),
                ),
                PopupMenuItem(value: Locale('en'), child: Text('English')),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [Tab(text: l.tabUsers), Tab(text: l.tabAdmins)],
          ),
        ),
        body: TabBarView(
          children: [
            UserTab(key: ValueKey('user$_refresh')),
            AdminTab(key: ValueKey('admin$_refresh')),
          ],
        ),
      ),
    );
  }
}
