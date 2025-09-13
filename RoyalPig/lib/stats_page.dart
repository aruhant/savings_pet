import 'package:flutter/material.dart';
import 'package:goals/line_chart_page.dart';
import 'package:goals/pie_chart_page.dart';
import 'package:tab_container/tab_container.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
  }

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TabContainer(
          tabEdge: TabEdge.left,
          tabsStart: 0.1,
          tabsEnd: 0.6,
          borderRadius: BorderRadius.circular(20),
          childPadding: const EdgeInsets.all(20.0),
          tabs: _getTabs4(),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          unselectedTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 13.0,
          ),
          colors: const <Color>[
            Color(0xff9aebed),
            Color(0xfffa86be),
            Color(0xffa275e3),
          ],
          children: _getChildren(),
        ),
      ),
    );
  }

  List<Widget> _getChildren() => <Widget>[
    SingleChildScrollView(child: LineChartStats()),
    PiChartPage(),
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page 3',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 50.0),
          const Text(
            '''Phasellus a rutrum lectus. Maecenas turpis nisi, imperdiet non tellus eget, aliquam bibendum urna. Nullam tincidunt aliquam sem, eget finibus mauris commodo nec. Sed pharetra varius augue, id dignissim tortor vulputate at. Nunc sodales, nisl a ornare posuere, dolor purus pulvinar nulla, vel facilisis magna justo id tortor. Aliquam tempus nulla diam, non faucibus ligula cursus id. Maecenas vitae lorem augue. Aliquam hendrerit urna quis mi ornare pharetra. Duis vitae urna porttitor, porta elit a, egestas nibh. Etiam sollicitudin tincidunt sem pellentesque fringilla. Aenean sed mauris non augue hendrerit volutpat. Praesent consectetur metus ex, eu feugiat risus rhoncus sed. Suspendisse dapibus, nunc vel rhoncus placerat, tellus odio tincidunt mi, sed sagittis dui nulla eu erat.''',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  ];

  List<Widget> _getTabs4() {
    return <Widget>[
      const Icon(Icons.show_chart),
      const Icon(Icons.pie_chart),
      const Icon(Icons.list),
    ];
  }
}
