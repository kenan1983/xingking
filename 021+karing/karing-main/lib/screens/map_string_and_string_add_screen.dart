import 'package:flutter/material.dart';
import 'package:karing/i18n/strings.g.dart';
import 'package:karing/screens/dialog_utils.dart';
import 'package:karing/screens/theme_config.dart';
import 'package:karing/screens/theme_define.dart';
import 'package:karing/screens/widgets/framework.dart';
import 'package:tuple/tuple.dart';

class MapStringAndStringAddScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "MapStringAndStringAddScreen");
  }

  final String title;
  final List<Tuple2<String, String>> data;
  final String dialogTitle1;
  final String dialogTextHit1;
  final String dialogTitle2;
  final String dialogTextHit2;
  const MapStringAndStringAddScreen(
      {super.key,
      required this.title,
      required this.data,
      this.dialogTitle1 = "",
      this.dialogTextHit1 = "",
      this.dialogTitle2 = "",
      this.dialogTextHit2 = ""});

  @override
  State<MapStringAndStringAddScreen> createState() =>
      _ServerSelectSearchSettingsScreenState();
}

class _ServerSelectSearchSettingsScreenState
    extends LasyRenderingState<MapStringAndStringAddScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 26,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: windowSize.width - 50 * 2,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: ThemeConfig.kFontWeightTitle,
                            fontSize: ThemeConfig.kFontSizeTitle),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        onTapAdd();
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(
                          Icons.add_outlined,
                          size: 26,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: _loadListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadListView() {
    Size windowSize = MediaQuery.of(context).size;

    return Scrollbar(
        thumbVisibility: true,
        child: ListView.separated(
          itemCount: widget.data.length,
          itemBuilder: (BuildContext context, int index) {
            var current = widget.data[index];
            return createWidget(index, current, windowSize);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              thickness: 0.3,
            );
          },
        ));
  }

  Widget createWidget(
      int index, Tuple2<String, String> current, Size windowSize) {
    const double rightWidth = 30.0;
    double centerWidth = windowSize.width - rightWidth - 20;

    return Material(
      borderRadius: ThemeDefine.kBorderRadius,
      child: InkWell(
        onTap: () async {
          onTapEditItem(current);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          width: double.infinity,
          height: ThemeConfig.kListItemHeight2,
          child: Row(
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        SizedBox(
                          width: centerWidth,
                          child: Text(
                            current.item1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ThemeConfig.kFontSizeGroupItem,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: rightWidth,
                            height: ThemeConfig.kListItemHeight2 - 2,
                            child: InkWell(
                              onTap: () async {
                                onTapDelete(index);
                              },
                              child: const Icon(
                                Icons.remove_circle_outlined,
                                size: 26,
                                color: Colors.red,
                              ),
                            ))
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapEditItem(Tuple2<String, String> current) async {
    String? text = await DialogUtils.showTextInputDialog(
        context, current.item1, current.item2, "", null, null, (text) {
      text = text.trim();
      if (text.isEmpty) {
        return false;
      }

      return true;
    });
    if (text == null || text.isEmpty) {
      return;
    }
    for (var i = 0; i < widget.data.length; ++i) {
      if (widget.data[i].item1 == current.item1) {
        widget.data[i] = Tuple2(current.item1, text);
        break;
      }
    }

    setState(() {});
  }

  void onTapAdd() async {
    final tcontext = Translations.of(context);
    String? text = await DialogUtils.showTextInputDialog(
        context, tcontext.meta.add, "", "", null, null, (text) {
      text = text.trim();
      if (text.isEmpty) {
        return false;
      }

      return true;
    });
    if (text == null || text.isEmpty) {
      return;
    }
    for (var current in widget.data) {
      if (current.item1 == text) {
        return;
      }
    }

    widget.data.add(Tuple2(text, ""));
    setState(() {});
  }

  void onTapDelete(int index) {
    widget.data.removeAt(index);

    setState(() {});
  }
}
