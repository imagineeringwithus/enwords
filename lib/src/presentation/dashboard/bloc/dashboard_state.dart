part of 'dashboard_bloc.dart';

class DashboardState {
  DashboardMenu menu;

  DashboardState({
    this.menu = DashboardMenu.words,
  });

  DashboardState update({
    DashboardMenu? menu,
  }) {
    return DashboardState(
      menu: menu ?? this.menu,
    );
  }
}

enum DashboardMenu { words,   reports }

extension DashboardMenuExt on DashboardMenu {
  String get text {
    switch (this) {
      case DashboardMenu.words:
        return 'Languages'; 
      case DashboardMenu.reports:
        return 'Reports';
    }
  }

  IconData get icon {
    switch (this) {
      case DashboardMenu.words:
        return Icons.language; 
      case DashboardMenu.reports:
        return Icons.report_gmailerrorred;
    }
  }
}
