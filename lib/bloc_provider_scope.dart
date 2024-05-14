import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';

class BlocProviderScope extends StatelessWidget {
  final Widget child;
  const BlocProviderScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // //* Theme controller
        // BlocProvider(
        //   create: (_) => sl<ThemeCubit>()..fetchTheme(),
        //   lazy: false,
        // ),
        // //* Internet connection controller
        // BlocProvider(create: (_) => sl<ConnectionCubit>()..initialize()),
        // //* Authentication Bloc
        // BlocProvider(
        //   create: (_) => sl<AuthBloc>()..initAuthStream(),
        // ),
        // //* Word List Bloc
        // BlocProvider(
        //   create: (_) => sl<WordListCubit>()..getAllWords(),
        //   lazy: false,
        // ),
        // //* User Cubit
        // BlocProvider(create: (_) => sl<UserDataCubit>()),
        // //* Schedule notification Cubit
        // BlocProvider(create: (_) => ScheduleNotificationCubit()),
        // //* Cart Cubit
        // BlocProvider(create: (_) => sl<CartCubit>()),
        // //* Cart Bag Cubit
        // BlocProvider(create: (_) => sl<CartBagCubit>()),
        // //* Favourite Cubit
        // BlocProvider(
        //   create: (_) => sl<WordFavouriteCubit>()..getAllFavouriteWords(),
        // ),
        // //* Known word Cubit
        // BlocProvider(
        //   create: (_) => sl<KnownWordCubit>()..getAllKnownWords(),
        // ),
      ],
      child: child,
    );
  }
}
