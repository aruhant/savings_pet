import 'package:goals/martian_service.dart';

class ShoppingItems {
  static List<ShoppingItem> _items = [
    ShoppingItem(
      title: 'Round-trip flight to Europe',
      subtitle:
          'This is a significant upfront cost for your European adventure.',
      place: 'Departure City to Europe',
      date: 'Before Jul 1, 2029',
      price: 1000.00,
      imageUrl:
          'https://img.freepik.com/premium-vector/airplane-clip-art-white-background-cartoon-style-vector-illustration_1195672-98.jpg',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'Travel Insurance',
      subtitle:
          'Essential for covering unexpected medical emergencies, trip cancellations, or lost luggage.',
      place: 'Pre-trip planning',
      date: 'Before Jul 1, 2029',
      price: 100.00,
      imageUrl:
          'https://media.istockphoto.com/id/1283419859/vector/bandage-icon-on-transparent-background.jpg?s=612x612&w=0&k=20&c=HPn4O1RvzuS2ckbqCioCiTUJ5XImEnUaQqBOMJhd4ys=',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'SIM Card/eSIM for Europe',
      subtitle:
          'Stay connected with local data and calls throughout your trip.',
      place: 'Arrival City (e.g., Paris)',
      date: 'Jul 1, 2029',
      price: 30.00,
      imageUrl:
          'https://img.freepik.com/premium-vector/sim-card-clip-art-vector-design-with-white-background_579306-12144.jpg',
      portfolio: 'balanced',
    ),
    // Day 1: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Accommodation in a central Parisian hotel or Airbnb.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 180.00,
      imageUrl:
          'https://media.istockphoto.com/id/1069967580/vector/hotel-isolated-on-city-street-vector-illustration-flat-modern-skyscraper-hotel-building-near.jpg?s=612x612&w=0&k=20&c=IGAFFsCn84kLidKR95k6UYGNHyZI0ugSzmDqpY0rwt0=',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'Coffee & Croissant',
      subtitle: 'Classic Parisian breakfast at a local cafe.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 8.00,
      imageUrl:
          'https://media.istockphoto.com/id/1177931528/vector/coffee-and-croissant-in-flat-style-vector-illustration.jpg?s=612x612&w=0&k=20&c=ssoQY3pZSSIRY2AMpVkFy6q4f6tuzof3zAqvokzj1gA=',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'Paris Metro Ticket',
      subtitle: 'First ride on the iconic Paris Metro to explore the city.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 2.50,
      imageUrl:
          'https://img.freepik.com/premium-vector/train-clipart-cartoon-style-vector-illustration_761413-3955.jpg',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'Lunch at a Boulangerie',
      subtitle:
          'A delicious sandwich or quiche for a quick and affordable lunch.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 15.00,
      imageUrl:
          'https://media.istockphoto.com/id/1153262021/vector/sub-sandwich-illustration.jpg?s=612x612&w=0&k=20&c=mRPnmtgubNKyeNXqdmEd6wrMS6rxADjP_pgocHeOFsg=',
      portfolio: 'balanced',
    ),
    ShoppingItem(
      title: 'Seine River Cruise',
      subtitle:
          'A relaxing boat tour offering unique views of Parisian landmarks.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 18.00,
      imageUrl: 'https://thumbs.dreamstime.com/b/cruise-clipart-9321986.jpg',
      portfolio: 'growth',
    ),
    ShoppingItem(
      title: 'Dinner in Le Marais',
      subtitle: 'Explore the charming Marais district and enjoy dinner.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 45.00,
      imageUrl:
          'https://img.freepik.com/premium-vector/steak-dinner-plate-clip-art-vector-design-with-white-background_579306-14313.jpg',
      portfolio: 'growth',
    ),
    ShoppingItem(
      title: 'Gelato/Dessert',
      subtitle: 'A sweet treat after dinner.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 7.00,
      imageUrl:
          'https://i0.wp.com/pearlyarts.com/wp-content/uploads/2021/11/Mint-ice-cream-Clipart-WM.png',
      portfolio: 'growth',
    ),
  ];

  static Future<List<ShoppingItem>> get items =>
      Future.delayed(Duration(seconds: 1), () => _items);

  static Future generateListForGoal(String goal) async {
    _items = await MartianService.getItems(goal);
    return _items;
  }
}

class ShoppingItem {
  final String title;
  final String subtitle;
  final String place;
  final String date;
  final double price;
  final String portfolio;
  final String imageUrl;

  ShoppingItem({
    required this.title,
    required this.subtitle,
    required this.place,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.portfolio,
  });
}
