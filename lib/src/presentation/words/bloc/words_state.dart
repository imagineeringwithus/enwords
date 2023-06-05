part of 'words_bloc.dart';

class WordsState {
  int count;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;

  WordsState({
    this.count = 0,
    this.page = 1,
    this.limit = 20,
    this.items,
  });

  WordsState update({
    int? count,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
  }) {
    return WordsState(
      count: count ?? this.count,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
    );
  }
}
