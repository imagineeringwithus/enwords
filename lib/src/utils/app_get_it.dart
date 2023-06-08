import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../base/bloc.dart';
import '../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../presentation/home/bloc/home_bloc.dart';
import '../presentation/playground_word/bloc/playground_word_bloc.dart';
import '../presentation/words/bloc/words_bloc.dart';

final getIt = GetIt.instance;

void getItSetup() {
  //Base
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());
  getIt.registerSingleton<AuthBloc>(AuthBloc());
  getIt.registerSingleton<ThemeBloc>(ThemeBloc());

  //In app
  getIt.registerLazySingleton<DashboardBloc>(() => DashboardBloc());
  getIt.registerLazySingleton<WordsBloc>(() => WordsBloc());
  getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
  getIt.registerLazySingleton<PlaygroundWordBloc>(() => PlaygroundWordBloc());
}
