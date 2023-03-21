import 'package:easy_localization/easy_localization.dart'
    hide TextTranslateExtension, StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:translate_plugin_example/utils/translate_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      startLocale: TranslatePlugin.systemOrDefaultLocale,
      supportedLocales: TranslatePlugin.supportLocales,
      path: TranslatePlugin.path,
      fallbackLocale: TranslatePlugin.defaultLocales,
      useFallbackTranslations: true,
      child: const MyApp(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("localization".tr)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'.tr),
            Text("date {}".trf([
              "${DateTime.now().day.toString().padLeft(2, "0")}-${DateTime.now().month.toString().padLeft(2, "0")}-${DateTime.now().year}"
            ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: context.supportedLocales
                  .map(
                    (e) => TextButton(
                      onPressed: () => context.setLocale(e),
                      child: Text(e.languageCode),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Localization",
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        RouteObserver(),
      ],
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const HomePage(),
    );
  }
}
