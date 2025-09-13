import 'package:flutter/material.dart';
import 'stats.dart';
import 'dynamo_stream_listener.dart';
import 'chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<SocialStats> stats = [];

  @override
  void initState() {
    super.initState();

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
