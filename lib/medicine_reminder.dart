
import 'package:flutter/material.dart';

void main() {
  runApp(const MedicineReminderApp());
}

// ------------------------------------------------------------
// APP
// ------------------------------------------------------------

class MedicineReminderApp extends StatefulWidget {
  const MedicineReminderApp({super.key});

  @override
  State<MedicineReminderApp> createState() =>
      _MedicineReminderAppState();
}

class _MedicineReminderAppState extends State<MedicineReminderApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCare',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF536DFE),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        fontFamily: 'Arial',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8C9EFF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// MODEL
// ------------------------------------------------------------

class Medicine {
  String id;
  String name;
  String dosage;
  String time;
  String frequency;
  String type;
  bool isTaken;
  DateTime createdAt;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.frequency,
    required this.type,
    this.isTaken = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

// ------------------------------------------------------------
// HOME SCREEN
// ------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String searchText = '';
  String filter = 'All';

  final List<Medicine> medicines = [
    Medicine(
      id: '1',
      name: 'Paracetamol',
      dosage: '500 mg',
      time: '09:00 AM',
      frequency: 'Once Daily',
      type: 'Tablet',
    ),
    Medicine(
      id: '2',
      name: 'Vitamin D',
      dosage: '1 Tablet',
      time: '02:00 PM',
      frequency: 'Once Daily',
      type: 'Vitamin',
      isTaken: true,
    ),
    Medicine(
      id: '3',
      name: 'Calcium',
      dosage: '1 Tablet',
      time: '08:00 PM',
      frequency: 'Once Daily',
      type: 'Tablet',
    ),
  ];

  final List<Medicine> history = [];

