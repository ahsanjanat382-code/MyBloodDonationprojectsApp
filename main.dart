import 'package:flutter/material.dart';

void main() => runApp(const BloodLinkApp());

const red = Color(0xFFE53945);
const ink = Color(0xFF202333);
const muted = Color(0xFF777D8D);
const pale = Color(0xFFFFF1F2);

class BloodLinkApp extends StatelessWidget {
  const BloodLinkApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'BloodLink',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red),
      scaffoldBackgroundColor: const Color(0xFFF8F9FC),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: ink, elevation: 0),
    ),
    home: const MainScreen(),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tab = 0;
  final search = TextEditingController();
  final donors = [
    {'name':'Ahmad Rahimi','group':'O+','area':'Jalalabad • 1.2 km','last':'Available today'},
    {'name':'Maryam Safi','group':'A+','area':'Jalalabad • 2.4 km','last':'Available today'},
    {'name':'Farid Khan','group':'B+','area':'Surkh Rod • 4.1 km','last':'Available tomorrow'},
    {'name':'Laila Noori','group':'AB-','area':'Jalalabad • 3.0 km','last':'Available today'},
  ];
  String query = '';
  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _donorsPage(),
      _requestsPage(),
      _profilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        backgroundColor: Colors.white,
        indicatorColor: pale,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: red), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: red), label: 'Donors'),
          NavigationDestination(icon: Icon(Icons.bloodtype_outlined), selectedIcon: Icon(Icons.bloodtype, color: red), label: 'Requests'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: red), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _home() => ListView(padding: const EdgeInsets.fromLTRB(20, 14, 20, 24), children: [
    Row(children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.bloodtype, color: Colors.white, size: 29)),
      const SizedBox(width: 11),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('BloodLink', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink)),
        Text('Every drop can save a life', style: TextStyle(fontSize: 12, color: muted)),
      ])),
      IconButton(onPressed: () => _message('Notifications', 'You are all caught up.'), icon: const Icon(Icons.notifications_none, color: ink))
    ]),
    const SizedBox(height: 22),
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE53945), Color(0xFFB9152A)]), borderRadius: BorderRadius.circular(25)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Be someone’s\\nreason to smile.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const Text('Donate blood. Share hope. Save lives.', style: TextStyle(color: Colors.white70, fontSize: 13)),
      const SizedBox(height: 18),
      Wrap(spacing: 9, runSpacing: 8, children: [
        _heroButton('Find a donor', Icons.search, () => setState(() => tab = 1), false),
        _heroButton('Request blood', Icons.add, () => _requestDialog(), true),
      ]),
    ])),
    const SizedBox(height: 23),
    const Text('Quick actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _actionCard(Icons.people_alt_outlined, 'Find donors', 'Search by blood type', () => setState(() => tab = 1))),
      const SizedBox(width: 12),
      Expanded(child: _actionCard(Icons.volunteer_activism_outlined, 'Become a donor', 'Help your community', () => _message('Become a donor', 'Open Profile and add your blood group to register as a donor.'))),
    ]),
    const SizedBox(height: 22),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Urgent blood needs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
      TextButton(onPressed: () => setState(() => tab = 2), child: const Text('View all')),
    ]),
    _requestCard('O−', 'City Hospital', 'Jalalabad, Nangarhar', '2 units needed', true),
    _requestCard('B+', 'Nangarhar Teaching Hospital', 'Jalalabad, Nangarhar', '1 unit needed', false),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Row(children: [
      Icon(Icons.health_and_safety_outlined, color: red, size: 30),
      SizedBox(width: 12),
      Expanded(child: Text('Safety first\\nDonation eligibility and timing should be confirmed with a qualified medical professional.', style: TextStyle(color: ink, fontSize: 12, height: 1.45))),
    ])),
  ]);

  Widget _donorsPage() => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Find blood donors', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 6),
    const Text('Search local donors by name or blood group.', style: TextStyle(color: muted)),
    const SizedBox(height: 18),
    TextField(onChanged: (v) => setState(() => query = v.toLowerCase()), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search name, blood group...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
    const SizedBox(height: 16),
    Wrap(spacing: 8, runSpacing: 8, children: ['All','O+','O−','A+','A−','B+','B−','AB+','AB−'].map((g) => ActionChip(label: Text(g), onPressed: () => setState(() => query = g == 'All' ? '' : g.toLowerCase()), backgroundColor: query == g.toLowerCase() ? pale : Colors.white)).toList()),
    const SizedBox(height: 14),
    ...donors.where((d) => ('${d['name']} ${d['group']} ${d['area']}').toLowerCase().contains(query)).map((d) => _donorCard(d)),
    const SizedBox(height: 12),
    const Text('Demo data: contact details are not included. Connect a secure backend before using this app with real donors.', style: TextStyle(color: muted, fontSize: 12)),
  ]);

  Widget _requestsPage() => ListView(padding: const EdgeInsets.all(20), children: [
    Row(children: [const Expanded(child: Text('Blood requests', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink))), IconButton(onPressed: _requestDialog, icon: const Icon(Icons.add_circle, color: red, size: 32))]),
    const Text('Help people find compatible blood donors.', style: TextStyle(color: muted)),
    const SizedBox(height: 18),
    _requestCard('O−', 'City Hospital', 'Jalalabad, Nangarhar', '2 units needed', true),
    _requestCard('B+', 'Nangarhar Teaching Hospital', 'Jalalabad, Nangarhar', '1 unit needed', false),
    _requestCard('A+', 'Private Clinic', 'Jalalabad, Nangarhar', '1 unit needed', false),
    const SizedBox(height: 10),
    FilledButton.icon(onPressed: _requestDialog, icon: const Icon(Icons.add), label: const Text('Create blood request'), style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.all(15))),
  ]);

  Widget _profilePage() => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Your profile', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 20),
    Center(child: Container(width: 92, height: 92, decoration: const BoxDecoration(color: pale, shape: BoxShape.circle), child: const Icon(Icons.person, size: 52, color: red))),
    const SizedBox(height: 12),
    const Center(child: Text('Welcome, donor!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink))),
    const Center(child: Text('Add your details to help others find you.', style: TextStyle(color: muted))),
    const SizedBox(height: 24),
    _profileOption(Icons.person_outline, 'Personal information', 'Name and contact details', () => _editDialog('Personal information', 'Enter your name')),
    _profileOption(Icons.bloodtype_outlined, 'Blood group', 'Set your blood type', () => _editDialog('Blood group', 'e.g. O+, A−, B+')),
    _profileOption(Icons.location_on_outlined, 'Location', 'City or district', () => _editDialog('Location', 'e.g. Jalalabad')),
    _profileOption(Icons.privacy_tip_outlined, 'Privacy & safety', 'Protect donor information', () => _message('Privacy & safety', 'This prototype stores no profile data. Real deployment needs secure login, consent, and protected storage.')),
    _profileOption(Icons.info_outline, 'About BloodLink', 'Version 1.0 • Prototype', () => _message('About BloodLink', 'A community blood donation app prototype.')),
  ]);

  Widget _heroButton(String label, IconData icon, VoidCallback onTap, bool outlined) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label), style: OutlinedButton.styleFrom(foregroundColor: outlined ? red : ink, backgroundColor: outlined ? Colors.white : Colors.white.withOpacity(.92), side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12)));
  Widget _actionCard(IconData icon, String title, String subtitle, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: red)), const SizedBox(height: 14), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(fontSize: 11, color: muted))])));
  Widget _requestCard(String group, String hospital, String area, String need, bool urgent) => Container(margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [Container(width: 54, height: 58, decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(14)), child: Center(child: Text(group, style: const TextStyle(color: red, fontWeight: FontWeight.w900, fontSize: 17)))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(hospital, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)), const SizedBox(height: 4), Text(area, style: const TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 6), Text(need, style: const TextStyle(color: red, fontWeight: FontWeight.w700, fontSize: 12))])), if (urgent) const Icon(Icons.priority_high_rounded, color: red)]));
  Widget _donorCard(Map<String,String> d) => Container(margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [CircleAvatar(backgroundColor: pale, child: Text(d['group']!, style: const TextStyle(color: red, fontWeight: FontWeight.w800))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d['name']!, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)), const SizedBox(height: 4), Text(d['area']!, style: const TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 5), Text(d['last']!, style: const TextStyle(color: Color(0xFF16845B), fontSize: 11, fontWeight: FontWeight.w700))])), IconButton(onPressed: () => _message('Contact donor', 'Connect a verified contact system before contacting real donors.'), icon: const Icon(Icons.chat_bubble_outline, color: red))]));
  Widget _profileOption(IconData icon, String title, String subtitle, VoidCallback tap) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 4), leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: red)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)), trailing: const Icon(Icons.chevron_right), onTap: tap);
  void _message(String title, String message) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  void _editDialog(String title, String hint) { final c = TextEditingController(); showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: TextField(controller: c, decoration: InputDecoration(hintText: hint)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { Navigator.pop(context); _message('Saved for this demo', 'This prototype does not save data permanently.'); }, child: const Text('Save'))])); }
  void _requestDialog() {
    final name = TextEditingController(); final hospital = TextEditingController(); String group = 'O−';
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) => AlertDialog(
      title: const Text('Request blood'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Patient name or reference')),
        TextField(controller: hospital, decoration: const InputDecoration(labelText: 'Hospital / location')),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: group, decoration: const InputDecoration(labelText: 'Blood group'), items: ['O+','O−','A+','A−','B+','B−','AB+','AB−'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(), onChanged: (v) => setLocal(() => group = v ?? 'O−')),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), FilledButton(onPressed: () { Navigator.pop(ctx); _message('Request draft created', 'Your $group request is a demo only. Add a backend to publish it to donors.'); }, child: const Text('Create'))],
    )));
  }
}
