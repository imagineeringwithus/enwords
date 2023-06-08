part of 'playground_word_bloc.dart';

  class PlaygroundWordState {
  int count;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;

  PlaygroundWordState({
    this.count = 0,
    this.page = 1,
    this.limit = 10,
    this.items,
  });

  PlaygroundWordState update({
    int? count,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
  }) {
    return PlaygroundWordState(
      count: count ?? this.count,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
    );
  }
}
