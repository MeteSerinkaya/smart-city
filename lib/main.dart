import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/core/constants/app/app_constants.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';
import 'package:smart_city/core/init/lang/language_manager.dart';
import 'package:smart_city/core/init/notifier/application_provider.dart';
import 'package:smart_city/core/init/notifier/theme_notifier.dart';
import 'package:smart_city/core/init/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleManager.init();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: AppConstants.LANG_ASSET_PATH,
        fallbackLocale: LanguageManager.instance.enLocale,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          title: 'Erzurum Akıllı Şehir',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,

          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: appRouter,
        );
      },
    );
  }
}
