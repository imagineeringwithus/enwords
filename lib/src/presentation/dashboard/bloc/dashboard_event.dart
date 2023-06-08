part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class InitDashboardEvent extends DashboardEvent {
  final DashboardMenu? menu;
  const InitDashboardEvent({this.menu});
}

class ChangeMenuDashboardEvent extends DashboardEvent {
  final DashboardMenu menu;
  const ChangeMenuDashboardEvent(this.menu);
}
