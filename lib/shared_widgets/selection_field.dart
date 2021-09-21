import 'package:copy_trading/shared_widgets/bottom_sheet_list.dart';
import 'package:copy_trading/shared_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SelectionField extends StatelessWidget {
  final List<String> choices;
  final Function(int) selectedIndex;
  final TextEditingController controller;
  final String title;
  final String error;
  final bool loading;
  final bool scrollControlled;

  const SelectionField({
    @required this.choices,
    @required this.selectedIndex,
    @required this.controller,
    @required this.title,
    this.error,
    this.loading = false,
    this.scrollControlled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!loading && choices.isNotEmpty) {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: scrollControlled,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (_) {
                return BottomSheetList(
                  choices: choices,
                  selectedIndex: (index) {
                    controller?.text = choices[index];
                    selectedIndex(index);
                  },
                  title: title,
                );
              });
        }
      },
      child: AbsorbPointer(
        child: CustomTextFormField(
          controller: controller,
          label: title,
          error: error,
          suffixIcon: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Icon(Icons.keyboard_arrow_down_sharp),
          ),
        ),
      ),
    );
  }
}
