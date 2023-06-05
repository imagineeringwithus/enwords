import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:enwords/src/base/bloc.dart';
import 'package:enwords/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../words/words_screen.dart';
import 'bloc/dashboard_bloc.dart';
import 'widgets/widget_drawer.dart';

DashboardBloc get _bloc => findInstance<DashboardBloc>();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    findInstance<AuthBloc>().add(const AuthLoad());
    _bloc.add(InitDashboardEvent());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (findInstance<AuthBloc>().state.stateType == AuthStateType.logged) {
        _bloc.add(InitDashboardEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const WidgetDrawer(),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: findInstance<AuthBloc>(),
        listener: (_, state) {
          if (state.stateType == AuthStateType.logged) {
            _bloc.add(InitDashboardEvent());
          }
        },
        builder: (context, authState) {
          bool logged = authState.stateType == AuthStateType.logged;
          if (!logged) return const SizedBox();
          return BlocBuilder<DashboardBloc, DashboardState>(
            bloc: _bloc,
            builder: (context, state) {
              Widget child = const SizedBox();

              switch (state.menu) {
                case DashboardMenu.words:
                  child = const WordsScreen();
                  break;
                default:
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            isExpanded = !isExpanded;
                            scaffoldKey.currentState!.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu_rounded,
                            color: appColorText,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