  List<Medicine> get filteredMedicines {
    return medicines.where((medicine) {
      final matchesSearch = medicine.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final matchesFilter = filter == 'All' ||
          (filter == 'Taken' && medicine.isTaken) ||
          (filter == 'Pending' && !medicine.isTaken);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get takenCount {
    return medicines.where((medicine) => medicine.isTaken).length;
  }

  double get progress {
    if (medicines.isEmpty) return 0;
    return takenCount / medicines.length;
  }

  void toggleMedicine(Medicine medicine) {
    setState(() {
      medicine.isTaken = !medicine.isTaken;

      if (medicine.isTaken) {
        if (!history.any((item) => item.id == medicine.id)) {
          history.add(medicine);
        }
      } else {
        history.removeWhere((item) => item.id == medicine.id);
      }
    });
  }

  void deleteMedicine(Medicine medicine) {
    setState(() {
      medicines.removeWhere((item) => item.id == medicine.id);
      history.removeWhere((item) => item.id == medicine.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showAddMedicineDialog({Medicine? medicine}) {
    final nameController =
        TextEditingController(text: medicine?.name ?? '');
    final dosageController =
        TextEditingController(text: medicine?.dosage ?? '');

    String selectedTime = medicine?.time ?? '09:00 AM';
    String selectedFrequency = medicine?.frequency ?? 'Once Daily';
    String selectedType = medicine?.type ?? 'Tablet';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                medicine == null ? 'Add Medicine' : 'Edit Medicine',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Medicine Name',
                        prefixIcon: Icon(Icons.medication_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage',
                        hintText: 'Example: 500 mg',
                        prefixIcon: Icon(Icons.science_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Medicine Type',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Tablet',
                        'Capsule',
                        'Syrup',
                        'Vitamin',
                        'Drops',
                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Once Daily',
                        'Twice Daily',
                        'Three Times Daily',
                        'As Needed',
                      ].map((frequency) {
                        return DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedFrequency = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedTime,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Time',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        '07:00 AM',
                        '09:00 AM',
                        '12:00 PM',
                        '02:00 PM',
                        '06:00 PM',
                        '08:00 PM',
                        '10:00 PM',
                      ].map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedTime = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final dosage = dosageController.text.trim();

                    if (name.isEmpty || dosage.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter medicine name and dosage',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (medicine == null) {
                        medicines.add(
                          Medicine(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: name,
                            dosage: dosage,
                            time: selectedTime,
                            frequency: selectedFrequency,
                            type: selectedType,
                          ),
                        );
                      } else {
                        medicine.name = name;
                        medicine.dosage = dosage;
                        medicine.time = selectedTime;
                        medicine.frequency = selectedFrequency;
                        medicine.type = selectedType;
                      }
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          medicine == null
                              ? 'Medicine added successfully'
                              : 'Medicine updated successfully',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(medicine == null ? 'Save' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildDashboard(),
      buildMedicinesPage(),
      buildHistoryPage(),
      buildSettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[selectedTab],
      ),
      floatingActionButton: selectedTab == 0 || selectedTab == 1
          ? FloatingActionButton.extended(
              onPressed: () => showAddMedicineDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Medicine'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DASHBOARD
  // ----------------------------------------------------------

  Widget buildDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning 👋',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Stay Healthy!',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildProgressCard(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Medicines",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (medicines.isEmpty)
            buildEmptyState()
          else
            ...medicines.map(buildMedicineCard),
          const SizedBox(height: 20),
          buildHealthTipCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF536DFE),
            Color(0xFF7C4DFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF536DFE).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Daily Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'completed',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$takenCount of ${medicines.length} medicines taken today',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildHealthTipCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Follow the instructions provided by your healthcare professional.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 65,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No medicines added yet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Tap Add Medicine to create a reminder.'),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MEDICINE CARD
  // ----------------------------------------------------------

  Widget buildMedicineCard(Medicine medicine) {
    final color = getMedicineColor(medicine.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  getMedicineIcon(medicine.type),
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.dosage,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.frequency,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    showAddMedicineDialog(medicine: medicine);
                  } else if (value == 'delete') {
                    deleteMedicine(medicine);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 19,
              ),
              const SizedBox(width: 6),
              Text(
                medicine.time,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: FilledButton.icon(
                  onPressed: () => toggleMedicine(medicine),
                  icon: Icon(
                    medicine.isTaken
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: Text(
                    medicine.isTaken ? 'Taken' : 'Mark Taken',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: medicine.isTaken
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getMedicineColor(String type) {
    switch (type) {
      case 'Vitamin':
        return Colors.orange;
      case 'Syrup':
        return Colors.pink;
      case 'Drops':
        return Colors.teal;
      case 'Capsule':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData getMedicineIcon(String type) {
    switch (type) {
      case 'Vitamin':
        return Icons.wb_sunny_outlined;
      case 'Syrup':
        return Icons.local_drink_outlined;
      case 'Drops':
        return Icons.water_drop_outlined;
      case 'Capsule':
        return Icons.medication_outlined;
      default:
        return Icons.medication_outlined;
    }
  }

  // ----------------------------------------------------------
  // MEDICINES PAGE
  // ----------------------------------------------------------

  Widget buildMedicinesPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Medicines',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your medicine reminders',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search medicines...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Taken', 'Pending'].map((item) {
              final isSelected = filter == item;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      filter = item;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        if (filteredMedicines.isEmpty)
          buildEmptyState()
        else
          ...filteredMedicines.map(buildMedicineCard),
        const SizedBox(height: 90),
      ],
    );
  }

  // ----------------------------------------------------------
  // HISTORY PAGE
  // ----------------------------------------------------------

  Widget buildHistoryPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Medicine History',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your completed medicines',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 25),
        if (history.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              children: [
                Icon(
                  Icons.history,
                  size: 65,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No history yet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text('Completed medicines will appear here.'),
              ],
            ),
          )
        else
          ...history.map(
            (medicine) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE1F5E9),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(medicine.dosage),
                      ],
                    ),
                  ),
                  Text(medicine.time),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ----------------------------------------------------------
  // SETTINGS PAGE
  // ----------------------------------------------------------

  Widget buildSettingsPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.person, size: 30),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abhigna',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Medicine Reminder User'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Change app appearance'),
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text(
              'Reminder notification support can be added later',
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Background notifications are not enabled in this version.',
                  ),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            subtitle: const Text('MediCare Medicine Reminder'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MediCare',
                applicationVersion: '1.0.0',
                applicationLegalese: 'A student Flutter project',
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Privacy'),
            subtitle: const Text(
              'This demo does not connect to an online database.',
            ),
          ),
        ),
      ],
    );
  }
}