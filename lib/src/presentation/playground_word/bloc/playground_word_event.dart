part of 'playground_word_bloc.dart';

abstract class PlaygroundWordEvent extends Equatable {
  const PlaygroundWordEvent();

  @override
  List<Object> get props => [];
}
class FetchPlaygroundWordEvent extends PlaygroundWordEvent {
  final int? page;
  final int? limit;
  const FetchPlaygroundWordEvent({this.page, this.limit});
}
