import 'package:copy_trading/models/activity_details.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_view_model.dart';
import 'package:copy_trading/screens/strategy_screen/widgets/activity_cell.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Activity extends StatefulWidget {
  final String strategyName;

  const Activity({Key key, @required this.strategyName}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final DateFormat dateFormat = DateFormat('d MMMM, yyyy');
  final ScrollController _scrollController = ScrollController();

  Function reachedBottom = () {};

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime nowComparable = DateTime(now.year, now.month, now.day);
    if (date?.isAtSameMomentAs(nowComparable) ?? false) {
      return 'Today';
    }
    if (date?.isAtSameMomentAs(nowComparable.subtract(const Duration(days: 1))) ?? false) {
      return 'Yesterday';
    }

    return date != null ? dateFormat.format(date) : '';
  }

  Widget _typeLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('Reached the bottom');
      reachedBottom();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('Reached the top');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final StrategyViewModel strategyViewModel = watch(strategyProvider(widget.strategyName));

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 50),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CupertinoSlidingSegmentedControl(
                    children: {
                      0: _typeLabel('Open'),
                      1: _typeLabel('Close'),
                    },
                    onValueChanged: (index) {
                      strategyViewModel
                          .changeActivityType(index == 0 ? ActivityType.open : ActivityType.closed);
                    },
                    thumbColor: Colors.white,
                    groupValue: strategyViewModel.activityType == ActivityType.open ? 0 : 1,
                  ),
                ),
                if (strategyViewModel.loading) ...[
                  Expanded(child: DefaultLoader())
                ] else ...[
                  if (strategyViewModel.activities.isNotEmpty) ...[
                    Sizer.vertical24(),
                    Expanded(
                      child: GroupedListView<ActivityDetails, String>(
                        controller: _scrollController,
                        elements: strategyViewModel.activities.toList(),
                        groupBy: (element) => _formatDate(element.date),
                        groupHeaderBuilder: (activity) => Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: SectionTitleWidget(
                            title: _formatDate(activity.date),
                          ),
                        ),
                        groupSeparatorBuilder: (_) => Sizer.vertical24(),
                        indexedItemBuilder: (context, activity, index) {
                          reachedBottom = () => strategyViewModel.getActivity();
                          return ActivityCell(activityDetails: activity);
                        },
                        sort: false,
                        itemComparator: (item1, item2) => item2.date.compareTo(item1.date),
                      ),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Text('No Records to Display'),
                      ),
                    ),
                  ],
                  if (strategyViewModel.loadingMoreActivities) ...[
                    DefaultLoader(),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
