import 'dart:convert';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:enwords/src/presentation/widgets/widgets.dart';
import 'package:enwords/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:enwords/src/resources/firestore/firestore.dart';
import 'package:go_router/go_router.dart';

import '../bloc/words_bloc.dart';

WordsBloc get _bloc => findInstance<WordsBloc>();

class WidgetFormCreateLangs extends StatefulWidget {
  const WidgetFormCreateLangs({super.key});

  @override
  State<WidgetFormCreateLangs> createState() => _WidgetFormCreateLangsState();
}

class _WidgetFormCreateLangsState extends State<WidgetFormCreateLangs> {
  final TextEditingController json = TextEditingController();
  final TextEditingController word = TextEditingController();
  final TextEditingController meaning = TextEditingController();
  final FocusNode meaningFocus = FocusNode();
  bool isSetPublic = true;
  bool isEnableJson = false;
  bool get isJson {
    var r;
    try {
      if (json.text.isNotEmpty) r = jsonDecode(json.text.trim());
    } catch (e) {}
    return r != null;
  }

  _submit(Map<String, dynamic> data) async {
    var id = DateTime.now().millisecondsSinceEpoch;
    data.addAll({
      kdb_id: id,
      kdb_languageCode: 'en',
      kdb_isPublic: isJson || isSetPublic,
    });
    await colWords.doc('$id').set(data);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Material(
        color: Colors.black26,
        child: Center(
          child: Hero(
            tag: 'WidgetFormCreateLangs',
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  width: 600,
                  decoration: BoxDecoration(
                      color: appColorBackground,
                      borderRadius: BorderRadius.circular(26)),
                  child: SingleChildScrollView(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Words",
                            style: w600TextStyle(fontSize: 28),
                          ),
                          kSpacingHeight8,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "New item",
                                style: w400TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isEnableJson = !isEnableJson;
                                    });
                                  },
                                  icon: WidgetAppSVG(
                                    assetsvg('json'),
                                    width: 24,
                                  )),
                            ],
                          ),
                          kSpacingHeight24,
                          if (isEnableJson) ...[
                            WidgetTextField(
                              controller: json,
                              label: 'Json format',
                              maxLines: 15,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ] else ...[
                            if (isComputerByWidth(context))
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: WidgetTextField(
                                        controller: word,
                                        label: 'Word',
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        onSubmitted: (_) =>
                                            meaningFocus.requestFocus(),
                                      )),
                                  kSpacingWidth16,
                                  Expanded(
                                    flex: 3,
                                    child: WidgetTextField(
                                      focusNode: meaningFocus,
                                      controller: meaning,
                                      label: 'Meaning',
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  WidgetTextField(
                                    controller: word,
                                    label: 'Word',
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    onSubmitted: (_) =>
                                        meaningFocus.requestFocus(),
                                  ),
                                  kSpacingHeight16,
                                  WidgetTextField(maxLines: 4,
                                    focusNode: meaningFocus,
                                    controller: meaning,
                                    label: 'Meaning',
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            kSpacingHeight16,
                            WidgetCheck(
                              status: isSetPublic,
                              label: 'Set to public',
                              callback: (value) {
                                setState(() {
                                  isSetPublic = !isSetPublic;
                                });
                              },
                            )
                          ],
                          kSpacingHeight24,
                          WidgetButton(
                            enable: isEnableJson
                                ? isJson
                                : word.text.isNotEmpty &&
                                    meaning.text.isNotEmpty,
                            label: 'Submit',
                            onTap: () async {
                              context.pop();
                              if (isEnableJson) {
                                List datas =
                                    jsonDecode(json.text.trim()) as List;
                                for (var e in datas) {
                                  await _submit(e);
                                }
                              } else {
                                await _submit({
                                  kdb_word: word.text.trim(),
                                  kdb_meaning: meaning.text.trim(),
                                });
                              }
                              _bloc.add(const FetchWordsEvent(page: 1));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
