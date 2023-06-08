import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:_imagineeringwithus_pack/setup/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enwords/src/resources/firestore/firestore.dart';
import 'package:enwords/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../widgets/widgets.dart';
import 'bloc/playground_word_bloc.dart';

PlaygroundWordBloc get _bloc => findInstance<PlaygroundWordBloc>();

class PlaygroundWordScreen extends StatefulWidget {
  const PlaygroundWordScreen({super.key});

  @override
  State<PlaygroundWordScreen> createState() => _PlaygroundWordScreenState();
}

class _PlaygroundWordScreenState extends State<PlaygroundWordScreen> {
  @override
  void initState() {
    super.initState();
    _bloc.add(const FetchPlaygroundWordEvent(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 65),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: appColorPrimary,
          child: Row(
            children: [
              const Spacer(),
              BlocBuilder<PlaygroundWordBloc, PlaygroundWordState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: List.generate(
                                        5,
                                        (index) => InkWell(
                                          onTap: () {
                                            hide();
                                            _bloc.add(FetchPlaygroundWordEvent(
                                                page: 1,
                                                limit: (index + 1) * 10));
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
                                style: w400TextStyle(color: appColorBackground),
                              ),
                              kSpacingWidth4,
                              Text(
                                '${state.limit} items',
                                style: w500TextStyle(color: appColorBackground),
                              ),
                            ],
                          ),
                        ),
                        kSpacingWidth20,
                        Text(
                          'Page:',
                          style: w400TextStyle(color: appColorBackground),
                        ),
                        kSpacingWidth4,
                        InkWell(
                          onTap: state.page == 1
                              ? null
                              : () {
                                  _bloc.add(FetchPlaygroundWordEvent(
                                      page: state.page - 1));
                                },
                          child: CircleAvatar(
                            backgroundColor:
                                appColorBackground.withOpacity(.05),
                            radius: 18,
                            child: Icon(
                              Icons.chevron_left_rounded,
                              color: appColorBackground
                                  .withOpacity(state.page == 1 ? .2 : 1),
                            ),
                          ),
                        ),
                        Text(
                          '   ${state.page}   ',
                          style: w500TextStyle(color: appColorBackground),
                        ),
                        InkWell(
                          onTap: state.page * state.limit >= state.count
                              ? null
                              : () {
                                  _bloc.add(FetchPlaygroundWordEvent(
                                      page: state.page + 1));
                                },
                          child: CircleAvatar(
                            backgroundColor:
                                appColorBackground.withOpacity(.05),
                            radius: 18,
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: appColorBackground.withOpacity(
                                  state.page * state.limit >= state.count
                                      ? .2
                                      : 1),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
      body: BlocBuilder<PlaygroundWordBloc, PlaygroundWordState>(
        bloc: _bloc,
        builder: (context, state) {
          List<QueryDocumentSnapshot<Map>> items =
              List.from((state.items ?? []));
          return _WidgetPlayground(
            key: ValueKey(items),
            items: items,
          );
        },
      ),
    );
  }
}

class _WidgetPlayground extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map>> items;
  const _WidgetPlayground({super.key, required this.items});

  @override
  State<_WidgetPlayground> createState() => __WidgetPlaygroundState();
}

class __WidgetPlaygroundState extends State<_WidgetPlayground> {
  List<QueryDocumentSnapshot<Map>> get items => widget.items;
  bool isHideWord = false;
  bool isCheckingWord = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: items.length,
          separatorBuilder: (context, index) => Container(
            height: .6,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey.shade200,
          ),
          itemBuilder: (_, index) {
            var e = items[index];

            return _WidgetWord(
              word: e.data()[kdb_word],
              meaning: e.data()[kdb_meaning],
              isHideWord: isHideWord,
              isCheckingWord: isCheckingWord,
            );
          },
        )),
        Container(
          width: context.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: appColorPrimary,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 12,
            runSpacing: 12,
            children: [
              if (!isHideWord)
                _buildButton(
                  "Hide word",
                  () {
                    setState(() {
                      isHideWord = true;
                    });
                  },
                )
              else if (!isCheckingWord)
                _buildButton(
                  "Check",
                  () {
                    setState(() {
                      isCheckingWord = true;
                    });
                  },
                ),
              _buildButton(
                "Reset",
                () {
                  setState(() {
                    isCheckingWord = false;
                    isHideWord = false;
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButton(String title, onTap) {
    return WidgetRippleButton(
      color: appColorBackground,
      borderRadius: BorderRadius.circular(99),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: w400TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class _WidgetWord extends StatefulWidget {
  final String word;
  final String meaning;
  final bool isHideWord;
  final bool isCheckingWord;
  const _WidgetWord({
    super.key,
    required this.word,
    required this.meaning,
    required this.isHideWord,
    required this.isCheckingWord,
  });

  @override
  State<_WidgetWord> createState() => __WidgetWordState();
}

class __WidgetWordState extends State<_WidgetWord> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(16),
        Expanded(
          flex: 3,
          child: Container(
            height: 48,
            decoration: BoxDecoration(color: appColorPrimary),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: widget.isHideWord
                ? TextField(
                    focusNode: focusNode,
                    controller: controller,
                    style:
                        w300TextStyle(fontSize: 16, color: appColorBackground),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration.collapsed(
                        hintText: '...',
                        hintStyle: w300TextStyle(
                            fontSize: 16,
                            color: appColorBackground.withOpacity(.4))),
                  )
                : Text(
                    widget.word,
                    style:
                        w300TextStyle(fontSize: 16, color: appColorBackground),
                  ),
          ),
        ),
        const Gap(16),
        Expanded(
          flex: 4,
          child: Container(
            height: 48,
            decoration: BoxDecoration(color: appColorPrimary),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.meaning,
              style: w300TextStyle(fontSize: 16, color: appColorBackground),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Row(
            children: [
              if (widget.isCheckingWord)
                if (widget.word.toLowerCase() !=
                    controller.text.toLowerCase()) ...[
                  const Gap(16),
                  const Icon(
                    CupertinoIcons.xmark_square,
                    color: Colors.red,
                    size: 32,
                  )
                ] else ...[
                  const Gap(16),
                  const Icon(
                    CupertinoIcons.checkmark_square,
                    color: Colors.green,
                    size: 32,
                  )
                ]
            ],
          ),
        ),
        const Gap(16),
      ],
    );
  }
}
