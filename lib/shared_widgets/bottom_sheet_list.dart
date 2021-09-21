import 'package:flutter/material.dart';

class BottomSheetList extends StatelessWidget {
  final List<String> choices;
  final String title;
  final Function(int) selectedIndex;

  const BottomSheetList({@required this.choices, @required this.selectedIndex, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
          color: Colors.white,
          shadows: [
            BoxShadow(
              spreadRadius: 3,
              blurRadius: 3,
              color: Colors.black12,
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context), child: const Text('Close'))),
                if (title != null) ...[
                  Expanded(
                      flex: 6,
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14),
                          ),
                        ),
                      )),
                ],
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                  selectedIndex(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Text(
                    choices[index],
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 12),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: choices.length,
            ),
          ),
        ],
      ),
    );
  }
}
