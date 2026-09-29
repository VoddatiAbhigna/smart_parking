import 'package:flutter/material.dart';

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;
    Orientation orientation = mediaQuery.orientation;

    String deviceType;
    int crossAxisCount;

    if (width < 600) {
      deviceType = "Mobile";
      crossAxisCount = 1;
    } else if (width < 900) {
      deviceType = "Tablet";
      crossAxisCount = 2;
    } else {
      deviceType = "Desktop";
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          "Responsive Student Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Roll Number: 24WH1A05T8",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              "Screen Width : ${width.toStringAsFixed(0)} px",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Text(
              "Screen Height : ${height.toStringAsFixed(0)} px",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Text(
              "Orientation : ${orientation == Orientation.portrait ? "Portrait" : "Landscape"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Text(
              "Device Type : $deviceType",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: const [
                  DashboardCard(
                    title: "Student Details",
                    icon: Icons.person,
                    color: Colors.blue,
                  ),
                  DashboardCard(
                    title: "Attendance",
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  DashboardCard(
                    title: "Marks",
                    icon: Icons.school,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}