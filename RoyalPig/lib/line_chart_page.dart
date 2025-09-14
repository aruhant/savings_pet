import 'package:flutter/material.dart';
import 'stats.dart';
import 'dynamo_stream_listener.dart';
import 'chart.dart';

class LineChartStats extends StatefulWidget {
  const LineChartStats({Key? key}) : super(key: key);

  @override
  State<LineChartStats> createState() => _LineChartStatsState();
}

class _LineChartStatsState extends State<LineChartStats> {
  List<SocialStats> stats = [];

  @override
  void initState() {
    super.initState();
  }

  setup() {
    final listener = DynamoStreamListener<SocialStats>(
      tableName: "stats",
      fromJson: (json) => SocialStats.fromJson(json),
    );

    listener.currentItems.then((items) {
      setState(() {
        stats = items;
      });
    });

    listener.listen(
      onEvents: (events) {
        for (var event in events) {
          print('Event Type: ${event.type}');
          if (event.newItem != null) {
            print('New Item: ${event.newItem}');
          }
          if (event.oldItem != null) {
            print('Old Item: ${event.oldItem}');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LineChartTotals();
  }
}
