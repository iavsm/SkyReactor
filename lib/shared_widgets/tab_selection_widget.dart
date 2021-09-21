import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class TabSelectionWidget extends StatefulWidget {
  final List<Widget> children;
  final Function(int) onSelected;

  const TabSelectionWidget({Key key, @required this.children, @required this.onSelected})
      : super(key: key);
  @override
  _TabSelectionWidgetState createState() => _TabSelectionWidgetState();
}

class _TabSelectionWidgetState extends State<TabSelectionWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.children.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBar(
          controller: _tabController,
          labelColor: kColorPrimary,
          labelPadding: const EdgeInsets.only(top: 22, bottom: 5),
          indicatorWeight: 3,
          indicatorColor: kColorAccent,
          tabs: widget.children,
          onTap: widget.onSelected,
        ),
      ),
    );
  }
}
