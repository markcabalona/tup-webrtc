import 'package:flutter/material.dart';
import 'package:tuplive/core/presentation/widgets/spacers.dart';

class ViewersCountWidget extends StatelessWidget {
  const ViewersCountWidget({
    Key? key,
    required this.count,
  }) : super(key: key);
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: count > 0
          ? '$count ${count > 1 ? 'people are' : 'person is'} watching'
          : 'No one is watching',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility),
          HorizontalSpacers.small,
          Text(count.toString()),
        ],
      ),
    );
  }
}
