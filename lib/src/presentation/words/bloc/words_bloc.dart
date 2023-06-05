import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enwords/src/resources/firestore/firestore.dart';
import 'package:equatable/equatable.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  WordsBloc() : super(WordsState()) {
    on<FetchWordsEvent>(_fetch);
  }

  _fetch(FetchWordsEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.limit = event.limit ?? state.limit;
    emit(state.update());

    if (state.items == null || state.items!.isEmpty || state.page == 1) {
      var query = await colWords.limit(state.limit).get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    } else {
      var last = state.items!.last;
      emit(state.update(items: []));
      var query =
          await colWords.startAfterDocument(last).limit(state.limit).get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    }

    if (state.count == 0) {
      AggregateQuerySnapshot query = await colWords.count().get();
      emit(state.update(count: query.count));
    }
  }
}
