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
          'https://images.unsplash.com/photo-1527631745211-141a0279659a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Travel Insurance',
      subtitle:
          'Essential for covering unexpected medical emergencies, trip cancellations, or lost luggage.',
      place: 'Pre-trip planning',
      date: 'Before Jul 1, 2029',
      price: 100.00,
      imageUrl:
          'https://images.unsplash.com/photo-1560520697-3fdd0fc28512?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'SIM Card/eSIM for Europe',
      subtitle:
          'Stay connected with local data and calls throughout your trip.',
      place: 'Arrival City (e.g., Paris)',
      date: 'Jul 1, 2029',
      price: 30.00,
      imageUrl:
          'https://images.unsplash.com/photo-1620288824317-0dd8f921f08a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    // Day 1: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Accommodation in a central Parisian hotel or Airbnb.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Airport Transfer (Paris)',
      subtitle:
          'Taxi, RER train, or bus fare from Charles de Gaulle (CDG) or Orly (ORY) airport to city center.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 25.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Coffee & Croissant',
      subtitle: 'Classic Parisian breakfast at a local cafe.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1511920170130-eedf31792f47?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Paris Metro Ticket (single)',
      subtitle: 'First ride on the iconic Paris Metro to explore the city.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 2.50,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch at a Boulangerie',
      subtitle:
          'A delicious sandwich or quiche for a quick and affordable lunch.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1616428780517-5a02e5b72e5c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Eiffel Tower Summit Access',
      subtitle:
          'Entry ticket to ascend to the top of the Eiffel Tower for panoramic views.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 30.00,
      imageUrl:
          'https://images.unsplash.com/photo-1502602899175-cb9ae7f1394a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner at a Brasserie',
      subtitle:
          'Enjoy traditional French cuisine in a lively brasserie setting.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 50.00,
      imageUrl:
          'https://images.unsplash.com/photo-1577749002364-750e38a20980?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Glass of Wine',
      subtitle: 'A relaxing glass of French wine with dinner.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1546747551-51206f4c7185?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Souvenir (Eiffel Tower Keychain)',
      subtitle: 'A small memento from your first day in Paris.',
      place: 'Paris',
      date: 'Jul 1, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1524278435132-7235542a225e?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 2: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Second night of accommodation in Paris.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Coffee & Pain au Chocolat',
      subtitle: 'Enjoy a classic French breakfast.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579306194872-c2e82504ae4f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Paris Metro Pass (Day)',
      subtitle: 'Unlimited travel on the metro and bus for a full day.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Louvre Museum Entry Ticket',
      subtitle:
          'Explore world-renowned art, including the Mona Lisa and Venus de Milo.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 22.00,
      imageUrl:
          'https://images.unsplash.com/photo-1524395438814-1e05a8f4c20f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near the Louvre',
      subtitle: 'Casual lunch at a cafe or creperie.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Seine River Cruise',
      subtitle:
          'A relaxing boat tour offering unique views of Parisian landmarks.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 18.00,
      imageUrl:
          'https://images.unsplash.com/photo-1587320092288-c703b41444fb?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner in Le Marais',
      subtitle: 'Explore the charming Marais district and enjoy dinner.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 45.00,
      imageUrl:
          'https://images.unsplash.com/photo-1542845688-6c8a3c8c9e5e?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Gelato/Dessert',
      subtitle: 'A sweet treat after dinner.',
      place: 'Paris',
      date: 'Jul 2, 2029',
      price: 7.00,
      imageUrl:
          'https://images.unsplash.com/photo-1570776850259-b1d5f2a1a8c3?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 3: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Third night of accommodation in Paris.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at a local cafe',
      subtitle: 'Coffee, juice, and a pastry to start the day.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Paris Metro Ticket (single)',
      subtitle: 'Travel to Montmartre area.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 2.50,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Musée d\'Orsay Entry Ticket',
      subtitle:
          'Discover Impressionist masterpieces in a beautiful former train station.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 18.00,
      imageUrl:
          'https://images.unsplash.com/photo-1616428780517-5a02e5b72e5c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Montmartre',
      subtitle: 'Casual lunch in the artistic neighborhood.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Sacre-Cœur Basilica (Donation)',
      subtitle:
          'A small donation for visiting the beautiful basilica on Montmartre hill.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1528643501768-e362d2948c26?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner and drinks in Latin Quarter',
      subtitle:
          'Enjoy the vibrant student area with a diverse range of restaurants.',
      place: 'Paris',
      date: 'Jul 3, 2029',
      price: 55.00,
      imageUrl:
          'https://images.unsplash.com/photo-1596788874136-ec14e86a0b98?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 4: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Fourth night of accommodation in Paris.',
      place: 'Paris',
      date: 'Jul 4, 2029',
      price: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast',
      subtitle: 'Coffee and a light pastry.',
      place: 'Paris',
      date: 'Jul 4, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Versailles Palace & Gardens Ticket (Day Trip)',
      subtitle:
          'Explore the opulent palace and stunning gardens of the former French monarchy.',
      place: 'Versailles (near Paris)',
      date: 'Jul 4, 2029',
      price: 25.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'RER Train Ticket to Versailles (Round-trip)',
      subtitle: 'Transportation to and from Versailles.',
      place: 'Paris',
      date: 'Jul 4, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Versailles',
      subtitle: 'Casual lunch during your day trip.',
      place: 'Versailles',
      date: 'Jul 4, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1577749002364-750e38a20980?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Snack/Coffee',
      subtitle: 'Afternoon pick-me-up.',
      place: 'Paris',
      date: 'Jul 4, 2029',
      price: 7.00,
      imageUrl:
          'https://images.unsplash.com/photo-1511920170130-eedf31792f47?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner',
      subtitle: 'Enjoy your final full dinner in Paris.',
      place: 'Paris',
      date: 'Jul 4, 2029',
      price: 45.00,
      imageUrl:
          'https://images.unsplash.com/photo-1577749002364-750e38a20980?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 5: Paris
    ShoppingItem(
      title: 'Hotel Night (Paris)',
      subtitle: 'Fifth and final night of accommodation in Paris.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at hotel/cafe',
      subtitle: 'Last Parisian breakfast.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Shopping (Souvenirs/Fashion)',
      subtitle: 'Budget for some last-minute shopping in Paris.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 50.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563694002464-a6a978f8d6d6?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch',
      subtitle: 'Light lunch before exploring another area.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 18.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Arc de Triomphe Entry',
      subtitle: 'Climb to the top for views down the Champs-Élysées.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 16.00,
      imageUrl:
          'https://images.unsplash.com/photo-1522093007470-b74737a3c79a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner at a local bistro',
      subtitle: 'A relaxed dinner before preparing for travel.',
      place: 'Paris',
      date: 'Jul 5, 2029',
      price: 40.00,
      imageUrl:
          'https://images.unsplash.com/photo-1577749002364-750e38a20980?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 6: Travel Day (Paris to Rome)
    ShoppingItem(
      title: 'Train Ticket (Paris to Rome)',
      subtitle:
          'High-speed train from Paris to Rome. (Alternatively a low-cost flight).',
      place: 'Paris to Rome',
      date: 'Jul 6, 2029',
      price: 120.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at Paris train station',
      subtitle: 'Quick coffee and pastry before departure.',
      place: 'Paris',
      date: 'Jul 6, 2029',
      price: 7.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch on train/packed lunch',
      subtitle: 'Meal during the travel portion of the day.',
      place: 'On Train',
      date: 'Jul 6, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-158223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Rome Termini to Hotel Transfer',
      subtitle:
          'Taxi, bus, or metro from Rome Termini station to your accommodation.',
      place: 'Rome',
      date: 'Jul 6, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Hotel Night (Rome)',
      subtitle: 'First night of accommodation in Rome.',
      place: 'Rome',
      date: 'Jul 6, 2029',
      price: 150.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner (Pizza & Aperitivo)',
      subtitle: 'Enjoy authentic Roman pizza and a pre-dinner drink.',
      place: 'Rome',
      date: 'Jul 6, 2029',
      price: 35.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 7: Rome
    ShoppingItem(
      title: 'Hotel Night (Rome)',
      subtitle: 'Second night of accommodation in Rome.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 150.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Coffee and Cornetto',
      subtitle: 'Italian style breakfast at a local bar.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1522093007470-b74737a3c79a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Rome Metro/Bus Ticket (single)',
      subtitle: 'First public transport ride in Rome.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 1.50,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Colosseum & Roman Forum Entry Ticket',
      subtitle:
          'Explore the iconic ancient Roman amphitheater and archaeological site.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 28.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Colosseum',
      subtitle: 'Casual pasta dish or panino.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Gelato',
      subtitle: 'Indulge in authentic Italian gelato.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1570776850259-b1d5f2a1a8c3?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Trevi Fountain (small donation)',
      subtitle: 'A small coin toss for good luck at the beautiful fountain.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 1.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner in Trastevere',
      subtitle:
          'Enjoy a traditional Roman dinner in the charming Trastevere neighborhood.',
      place: 'Rome',
      date: 'Jul 7, 2029',
      price: 40.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 8: Rome
    ShoppingItem(
      title: 'Hotel Night (Rome)',
      subtitle: 'Third night of accommodation in Rome.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 150.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at local cafe',
      subtitle: 'Coffee and a pastry.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1522093007470-b74737a3c79a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Vatican Museums & Sistine Chapel Ticket',
      subtitle:
          'Explore the vast collections of the Vatican and Michelangelo\'s masterpiece.',
      place: 'Vatican City',
      date: 'Jul 8, 2029',
      price: 30.00,
      imageUrl:
          'https://images.unsplash.com/photo-1547844111-c917ee7b1c31?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'St. Peter\'s Basilica Dome Climb',
      subtitle:
          'Entry to climb the dome for incredible views of Rome and St. Peter\'s Square.',
      place: 'Vatican City',
      date: 'Jul 8, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Vatican',
      subtitle: 'Quick and affordable lunch near the Vatican.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 18.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Bus/Metro Ticket (single)',
      subtitle: 'Transportation around Rome.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 1.50,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner with Pasta (Cacio e Pepe)',
      subtitle: 'Indulge in a classic Roman pasta dish.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 38.00,
      imageUrl:
          'https://images.unsplash.com/photo-1596788874136-ec14e86a0b98?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Water Bottle/Snack',
      subtitle: 'Stay hydrated while exploring.',
      place: 'Rome',
      date: 'Jul 8, 2029',
      price: 4.00,
      imageUrl:
          'https://images.unsplash.com/photo-1510812431401-41d2058b762e?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 9: Rome
    ShoppingItem(
      title: 'Hotel Night (Rome)',
      subtitle: 'Fourth and final night of accommodation in Rome.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 150.00,
      imageUrl:
          'https://images.unsplash.com/photo-1558223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast',
      subtitle: 'Another Roman breakfast of coffee and pastry.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 5.00,
      imageUrl:
          'https://images.unsplash.com/photo-1522093007470-b74737a3c79a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Borghese Gallery & Museum Entry',
      subtitle:
          'Entry to see Bernini and Caravaggio masterpieces (requires advance booking).',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Bike Rental (Borghese Gardens)',
      subtitle: 'Rent a bike to explore the beautiful Borghese Gardens.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Spanish Steps',
      subtitle: 'Enjoy a meal in one of Rome\'s elegant shopping districts.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 25.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Shopping (Small Souvenirs)',
      subtitle: 'Budget for small gifts or mementos from Rome.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 30.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563694002464-a6a978f8d6d6?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner & Wine',
      subtitle: 'Farewell Roman dinner with a good glass of Italian wine.',
      place: 'Rome',
      date: 'Jul 9, 2029',
      price: 45.00,
      imageUrl:
          'https://images.unsplash.com/photo-1546747551-51206f4c7185?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 10: Travel Day (Rome to Amsterdam)
    ShoppingItem(
      title: 'Flight Ticket (Rome to Amsterdam)',
      subtitle:
          'Low-cost flight from Rome Fiumicino (FCO) to Amsterdam Schiphol (AMS).',
      place: 'Rome to Amsterdam',
      date: 'Jul 10, 2029',
      price: 80.00,
      imageUrl:
          'https://images.unsplash.com/photo-1527631745211-141a0279659a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at Rome airport',
      subtitle: 'Quick bite before your flight.',
      place: 'Rome',
      date: 'Jul 10, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Airport Transfer to FCO',
      subtitle: 'Bus or train to Rome Fiumicino airport.',
      place: 'Rome',
      date: 'Jul 10, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch at Amsterdam airport/arrival',
      subtitle: 'Meal upon arrival in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 10, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Train from Schiphol to Amsterdam Centraal',
      subtitle: 'Direct train service from the airport to the city center.',
      place: 'Amsterdam',
      date: 'Jul 10, 2029',
      price: 6.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Hotel Night (Amsterdam)',
      subtitle: 'First night of accommodation in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 10, 2029',
      price: 160.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner in Jordaan District',
      subtitle: 'Enjoy dinner in the picturesque Jordaan neighborhood.',
      place: 'Amsterdam',
      date: 'Jul 10, 2029',
      price: 40.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 11: Amsterdam
    ShoppingItem(
      title: 'Hotel Night (Amsterdam)',
      subtitle: 'Second night of accommodation in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 160.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast (Pancakes/Pofertjes)',
      subtitle: 'Enjoy a Dutch breakfast with pancakes or mini pofertjes.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 12.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Anne Frank House Entry Ticket',
      subtitle: 'A moving visit to the secret annex where Anne Frank hid.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 16.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Canal Cruise',
      subtitle: 'Discover Amsterdam from its iconic waterways.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 19.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch at a Cafe',
      subtitle: 'Casual lunch at a canal-side cafe.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Bike Rental (Half Day)',
      subtitle: 'Experience Amsterdam like a local by renting a bicycle.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner (Indonesian Rijsttafel)',
      subtitle:
          'Try a traditional Indonesian rijsttafel, a culinary highlight in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 11, 2029',
      price: 50.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 12: Amsterdam
    ShoppingItem(
      title: 'Hotel Night (Amsterdam)',
      subtitle: 'Third and final night of accommodation in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 160.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast at a bakery',
      subtitle: 'Coffee and a fresh pastry.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Rijksmuseum Entry Ticket',
      subtitle:
          'Home to masterpieces by Dutch masters like Rembrandt and Vermeer.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 22.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Van Gogh Museum Entry Ticket',
      subtitle:
          'Explore the largest collection of Van Gogh\'s paintings and drawings.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 22.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch near Museumplein',
      subtitle: 'Casual lunch in the museum district.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Public Transport (tram/bus single)',
      subtitle: 'Travel between museums or to another district.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 3.50,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Dinner (Dutch Herring/Fries)',
      subtitle: 'Try some local Dutch specialties for dinner.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 30.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Waffle with toppings',
      subtitle: 'A sweet Dutch treat.',
      place: 'Amsterdam',
      date: 'Jul 12, 2029',
      price: 7.00,
      imageUrl:
          'https://images.unsplash.com/photo-1570776850259-b1d5f2a1a8c3?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 13: Amsterdam (Day trip to Zaanse Schans/Volendam)
    ShoppingItem(
      title: 'Hotel Night (Amsterdam)',
      subtitle: 'Final night of accommodation in Amsterdam.',
      place: 'Amsterdam',
      date: 'Jul 13, 2029',
      price: 160.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549611082-965306642137?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Breakfast',
      subtitle: 'Coffee and a simple breakfast.',
      place: 'Amsterdam',
      date: 'Jul 13, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Bus Ticket to Zaanse Schans/Volendam (Round-trip)',
      subtitle:
          'Day trip to traditional Dutch villages with windmills and cheese.',
      place: 'Near Amsterdam',
      date: 'Jul 13, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-158223628-ce8fdd5a6e87?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Cheese Tasting/Wooden Shoe Demonstration (Donation)',
      subtitle: 'Experience traditional Dutch crafts and food.',
      place: 'Zaanse Schans',
      date: 'Jul 13, 2029',
      price: 10.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch in Volendam',
      subtitle: 'Enjoy fresh seafood or a local dish by the harbor.',
      place: 'Volendam',
      date: 'Jul 13, 2029',
      price: 25.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Souvenir (Delft Blue item)',
      subtitle: 'A classic Dutch souvenir.',
      place: 'Zaanse Schans/Volendam',
      date: 'Jul 13, 2029',
      price: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1524278435132-7235542a225e?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Farewell Dinner in Amsterdam',
      subtitle: 'Enjoy your last dinner in Europe.',
      place: 'Amsterdam',
      date: 'Jul 13, 2029',
      price: 45.00,
      imageUrl:
          'https://images.unsplash.com/photo-1579685973956-6a2c7a88484f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),

    // Day 14: Departure
    ShoppingItem(
      title: 'Breakfast',
      subtitle: 'Last breakfast in Amsterdam before departure.',
      place: 'Amsterdam',
      date: 'Jul 14, 2029',
      price: 8.00,
      imageUrl:
          'https://images.unsplash.com/photo-1504951016757-9d7a9f8f4a3c?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Train from Amsterdam Centraal to Schiphol',
      subtitle: 'Departure transfer to Amsterdam Schiphol airport.',
      place: 'Amsterdam',
      date: 'Jul 14, 2029',
      price: 6.00,
      imageUrl:
          'https://images.unsplash.com/photo-1563503554625-24225b153b9f?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Lunch at Airport',
      subtitle: 'Meal before your flight home.',
      place: 'Amsterdam Schiphol',
      date: 'Jul 14, 2029',
      price: 18.00,
      imageUrl:
          'https://images.unsplash.com/photo-1628108535140-59f776269600?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ShoppingItem(
      title: 'Miscellaneous (contingency)',
      subtitle:
          'A small buffer for unexpected expenses or last-minute purchases.',
      place: 'Europe',
      date: 'Throughout trip',
      price: 100.00,
      imageUrl:
          'https://images.unsplash.com/photo-1527631745211-141a0279659a?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
  ];

  static Future<List<ShoppingItem>> get items =>
      Future.delayed(Duration(seconds: 1), () => _items);
}

class ShoppingItem {
  final String title;
  final String subtitle;
  final String place;
  final String date;
  final double price;
  final String imageUrl;

  ShoppingItem({
    required this.title,
    required this.subtitle,
    required this.place,
    required this.date,
    required this.price,
    required this.imageUrl,
  });
}
