import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enwords/src/resources/firestore/firestore.dart';
import 'package:equatable/equatable.dart';

part 'playground_word_event.dart';
part 'playground_word_state.dart';

class PlaygroundWordBloc extends Bloc<PlaygroundWordEvent, PlaygroundWordState>{
  PlaygroundWordBloc() : super(PlaygroundWordState()) {
    on<FetchPlaygroundWordEvent>(_fetch);
  }

  _fetch(FetchPlaygroundWordEvent event, emit) async {
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
