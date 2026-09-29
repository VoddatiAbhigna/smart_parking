import 'package:flutter/material.dart';

void main() {
  runApp(const SmartParkingApp());
}

// ============================================================
// APP
// ============================================================

class SmartParkingApp extends StatefulWidget {
  const SmartParkingApp({super.key});

  @override
  State<SmartParkingApp> createState() => _SmartParkingAppState();
}

class _SmartParkingAppState extends State<SmartParkingApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkEase',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3867FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D8DFF),
          brightness: Brightness.dark,
        ),
      ),

      home: MainScreen(
        darkMode: darkMode,
        onDarkModeChanged: (value) {
          setState(() {
            darkMode = value;
          });
        },
      ),
    );
  }
}

// ============================================================
// DATA
// ============================================================

class ParkingPlace {
  final String name;
  final String location;
  final String distance;
  final double rating;
  final int available;
  final int total;
  final int price;
  bool favorite;

  ParkingPlace({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.available,
    required this.total,
    required this.price,
    this.favorite = false,
  });
}

class Booking {
  final String id;
  final String parking;
  final String slot;
  final String date;
  final String time;
  final String vehicle;
  final int amount;

  Booking({
    required this.id,
    required this.parking,
    required this.slot,
    required this.date,
    required this.time,
    required this.vehicle,
    required this.amount,
  });
}

// ============================================================
// MAIN SCREEN
// ============================================================

class MainScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const MainScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  String searchText = '';

  final List<ParkingPlace> parkingPlaces = [
    ParkingPlace(
      name: 'City Center Parking',
      location: 'Banjara Hills',
      distance: '0.4 km',
      rating: 4.8,
      available: 18,
      total: 40,
      price: 30,
    ),
    ParkingPlace(
      name: 'Metro Mall Parking',
      location: 'Punjagutta',
      distance: '0.8 km',
      rating: 4.7,
      available: 12,
      total: 35,
      price: 40,
    ),
    ParkingPlace(
      name: 'Tech Park Parking',
      location: 'Hitech City',
      distance: '1.2 km',
      rating: 4.6,
      available: 25,
      total: 50,
      price: 25,
    ),
    ParkingPlace(
      name: 'Central Mall Parking',
      location: 'Madhapur',
      distance: '1.6 km',
      rating: 4.5,
      available: 8,
      total: 30,
      price: 50,
    ),
  ];

  final List<Booking> bookings = [];

  List<ParkingPlace> get filteredParking {
    if (searchText.isEmpty) {
      return parkingPlaces;
    }

    return parkingPlaces.where((parking) {
      return parking.name
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          parking.location
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      explorePage(),
      bookingPage(),
      profilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),

      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HOME
  // ==========================================================

  Widget homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3867FF),
                      Color(0xFF7048E8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning 👋',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Abhigna',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: showNotifications,
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // LOCATION
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF3867FF),
                size: 20,
              ),
              const SizedBox(width: 5),
              const Text(
                'Hyderabad, Telangana',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 19,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // SEARCH
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Where do you want to park?',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF3867FF),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune_rounded),
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 17),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // HERO CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3867FF),
                  Color(0xFF7048E8),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3867FF)
                      .withOpacity(.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -25,
                  child: Icon(
                    Icons.local_parking_rounded,
                    size: 150,
                    color: Colors.white.withOpacity(.08),
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SMART PARKING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Park smarter.\nDrive happier.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Find and reserve your parking spot\nbefore you reach your destination.',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            const Color(0xFF3867FF),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Explore Parking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 27),

          // QUICK ACTIONS
          sectionTitle('Quick Actions', 'See all'),

          const SizedBox(height: 13),

          Row(
            children: [
              quickAction(
                Icons.map_outlined,
                'Map',
                const Color(0xFF3867FF),
              ),
              const SizedBox(width: 12),
              quickAction(
                Icons.qr_code_2,
                'My Pass',
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 12),
              quickAction(
                Icons.directions_car_outlined,
                'My Cars',
                const Color(0xFF10B981),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // NEARBY
          sectionTitle('Nearby Parking', 'View all'),

          const SizedBox(height: 13),

          ...filteredParking
              .take(3)
              .map((parking) => parkingCard(parking)),
        ],
      ),
    );
  }

  // ==========================================================
  // QUICK ACTION
  // ==========================================================

  Widget quickAction(
    IconData icon,
    String title,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: Theme.of(context)
                .dividerColor
                .withOpacity(.5),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFF3867FF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PARKING CARD
  // ==========================================================

  Widget parkingCard(ParkingPlace parking) {
    return InkWell(
      borderRadius: BorderRadius.circular(23),
      onTap: () => openDetails(parking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // PARKING IMAGE
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF3867FF)
                            .withOpacity(.12),
                        const Color(0xFF7048E8)
                            .withOpacity(.08),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(19),
                  ),
                  child: const Icon(
                    Icons.local_parking_rounded,
                    color: Color(0xFF3867FF),
                    size: 40,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              parking.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                parking.favorite =
                                    !parking.favorite;
                              });
                            },
                            child: Icon(
                              parking.favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: parking.favorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            parking.location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            parking.distance,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            parking.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green
                          .withOpacity(.08),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 17,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${parking.available} spots',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Text(
                  '₹${parking.price}/hr',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 9),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3867FF),
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: const Text(
                    'Book',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // EXPLORE
  // ==========================================================

  Widget explorePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Explore',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Find the perfect parking spot',
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        // MAP
        Container(
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE7F0E8),
                Color(0xFFD9E6D8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Roads
              Positioned(
                top: 95,
                left: -20,
                right: -20,
                child: Container(
                  height: 48,
                  color: Colors.white.withOpacity(.7),
                ),
              ),

              Positioned(
                top: -20,
                bottom: -20,
                left: 145,
                child: Container(
                  width: 45,
                  color: Colors.white.withOpacity(.7),
                ),
              ),

              Positioned(
                left: 30,
                top: 55,
                child: parkingMapPin('A', Colors.blue),
              ),

              Positioned(
                right: 50,
                top: 35,
                child: parkingMapPin('B', Colors.green),
              ),

              Positioned(
                left: 65,
                bottom: 35,
                child: parkingMapPin('C', Colors.orange),
              ),

              Positioned(
                right: 45,
                bottom: 55,
                child: parkingMapPin('D', Colors.purple),
              ),

              const Center(
                child: Icon(
                  Icons.my_location,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'All Parking Locations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ...parkingPlaces.map(parkingCard),
      ],
    );
  }

  Widget parkingMapPin(
    String letter,
    Color color,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'P$letter',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BOOKINGS
  // ==========================================================

  Widget bookingPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Your parking passes and reservations',
        ),

        const SizedBox(height: 25),

        if (bookings.isEmpty)
          emptyBookings()
        else
          ...bookings.map(bookingCard),
      ],
    );
  }

  Widget emptyBookings() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF3867FF)
                  .withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              size: 55,
              color: Color(0xFF3867FF),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your parking reservations will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          FilledButton(
            onPressed: () {
              setState(() {
                currentIndex = 1;
              });
            },
            child: const Text('Find Parking'),
          ),
        ],
      ),
    );
  }

  Widget bookingCard(Booking booking) {
    return InkWell(
      onTap: () => showBookingPass(booking),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3867FF),
                    Color(0xFF7048E8),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_parking,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.parking,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Slot ${booking.slot} • ${booking.date}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Confirmed',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${booking.amount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // PROFILE
  // ==========================================================

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3867FF),
                Color(0xFF7048E8),
              ],
            ),
            borderRadius: BorderRadius.circular(27),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF3867FF),
                ),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abhigna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Smart Parking Member',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // STATISTICS
        Row(
          children: [
            profileStat(
              '${bookings.length}',
              'Bookings',
              Icons.confirmation_number_outlined,
            ),
            const SizedBox(width: 12),
            profileStat(
              '4',
              'Favorites',
              Icons.favorite_border,
            ),
            const SizedBox(width: 12),
            profileStat(
              '12',
              'Trips',
              Icons.directions_car_outlined,
            ),
          ],
        ),

        const SizedBox(height: 25),

        profileOption(
          Icons.directions_car_outlined,
          'My Vehicle',
          'TS 09 AB 1234',
        ),

        profileOption(
          Icons.payment_outlined,
          'Payment Methods',
          'UPI, Cards',
        ),

        profileOption(
          Icons.notifications_outlined,
          'Notifications',
          'Booking alerts',
        ),

        SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5),
          secondary: const Icon(
            Icons.dark_mode_outlined,
          ),
          title: const Text(
            'Dark Mode',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          value: widget.darkMode,
          onChanged: widget.onDarkModeChanged,
        ),

        profileOption(
          Icons.help_outline,
          'Help & Support',
          'Need help?',
        ),

        profileOption(
          Icons.info_outline,
          'About ParkEase',
          'Version 1.0.0',
        ),
      ],
    );
  }

  Widget profileStat(
    String value,
    String title,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3867FF),
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileOption(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF3867FF)
                .withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF3867FF),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ==========================================================
  // DETAILS
  // ==========================================================

  void openDetails(ParkingPlace parking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParkingBookingPage(
          parking: parking,
          onBooked: (booking) {
            setState(() {
              bookings.add(booking);
            });

            Navigator.pop(context);

            Future.delayed(
              const Duration(milliseconds: 200),
              () {
                showBookingPass(booking);
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // BOOKING PASS
  // ==========================================================

  void showBookingPass(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Parking Pass',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                ParkingPassCard(
                  booking: booking,
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // NOTIFICATIONS
  // ==========================================================

  void showNotifications() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.local_parking),
                ),
                title: Text('Parking spots available'),
                subtitle: Text(
                  '18 spots are available near you.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.check),
                ),
                title: Text('Welcome to ParkEase'),
                subtitle: Text(
                  'Find and reserve parking easily.',
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// BOOKING PAGE
// ============================================================

class ParkingBookingPage extends StatefulWidget {
  final ParkingPlace parking;
  final ValueChanged<Booking> onBooked;

  const ParkingBookingPage({
    super.key,
    required this.parking,
    required this.onBooked,
  });

  @override
  State<ParkingBookingPage> createState() =>
      _ParkingBookingPageState();
}

class _ParkingBookingPageState
    extends State<ParkingBookingPage> {
  String? selectedSlot;

  int duration = 1;

  String vehicle = 'Car';

  String payment = 'UPI';

  DateTime date = DateTime.now();

  final List<String> slots = [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'B4',
    'C1',
    'C2',
    'C3',
    'C4',
    'D1',
    'D2',
    'D3',
    'D4',
    'E1',
    'E2',
    'E3',
    'E4',
  ];

  final Set<String> occupied = {
    'A3',
    'B2',
    'B4',
    'C1',
    'D3',
    'E4',
  };

  int get total => widget.parking.price * duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reserve Parking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          30,
        ),
        children: [
          // PARKING HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3867FF),
                  Color(0xFF7048E8),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_parking,
                    color: Colors.white,
                    size: 35,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.parking.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.parking.location,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Select your parking spot',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Choose an available slot below',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 18),

          // PARKING MAP
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Container(
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '        🚗     ENTRANCE     🚗',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: slots.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                    childAspectRatio: .9,
                  ),
                  itemBuilder: (_, index) {
                    return parkingSlot(slots[index]);
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    legend(
                      Colors.green,
                      'Available',
                    ),
                    legend(
                      Colors.blue,
                      'Selected',
                    ),
                    legend(
                      Colors.red,
                      'Occupied',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // DATE
          settingTitle(
            'Date',
            Icons.calendar_month_outlined,
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: selectDate,
            borderRadius: BorderRadius.circular(17),
            child: Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface,
                borderRadius:
                    BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Color(0xFF3867FF),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${date.day} ${month(date.month)} ${date.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          // DURATION
          settingTitle(
            'Duration',
            Icons.access_time,
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Color(0xFF3867FF),
                ),
                const SizedBox(width: 12),
                Text(
                  '$duration hour${duration > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: duration > 1
                      ? () {
                          setState(() {
                            duration--;
                          });
                        }
                      : null,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                ),
                Text(
                  '$duration',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      duration++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // VEHICLE
          settingTitle(
            'Vehicle',
            Icons.directions_car_outlined,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              vehicleChoice(
                'Car',
                Icons.directions_car,
              ),
              const SizedBox(width: 10),
              vehicleChoice(
                'Bike',
                Icons.two_wheeler,
              ),
              const SizedBox(width: 10),
              vehicleChoice(
                'SUV',
                Icons.directions_car_filled,
              ),
            ],
          ),

          const SizedBox(height: 22),

          // PAYMENT
          settingTitle(
            'Payment Method',
            Icons.payment_outlined,
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            children: [
              paymentChoice(
                'UPI',
                Icons.account_balance,
              ),
              paymentChoice(
                'Card',
                Icons.credit_card,
              ),
              paymentChoice(
                'Cash',
                Icons.payments_outlined,
              ),
            ],
          ),

          const SizedBox(height: 25),

          // SUMMARY
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3867FF)
                      .withOpacity(.08),
                  const Color(0xFF7048E8)
                      .withOpacity(.06),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                summaryRow(
                  'Parking fee',
                  '₹$total',
                ),

                summaryRow(
                  'Service fee',
                  '₹5',
                ),

                const Divider(height: 25),

                summaryRow(
                  'Total',
                  '₹${total + 5}',
                  bold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CONFIRM
          SizedBox(
            height: 57,
            child: FilledButton(
              onPressed: selectedSlot == null
                  ? null
                  : confirmBooking,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                ),
              ),
              child: Text(
                selectedSlot == null
                    ? 'Select a Parking Slot'
                    : 'Confirm & Pay  ₹${total + 5}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget parkingSlot(String slot) {
    bool isOccupied = occupied.contains(slot);
    bool isSelected = selectedSlot == slot;

    Color color;

    if (isOccupied) {
      color = Colors.red;
    } else if (isSelected) {
      color = Colors.blue;
    } else {
      color = Colors.green;
    }

    return InkWell(
      onTap: isOccupied
          ? null
          : () {
              setState(() {
                selectedSlot = slot;
              });
            },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: color,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              slot,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget legend(Color color, String text) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget settingTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF3867FF),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget vehicleChoice(
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: ChoiceChip(
        avatar: Icon(icon, size: 17),
        label: Text(value),
        selected: vehicle == value,
        onSelected: (_) {
          setState(() {
            vehicle = value;
          });
        },
      ),
    );
  }

  Widget paymentChoice(
    String value,
    IconData icon,
  ) {
    return ChoiceChip(
      avatar: Icon(icon, size: 18),
      label: Text(value),
      selected: payment == value,
      onSelected: (_) {
        setState(() {
          payment = value;
        });
      },
    );
  }

  Widget summaryRow(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : null,
              fontSize: bold ? 19 : null,
              color: bold
                  ? const Color(0xFF3867FF)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 60)),
      initialDate: date,
    );

    if (selected != null) {
      setState(() {
        date = selected;
      });
    }
  }

  String month(int number) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[number - 1];
  }

  void confirmBooking() {
    final booking = Booking(
      id:
          'PKE-${DateTime.now().millisecondsSinceEpoch % 100000}',
      parking: widget.parking.name,
      slot: selectedSlot!,
      date:
          '${date.day}/${date.month}/${date.year}',
      time: '10:00 AM',
      vehicle: vehicle,
      amount: total + 5,
    );

    widget.onBooked(booking);
  }
}

// ============================================================
// PARKING PASS
// ============================================================

class ParkingPassCard extends StatelessWidget {
  final Booking booking;

  const ParkingPassCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3867FF),
                  Color(0xFF7048E8),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.local_parking_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 5),
                Text(
                  'PARKEASE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'DIGITAL PARKING PASS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // QR STYLE CODE
                Container(
                  width: 145,
                  height: 145,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: CustomPaint(
                    painter:
                        ParkingCodePainter(booking.id),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  booking.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                passRow(
                  Icons.local_parking,
                  'Parking',
                  booking.parking,
                ),

                passRow(
                  Icons.grid_3x3,
                  'Slot',
                  booking.slot,
                ),

                passRow(
                  Icons.calendar_month,
                  'Date',
                  booking.date,
                ),

                passRow(
                  Icons.access_time,
                  'Time',
                  booking.time,
                ),

                passRow(
                  Icons.directions_car,
                  'Vehicle',
                  booking.vehicle,
                ),

                const Divider(height: 25),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL PAID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '₹${booking.amount}',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3867FF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.1),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PAYMENT CONFIRMED',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget passRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF3867FF),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QR-STYLE PAINTER
// ============================================================

class ParkingCodePainter extends CustomPainter {
  final String value;

  ParkingCodePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const count = 21;

    final cellW = size.width / count;
    final cellH = size.height / count;

    final data = value.codeUnits;

    for (int row = 0; row < count; row++) {
      for (int col = 0; col < count; col++) {
        int number =
            data[(row * count + col) % data.length];

        if ((number + row * 7 + col * 11) % 5 < 2) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellW,
              row * cellH,
              cellW,
              cellH,
            ),
            black,
          );
        }
      }
    }

    drawFinder(
      canvas,
      black,
      white,
      0,
      0,
      cellW,
    );

    drawFinder(
      canvas,
      black,
      white,
      size.width - cellW * 7,
      0,
      cellW,
    );

    drawFinder(
      canvas,
      black,
      white,
      0,
      size.height - cellH * 7,
      cellW,
    );
  }

  void drawFinder(
    Canvas canvas,
    Paint black,
    Paint white,
    double x,
    double y,
    double cell,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(
        x,
        y,
        cell * 7,
        cell * 7,
      ),
      black,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        x + cell,
        y + cell,
        cell * 5,
        cell * 5,
      ),
      white,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        x + cell * 2,
        y + cell * 2,
        cell * 3,
        cell * 3,
      ),
      black,
    );
  }

  @override
  bool shouldRepaint(
    covariant ParkingCodePainter oldDelegate,
  ) {
    return oldDelegate.value != value;
  }
}