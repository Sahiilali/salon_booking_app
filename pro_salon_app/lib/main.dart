import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MaterialApp(
      home: SplashScreen(), 
      debugShowCheckedModeBanner: false,
    ));

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.face_retouching_natural, size: 100, color: Color(0xFF006064)),
            SizedBox(height: 20),
            Text("PRO SALON", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF006064), letterSpacing: 3)),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Color(0xFF006064)),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.face_retouching_natural, size: 80, color: Color(0xFF006064)),
            const Text("PRO SALON", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 40),
            TextField(decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006064), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard())),
                child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Map<String, List<String>> serviceOptions = {
    'Haircut': ['Fade Cut', 'Classic Scissor Cut', 'Buzz Cut', 'Spiky Style'],
    'Facial': ['Gold Facial', 'De-Tan Pack', 'Charcoal Mask', 'Fruit Facial'],
    'Massage': ['Head Massage', 'Full Body Massage', 'Foot Spa', 'Shoulder Rub'],
    'Beard': ['Beard Trim', 'Clean Shave', 'Beard Styling', 'Moustache Shape'],
  };

  final Map<String, int> stylePrices = {
    'Fade Cut': 200, 'Classic Scissor Cut': 150, 'Buzz Cut': 100, 'Spiky Style': 180,
    'Gold Facial': 500, 'De-Tan Pack': 300, 'Charcoal Mask': 400, 'Fruit Facial': 250,
    'Head Massage': 150, 'Full Body Massage': 800, 'Foot Spa': 400, 'Shoulder Rub': 200,
    'Beard Trim': 80, 'Clean Shave': 100, 'Beard Styling': 150, 'Moustache Shape': 50,
  };

  List<Map<String, String>> allBookings = [];

  int get totalRevenue {
    int sum = 0;
    for (var b in allBookings) { sum += int.parse(b['price'] ?? '0'); }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salon Admin Panel"),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())))],
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _buildStatCard("Total Revenue", "₹$totalRevenue", Colors.teal.shade50),
              _buildStatCard("Total Bookings", allBookings.length.toString(), Colors.blueGrey.shade100),
            ]),
            const SizedBox(height: 25),
            const Text("Select Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10,
              children: [
                _serviceCard(Icons.content_cut, "Haircut", Colors.orange.shade50),
                _serviceCard(Icons.spa, "Facial", Colors.pink.shade50),
                _serviceCard(Icons.hot_tub, "Massage", Colors.purple.shade50),
                _serviceCard(Icons.face, "Beard", Colors.blue.shade50),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Manage Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
            const SizedBox(height: 10),
            allBookings.isEmpty 
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No bookings yet.")))
              : ListView.builder(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  itemCount: allBookings.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () => _deleteBooking(index),
                      leading: const CircleAvatar(backgroundColor: Color(0xFF006064), child: Icon(Icons.person, color: Colors.white)),
                      title: Text(allBookings[index]['user']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${allBookings[index]['service']} | ${allBookings[index]['date']}"),
                      trailing: Text("₹${allBookings[index]['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String val, Color col) => Expanded(child: Card(color: col, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text(title), Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
  Widget _serviceCard(IconData icon, String title, Color color) => InkWell(onTap: () => _showStyleSelection(title), child: Card(color: color, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))])));

  void _showStyleSelection(String service) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Select $service Style", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        ...serviceOptions[service]!.map((style) => ListTile(
          title: Text(style), 
          subtitle: Text("Price: ₹${stylePrices[style]}"), 
          trailing: const Icon(Icons.add_circle_outline), 
          onTap: () { Navigator.pop(context); _showBookingForm(style); }
        )),
      ])));
  }

  void _showBookingForm(String style) {
    String name = ""; 
    DateTime selectedDate = DateTime.now(); 
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder( // Ye screen ko popup ke andar update karega
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text("Booking: $style (₹${stylePrices[style]})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006064))),
                const SizedBox(height: 15),
                TextField(onChanged: (v) => name = v, decoration: const InputDecoration(labelText: "Customer Name", border: OutlineInputBorder())),
                
                // Date Picker Clickable Tile
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFF006064)), 
                  title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                    if (picked != null) setModalState(() => selectedDate = picked);
                  },
                ),
                
                // Time Picker Clickable Tile
                ListTile(
                  leading: const Icon(Icons.access_time, color: Color(0xFF006064)), 
                  title: Text("Time: ${selectedTime.format(context)}"),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime);
                    if (picked != null) setModalState(() => selectedTime = picked);
                  },
                ),
                
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006064), minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if(name.isNotEmpty) {
                      setState(() => allBookings.add({
                        'user': name, 'service': style, 
                        'date': DateFormat('yyyy-MM-dd').format(selectedDate), 
                        'time': selectedTime.format(context), 
                        'price': stylePrices[style].toString()
                      }));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("CONFIRM BOOKING", style: TextStyle(color: Colors.white))
                ),
                const SizedBox(height: 20),
              ]
            ),
          );
        }
      )
    );
  }

  void _deleteBooking(int index) {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Remove Booking"), content: const Text("Delete this entry?"),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("NO")), TextButton(onPressed: () { setState(() => allBookings.removeAt(index)); Navigator.pop(context); }, child: const Text("YES"))]));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salon Profile"), backgroundColor: const Color(0xFF006064)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Center(child: CircleAvatar(radius: 50, backgroundColor: Color(0xFF006064), child: Icon(Icons.face_retouching_natural, size: 50, color: Colors.white))),
        const SizedBox(height: 20),
        const Center(child: Text("Pro Salon - Sahil's Branch", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const Center(child: Text("Admin: Misbah Tanwar", style: TextStyle(color: Colors.grey))),
        const Divider(height: 40),
        const ListTile(leading: Icon(Icons.phone), title: Text("Contact"), subtitle: Text("+91 9876543210")),
        const ListTile(leading: Icon(Icons.location_on), title: Text("Location"), subtitle: Text("Mumbai, India")),
        const Divider(),
        const Text("Management Rules", style: TextStyle(fontWeight: FontWeight.bold)),
        const ListTile(title: Text("All prices are fixed."), trailing: Icon(Icons.check_circle, color: Colors.green)),
      ]),
    );
  }
}