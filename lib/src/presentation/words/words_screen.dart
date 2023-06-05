import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enwords/src/resources/firestore/firestore.dart';
import 'package:enwords/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';
import 'bloc/words_bloc.dart';
import 'widgets/widget_form_create.dart';

WordsBloc get _bloc => findInstance<WordsBloc>();

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc.add(const FetchWordsEvent(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WidgetFABAni(
        shouldShow: true,
        animationDuration: const Duration(milliseconds: 250),
        fab: FloatingActionButton(
          heroTag: 'WidgetFormCreateLangs',
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return const WidgetFormCreateLangs();
                }));
          },
        ),
      ),
      body: BlocBuilder<WordsBloc, WordsState>(
        bloc: _bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(state),
              kSpacingHeight32,
              Expanded(
                child: Column(
                  children: [
                    WidgetRowHeader(
                      child: Row(
                        children: [
                          if (isComputerByWidth(context))
                            const WidgetRowValue.label(
                                flex: 1, value: kdb_languageCode),
                          const WidgetRowValue.label(flex: 3, value: kdb_word),
                          const WidgetRowValue.label(
                              flex: 4, value: kdb_meaning),
                          if (isComputerByWidth(context))
                            const WidgetRowValue.label(
                                flex: 2, value: kdb_isPublic),
                        ],
                      ),
                    ),
                    kSpacingHeight20,
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: searchController,
                          builder: (context, value, child) {
                            String keyword = value.text;
                            List<QueryDocumentSnapshot<Map>> items = List.from(
                                (state.items ?? []).where((e) =>
                                    e
                                        .data()[kdb_word]
                                        .toString()
                                        .isContainsASCII(keyword) ||
                                    e
                                        .data()[kdb_meaning]
                                        .toString()
                                        .isContainsASCII(keyword)));
                            return ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (context, index) => Container(
                                height: .6,
                                color: Colors.grey.shade200,
                              ),
                              itemBuilder: (_, index) {
                                var e = items[index];

                                return WidgetRowItem(
                                  key: ValueKey(e),
                                  child: Row(
                                    children: [
                                      if (isComputerByWidth(context))
                                        WidgetRowValue(
                                          flex: 1,
                                          value: e.data()[kdb_languageCode],
                                        ),
                                      WidgetRowValue(
                                        flex: 3,
                                        value: e.data()[kdb_word],
                                        callback: (value) async {
                                          await colWords
                                              .doc('${e.data()[kdb_id]}')
                                              .update({kdb_word: value});
                                          _bloc.add(const FetchWordsEvent());
                                        },
                                      ),
                                      WidgetRowValue(
                                        flex: 4,
                                        value: e.data()[kdb_meaning],
                                      ),
                                      if (isComputerByWidth(context))
                                        WidgetRowValue(
                                          flex: 2,
                                          cellDataType: CellDataType.bol,
                                          value: e.data()[kdb_isPublic],
                                          label: 'Set to public',
                                          callback: (value) async {
                                            await colWords
                                                .doc('${e.data()[kdb_id]}')
                                                .update({kdb_isPublic: value});
                                            _bloc.add(const FetchWordsEvent());
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildHeader(state) {
    return responByWidth(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 280.0,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Type some thing...",
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appColorPrimary,
                  ),
                ),
              ),
            ),
          ),
          kSpacingHeight16,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page:',
                style: w400TextStyle(),
              ),
              kSpacingWidth4,
              IconButton(
                onPressed: state.page == 1
                    ? null
                    : () {
                        _bloc.add(FetchWordsEvent(page: state.page - 1));
                      },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: state.page == 1 ? appColorElement : appColorText,
                ),
              ),
              Text(
                ' ${state.page} ',
                style: w500TextStyle(),
              ),
              IconButton(
                onPressed: state.page * state.limit >= state.count
                    ? null
                    : () {
                        _bloc.add(FetchWordsEvent(page: state.page + 1));
                      },
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: state.page * state.limit >= state.count
                      ? appColorElement
                      : appColorText,
                ),
              ),
              kSpacingWidth12,
              WidgetOverlayActions(
                builder: (Widget child,
                    Size size,
                    Offset childPosition,
                    Offset? pointerPosition,
                    double animationValue,
                    Function hide) {
                  return Positioned(
                    right: MediaQuery.of(context).size.width -
                        childPosition.dx -
                        size.width,
                    top: childPosition.dy + size.height + 8,
                    child: WidgetPopupContainer(
                      alignmentTail: Alignment.topRight,
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: List.generate(
                              5,
                              (index) => InkWell(
                                onTap: () {
                                  hide();
                                  _bloc.add(FetchWordsEvent(
                                      page: 1, limit: (index + 1) * 10));
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${(index + 1) * 10} items',
                                        style: w400TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Limit:',
                      style: w400TextStyle(),
                    ),
                    kSpacingWidth4,
                    Text(
                      '${state.limit} items',
                      style: w500TextStyle(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      computer: Row(
        children: [
          SizedBox(
            width: 280.0,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Type some thing...",
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appColorPrimary,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page:',
                style: w400TextStyle(),
              ),
              kSpacingWidth4,
              IconButton(
                onPressed: state.page == 1
                    ? null
                    : () {
                        _bloc.add(FetchWordsEvent(page: state.page - 1));
                      },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: state.page == 1 ? appColorElement : appColorText,
                ),
              ),
              Text(
                ' ${state.page} ',
                style: w500TextStyle(),
              ),
              IconButton(
                onPressed: state.page * state.limit >= state.count
                    ? null
                    : () {
                        _bloc.add(FetchWordsEvent(page: state.page + 1));
                      },
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: state.page * state.limit >= state.count
                      ? appColorElement
                      : appColorText,
                ),
              ),
              kSpacingWidth12,
              WidgetOverlayActions(
                builder: (Widget child,
                    Size size,
                    Offset childPosition,
                    Offset? pointerPosition,
                    double animationValue,
                    Function hide) {
                  return Positioned(
                    right: MediaQuery.of(context).size.width -
                        childPosition.dx -
                        size.width,
                    top: childPosition.dy + size.height + 8,
                    child: WidgetPopupContainer(
                      alignmentTail: Alignment.topRight,
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: List.generate(
                              5,
                              (index) => InkWell(
                                onTap: () {
                                  hide();
                                  _bloc.add(FetchWordsEvent(
                                      page: 1, limit: (index + 1) * 10));
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${(index + 1) * 10} items',
                                        style: w400TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Limit:',
                      style: w400TextStyle(),
                    ),
                    kSpacingWidth4,
                    Text(
                      '${state.limit} items',
                      style: w500TextStyle(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
