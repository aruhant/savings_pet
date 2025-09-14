import 'package:flutter/material.dart';
import 'package:goals/shopping_items.dart';

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.title,
    required this.subtitle,
    required this.place,
    required this.date,
    required this.price,
    required this.goalKey,
    required Null Function(dynamic goalKey, dynamic amount) this.onPurchase,
  });

  final String title;
  final String subtitle;
  final String place;
  final String date;
  final double price;
  final dynamic goalKey;
  final Null Function(dynamic goalKey, dynamic amount) onPurchase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Expanded(
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
        ),
        Text(
          '$place - $date',
          style: const TextStyle(fontSize: 12.0, color: Colors.black87),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$price\$',
              style: const TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
            ElevatedButton(
              onPressed: () {
                onPurchase(goalKey, price);
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.place,
    required this.date,
    required this.price,
    required this.goalKey,
    required Null Function(dynamic goalKey, dynamic amount) this.onPurchase,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String place;
  final String date;
  final double price;
  final dynamic goalKey;
  final Null Function(dynamic goalKey, dynamic amount) onPurchase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(aspectRatio: 1.0, child: thumbnail),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  onPurchase: onPurchase,
                  title: title,
                  subtitle: subtitle,
                  place: place,
                  date: date,
                  price: price,
                  goalKey: goalKey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({
    super.key,
    required Null Function(dynamic goalKey, dynamic amount) this.onPurchase,
  });

  final Null Function(dynamic goalKey, dynamic amount) onPurchase;

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<ShoppingItem> items = [];
  @override
  void initState() {
    super.initState();
    ShoppingItems.items.then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy')),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: items.map((item) {
          return ProductListItem(
            onPurchase: widget.onPurchase,
            thumbnail: Image.network(item.imageUrl, fit: BoxFit.cover),
            title: item.title,
            subtitle: item.subtitle,
            place: item.place,
            date: item.date,
            price: item.price,
            goalKey: item,
          );
        }).toList(),
      ),
    );
  }
}
