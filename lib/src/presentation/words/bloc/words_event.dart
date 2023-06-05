part of 'words_bloc.dart';

abstract class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

class FetchWordsEvent extends WordsEvent {
  final int? page;
  final int? limit;
  const FetchWordsEvent({this.page, this.limit});
}
