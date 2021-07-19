import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/routers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/auth_bloc/bloc.dart';
import 'language/app_localization.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  //* we need to call this becasue we async fecthing data when App is not inititalize.
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
    InfiShareApp(
      client: InfiShareApiClient(
        httpClient: http.Client(),
        firebaseMessaging: firebaseMessaging,
      ),
    ),
  );
}

class InfiShareApp extends StatelessWidget {
  final InfiShareApiClient client;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  RouteGenerator routeGenerator;
  InfiShareApp({this.client}) {
    routeGenerator = RouteGenerator(infiShareApiClient: client);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            userRepository: UserRepository(
              client: client,
            ),
          )..add(AppStart()),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) {
            return LanguageBloc()
              ..add(
                LoadLanguageCode(),
              );
          },
        ),
        BlocProvider<WifiBloc>(
          create: (context) {
            return WifiBloc();
          },
        ),
        BlocProvider<TabBloc>(
          create: (context) {
            return TabBloc();
          },
        )
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            builder: (context, child) {
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            debugShowCheckedModeBanner: false,
            locale: (state is LanguageSettingLoaded)
                ? state.language
                : const Locale('en'),
            supportedLocales: [
              const Locale("en", "US"),
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
            ],
            localizationsDelegates: [
              //provides localised strings
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              //provides RTL support
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            darkTheme: ThemeData(
              primaryColor: Colors.white,
              splashColor: Colors.black,
              //scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                iconTheme: IconThemeData(
                  color: Color(0XFF242424),
                  size: 30,
                ),
              ),
            ),
            theme: ThemeData(
              splashColor: Colors.black,
              //scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                iconTheme: IconThemeData(
                  color: Color(0XFF242424),
                  size: 30,
                ),
              ),
            ),
            onGenerateRoute: routeGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
