// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Allowed package for state management
import 'dart:async'; // Required for Future.delayed
import 'dart:math'; // Required for Random

void main() {
  runApp(const MyApp());
}

// Data Model for Personal Information
class KisiselBilgilerData extends ChangeNotifier {
  String _adSoyad = '';
  int _yas = 0;
  double _kilo = 0.0;
  double _boy = 0.0;
  String _kanGrubu = '';

  String get adSoyad => _adSoyad;
  int get yas => _yas;
  double get kilo => _kilo;
  double get boy => _boy;
  String get kanGrubu => _kanGrubu;

  KisiselBilgilerData({
    String adSoyad = 'Misafir',
    int yas = 25,
    double kilo = 70.0,
    double boy = 170.0,
    String kanGrubu = 'B+ (RH+)',
  }) : _adSoyad = adSoyad,
       _yas = yas,
       _kilo = kilo,
       _boy = boy,
       _kanGrubu = kanGrubu;

  void updateBilgiler({
    String? adSoyad,
    int? yas,
    double? kilo,
    double? boy,
    String? kanGrubu,
  }) {
    _adSoyad = adSoyad ?? _adSoyad;
    _yas = yas ?? _yas;
    _kilo = kilo ?? _kilo;
    _boy = boy ?? _boy;
    _kanGrubu = kanGrubu ?? _kanGrubu;
    notifyListeners();
  }
}

// Data Model for Live Status (Canlı Durum)
class CanliDurumData extends ChangeNotifier {
  double _kanSekeri = 90.0; // mg/dL
  int _nabiz = 72; // bpm
  double _vucutSicakligi = 36.5; // °C
  bool _veriAliciBagli = true; // Simulates connection status

  double get kanSekeri => _kanSekeri;
  int get nabiz => _nabiz;
  double get vucutSicakligi => _vucutSicakligi;
  bool get veriAliciBagli => _veriAliciBagli;

  CanliDurumData({
    double kanSekeri = 90.0,
    int nabiz = 72,
    double vucutSicakligi = 36.5,
    bool veriAliciBagli = true,
  }) : _kanSekeri = kanSekeri,
       _nabiz = nabiz,
       _vucutSicakligi = vucutSicakligi,
       _veriAliciBagli = veriAliciBagli;

  void updateCanliDurum({
    double? kanSekeri,
    int? nabiz,
    double? vucutSicakligi,
    bool? veriAliciBagli,
  }) {
    _kanSekeri = kanSekeri ?? _kanSekeri;
    _nabiz = nabiz ?? _nabiz;
    _vucutSicakligi = vucutSicakligi ?? _vucutSicakligi;
    _veriAliciBagli = veriAliciBagli ?? _veriAliciBagli;
    notifyListeners();
  }
}

// Data Model for Sugar Analysis (Şeker Analizi)
class SekerAnalizData extends ChangeNotifier {
  final List<Map<String, dynamic>> _okumalar = [
    {'tarih': '2023-10-26 08:00', 'deger': 95},
    {'tarih': '2023-10-26 12:00', 'deger': 140},
    {'tarih': '2023-10-26 18:00', 'deger': 110},
    {'tarih': '2023-10-27 08:00', 'deger': 88},
    {'tarih': '2023-10-27 13:00', 'deger': 160},
  ];

  List<Map<String, dynamic>> get okumalar => _okumalar;

  SekerAnalizData();

  void addOkuma(String tarih, int deger) {
    _okumalar.add({'tarih': tarih, 'deger': deger});
    // Sort by date if needed, but for simplicity, adding chronologically.
    notifyListeners();
  }

  // Example for calculating average
  double get ortalamaSekerDegeri {
    if (_okumalar.isEmpty) return 0.0;
    return _okumalar
            .map<int>((e) => e['deger'] as int)
            .reduce((a, b) => a + b) /
        _okumalar.length;
  }
}

// Data Model for a single meal entry
class BeslenmeKayit {
  final DateTime tarihSaat;
  final String
  ogunTipi; // e.g., 'Kahvaltı', 'Öğle Yemeği', 'Akşam Yemeği', 'Ara Öğün'
  final String aciklama; // e.g., 'Yulaf ezmesi, meyve, fındık'
  final int kalori; // Estimated calories

  BeslenmeKayit({
    required this.tarihSaat,
    required this.ogunTipi,
    required this.aciklama,
    required this.kalori,
  });
}

// Data Model for Meal Tracking
class BeslenmeTakipData extends ChangeNotifier {
  final List<BeslenmeKayit> _kayitlar = [];

  List<BeslenmeKayit> get kayitlar => _kayitlar;

  BeslenmeTakipData() {
    // Initial dummy data for demonstration
    _kayitlar.add(
      BeslenmeKayit(
        tarihSaat: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        ogunTipi: 'Kahvaltı',
        aciklama: 'Yumurta, peynir, zeytin, domates',
        kalori: 350,
      ),
    );
    _kayitlar.add(
      BeslenmeKayit(
        tarihSaat: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        ogunTipi: 'Öğle Yemeği',
        aciklama: 'Tavuk salata',
        kalori: 400,
      ),
    );
    _kayitlar.add(
      BeslenmeKayit(
        tarihSaat: DateTime.now().subtract(const Duration(hours: 3)),
        ogunTipi: 'Akşam Yemeği',
        aciklama: 'Izgara balık, sebze',
        kalori: 500,
      ),
    );
    _kayitlar.add(
      BeslenmeKayit(
        tarihSaat: DateTime.now(),
        ogunTipi: 'Ara Öğün',
        aciklama: 'Elma, bir avuç badem',
        kalori: 150,
      ),
    );

    // Sort by date/time, newest first
    _kayitlar.sort(
      (BeslenmeKayit a, BeslenmeKayit b) => b.tarihSaat.compareTo(a.tarihSaat),
    );
  }

  void addKayit(BeslenmeKayit kayit) {
    _kayitlar.insert(0, kayit); // Add to beginning for newest first
    _kayitlar.sort(
      (BeslenmeKayit a, BeslenmeKayit b) => b.tarihSaat.compareTo(a.tarihSaat),
    ); // Re-sort
    notifyListeners();
  }

  // Helper to get total calories for a given day
  int getTotalCaloriesForDate(DateTime date) {
    return _kayitlar
        .where(
          (BeslenmeKayit k) =>
              k.tarihSaat.year == date.year &&
              k.tarihSaat.month == date.month &&
              k.tarihSaat.day == date.day,
        )
        .map<int>((BeslenmeKayit k) => k.kalori)
        .fold(0, (int sum, int kalori) => sum + kalori);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<KisiselBilgilerData>(
          create: (BuildContext context) => KisiselBilgilerData(),
        ),
        ChangeNotifierProvider<CanliDurumData>(
          // Provided at app root for global access
          create: (BuildContext context) => CanliDurumData(),
        ),
        ChangeNotifierProvider<SekerAnalizData>(
          // Provided at app root for global access
          create: (BuildContext context) => SekerAnalizData(),
        ),
        ChangeNotifierProvider<BeslenmeTakipData>(
          // NEW PROVIDER for meal tracking
          create: (BuildContext context) => BeslenmeTakipData(),
        ),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Sağlık Uygulaması', // System-level title for task switcher
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(
                0xFFFBF9F2,
              ), // Light background for AppBar matching logo image
              foregroundColor: Colors.black, // Dark text/icon color on AppBar
              elevation: 1, // Subtle shadow for AppBar
              centerTitle: true, // Center app bar titles
            ),
            scaffoldBackgroundColor: const Color(
              0xFFFBF9F2,
            ), // Overall app background color matching logo image
            inputDecorationTheme: InputDecorationTheme(
              // Global input decoration theme
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                // Replaced Theme.of(context).primaryColor with a constant color derived from primarySwatch
                borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            cardTheme: CardTheme(
              // Directly instantiate CardThemeData
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
            ),
          ),
          home: const GirisSayfasi(), // Start with the new onboarding page
        );
      },
    );
  }
}

/// CustomPainter for the icon part of the GlucoAI logo (the drop with circuit and outer circle).
class _GlucoAIIconPainter extends CustomPainter {
  final Color dropColor;
  final Color circuitColor;

  _GlucoAIIconPainter({required this.dropColor, required this.circuitColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double minDim = size.shortestSide;
    final double width = size.width;
    final double height = size.height;

    // Paint for outer circle
    final Paint outerCirclePaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDim * 0.05;

    // Paint for inner drop
    final Paint dropPaint = Paint()
      ..color = dropColor
      ..style = PaintingStyle.fill;

    // Paint for circuit lines and dots
    final Paint circuitPaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDim * 0.02;
    final Paint circuitDotPaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.fill;

    // Calculate effective radius for the outer circle to be centered
    final double outerCircleRadius =
        minDim / 2 - outerCirclePaint.strokeWidth / 2;
    final Offset outerCircleCenter = Offset(width / 2, height / 2);

    // Draw outer circle
    canvas.drawCircle(outerCircleCenter, outerCircleRadius, outerCirclePaint);

    // Draw the teardrop shape using quadratic Bézier curves for smoothness
    Path dropPath = Path();

    // Define points relative to the available size to make the drawing responsive.
    final double startX = width / 2 - minDim * 0.3;
    final double startY =
        height / 2 + minDim * 0.35; // Bottom-left of the drop's base

    final double endX = width / 2 + minDim * 0.3;
    final double endY =
        height / 2 + minDim * 0.35; // Bottom-right of the drop's base

    final double tipX = width / 2;
    final double tipY = height / 2 - minDim * 0.45; // Top tip of the drop

    final double controlPoint1X = width / 2 - minDim * 0.4;
    final double controlPoint1Y =
        height / 2 - minDim * 0.1; // Control for left curve

    final double controlPoint2X = width / 2 + minDim * 0.4;
    final double controlPoint2Y =
        height / 2 - minDim * 0.1; // Control for right curve

    final double controlPoint3X = width / 2;
    final double controlPoint3Y =
        height / 2 + minDim * 0.5; // Control for bottom curve

    dropPath.moveTo(startX, startY);
    dropPath.quadraticBezierTo(
      controlPoint1X,
      controlPoint1Y,
      tipX,
      tipY,
    ); // Left curve to tip
    dropPath.quadraticBezierTo(
      controlPoint2X,
      controlPoint2Y,
      endX,
      endY,
    ); // Right curve to base
    dropPath.quadraticBezierTo(
      controlPoint3X,
      controlPoint3Y,
      startX,
      startY,
    ); // Bottom curve to close

    dropPath.close();
    canvas.drawPath(dropPath, dropPaint);

    // Draw circuit elements inside the drop
    final double circuitDotRadius = minDim * 0.025;

    // Positions for the three dots relative to the drop
    final Offset cDot1 = Offset(
      width / 2 - minDim * 0.12,
      height / 2 + minDim * 0.05,
    ); // Left
    final Offset cDot2 = Offset(
      width / 2 + minDim * 0.12,
      height / 2 + minDim * 0.05,
    ); // Right
    final Offset cDot3 = Offset(width / 2, height / 2 - minDim * 0.18); // Top

    canvas.drawCircle(cDot1, circuitDotRadius, circuitDotPaint);
    canvas.drawCircle(cDot2, circuitDotRadius, circuitDotPaint);
    canvas.drawCircle(cDot3, circuitDotRadius, circuitDotPaint);

    // Draw lines connecting them
    canvas.drawLine(cDot1, cDot3, circuitPaint);
    canvas.drawLine(cDot2, cDot3, circuitPaint);
    // Draw the main vertical line segment
    canvas.drawLine(
      Offset(width / 2, height / 2 + minDim * 0.25),
      cDot3,
      circuitPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _GlucoAIIconPainter) {
      return oldDelegate.dropColor != dropColor ||
          oldDelegate.circuitColor != circuitColor;
    }
    return true; // Repaint if delegate type changes
  }
}

// GlucoAI Logo Widget
class GlucoAILogo extends StatelessWidget {
  final double size;
  final Color dropColor;
  final Color circuitColor;
  final Color textColor;

  const GlucoAILogo({
    super.key,
    this.size = 120.0,
    this.dropColor = const Color(0xFFF0F7FE), // Light blue for the drop
    this.circuitColor = const Color(
      0xFF4C7FFF,
    ), // Darker blue for circuit/outer ring
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _GlucoAIIconPainter(
              dropColor: dropColor,
              circuitColor: circuitColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'GlucoAI',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlucoAILogo(
          size: 40, // Smaller logo for app bar
          dropColor: Color(0xFFF0F7FE),
          circuitColor: Color(0xFF4C7FFF),
          textColor: Colors.black87,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const <Tab>[
            Tab(text: 'Giriş Yap', icon: Icon(Icons.login)),
            Tab(text: 'Kaydol', icon: Icon(Icons.person_add)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[GirisYapTab(), KaydolTab()],
      ),
    );
  }
}

class GirisYapTab extends StatelessWidget {
  const GirisYapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const GlucoAILogo(), // Full-size logo for the main screen
              const SizedBox(height: 48),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı / E-posta',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Simulate login and navigate to the main app interface
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AnaSayfa(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Full width button
                ),
                child: const Text('Giriş Yap'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: Text(
                  'Şifremi Unuttum?',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KaydolTab extends StatelessWidget {
  const KaydolTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const GlucoAILogo(), // Full-size logo for the main screen
              const SizedBox(height: 48),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Şifre Tekrar',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Simulate registration and navigate to the main app interface
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AnaSayfa(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Full width button
                ),
                child: const Text('Kaydol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
    ); // Length changed from 4 to 5
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlucoAILogo(
          size: 40,
          dropColor: Color(0xFFF0F7FE),
          circuitColor: Color(0xFF4C7FFF),
          textColor: Colors.black87,
        ),
        automaticallyImplyLeading: false, // Hide back button for main app
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          AnasayfaIcerik(), // Index 0: Anasayfa (Dashboard)
          BlankPage(), // Index 1: Canlı Durum - Now blank
          BlankPage(), // Index 2: Şeker Analiz - Now blank
          BeslenmeTakipSayfasi(), // Index 3: Beslenme - Remains active
          BlankPage(), // Index 4: Ayarlar - Now blank
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Canlı Durum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Analiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), // NEW ICON
            label: 'Beslenme',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}

/// A blank page widget to show for disabled sections.
class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.do_not_disturb_alt,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            const SizedBox(height: 20),
            Text(
              'Bu bölüm şu anda kullanılamıyor.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Lütfen beslenme takibi sekmesini kullanın.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AnasayfaIcerik extends StatelessWidget {
  const AnasayfaIcerik({super.key});

  @override
  Widget build(BuildContext context) {
    final KisiselBilgilerData personalData = Provider.of<KisiselBilgilerData>(
      context,
    );
    final CanliDurumData liveData = Provider.of<CanliDurumData>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildWelcomeCard(context, personalData.adSoyad),
          const SizedBox(height: 16),
          _buildLiveStatusCard(context, liveData),
          const SizedBox(height: 16),
          _buildRecentReadingsCard(
            context,
            Provider.of<SekerAnalizData>(context).okumalar,
          ),
          const SizedBox(height: 16),
          _buildQuickActionsCard(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, String userName) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Merhaba, $userName!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sağlık verilerinizi takip etmeye hoş geldiniz.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusCard(BuildContext context, CanliDurumData liveData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Canlı Sağlık Durumu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildStatusRow(
              context,
              Icons.bloodtype,
              'Kan Şekeri',
              '${liveData.kanSekeri.toStringAsFixed(1)} mg/dL',
              color: liveData.kanSekeri > 120 || liveData.kanSekeri < 70
                  ? Colors.red
                  : Colors.green,
            ),
            _buildStatusRow(
              context,
              Icons.favorite,
              'Nabız',
              '${liveData.nabiz} bpm',
              color: liveData.nabiz > 100 || liveData.nabiz < 60
                  ? Colors.orange
                  : Colors.green,
            ),
            _buildStatusRow(
              context,
              Icons.thermostat,
              'Vücut Sıcaklığı',
              '${liveData.vucutSicakligi.toStringAsFixed(1)} °C',
              color:
                  liveData.vucutSicakligi > 37.5 ||
                      liveData.vucutSicakligi < 36.0
                  ? Colors.orange
                  : Colors.green,
            ),
            _buildStatusRow(
              context,
              liveData.veriAliciBagli ? Icons.sensors : Icons.sensors_off,
              'Veri Alıcısı',
              liveData.veriAliciBagli ? 'Bağlı' : 'Bağlı Değil',
              color: liveData.veriAliciBagli ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReadingsCard(
    BuildContext context,
    List<Map<String, dynamic>> readings,
  ) {
    // Show only the last 3 readings for brevity on the homepage
    final List<Map<String, dynamic>> recent = readings.reversed
        .take(3)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Son Okumalar',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Henüz bir okuma yok.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              ...recent.map<Widget>((Map<String, dynamic> reading) {
                final String date = reading['tarih'] as String;
                final int value = reading['deger'] as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        date.split(' ')[0],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        date.split(' ')[1],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '$value mg/dL',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: value > 180 || value < 70
                                  ? Colors.red
                                  : Colors.black87,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            if (readings.length > 3) ...<Widget>[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    // Navigate to SekerAnalizSayfasi (now BlankPage)
                    final AnaSayfaState? parentState = context
                        .findAncestorStateOfType<AnaSayfaState>();
                    parentState?._tabController.animateTo(
                      2,
                    ); // Index of SekerAnalizSayfasi
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Tümünü Gör'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hızlı Erişim',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildQuickActionButton(
                  context,
                  Icons.add_circle_outline,
                  'Yeni Okuma',
                  () {
                    _showAddReadingDialog(
                      context,
                    ); // This remains a dialog, not a page navigation
                  },
                ),
                _buildQuickActionButton(
                  context,
                  Icons.edit_note,
                  'Bilgileri Düzenle',
                  () {
                    // Navigate to AyarlarSayfasi (now BlankPage)
                    final AnaSayfaState? parentState = context
                        .findAncestorStateOfType<AnaSayfaState>();
                    parentState?._tabController.animateTo(
                      4,
                    ); // Index of AyarlarSayfasi (now 4)
                  },
                ),
                _buildQuickActionButton(
                  // NEW BUTTON
                  context,
                  Icons.restaurant,
                  'Beslenme Takibi',
                  () {
                    // Navigate to BeslenmeTakipSayfasi
                    final AnaSayfaState? parentState = context
                        .findAncestorStateOfType<AnaSayfaState>();
                    parentState?._tabController.animateTo(
                      3,
                    ); // Index of BeslenmeTakipSayfasi (now 3)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
          onPressed: onPressed,
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  void _showAddReadingDialog(BuildContext context) {
    final TextEditingController _readingController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Yeni Kan Şekeri Okuması Ekle'),
          content: TextField(
            controller: _readingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Değer (mg/dL)',
              hintText: 'örn: 120',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Ekle'),
              onPressed: () {
                final int? value = int.tryParse(_readingController.text);
                if (value != null && value > 0) {
                  final String currentTime =
                      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
                  Provider.of<SekerAnalizData>(
                    context,
                    listen: false,
                  ).addOkuma(currentTime, value);
                  Navigator.of(dialogContext).pop();
                } else {
                  // Show an error or toast
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen geçerli bir değer girin.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class CanliDurumSayfasi extends StatefulWidget {
  const CanliDurumSayfasi({super.key});

  @override
  State<CanliDurumSayfasi> createState() => _CanliDurumSayfasiState();
}

class _CanliDurumSayfasiState extends State<CanliDurumSayfasi> {
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Simulate real-time data updates every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _updateRandomData();
    });
  }

  void _updateRandomData() {
    final CanliDurumData liveData = Provider.of<CanliDurumData>(
      context,
      listen: false,
    );

    // Simulate slight fluctuations in values
    double newBloodSugar =
        liveData.kanSekeri + (_random.nextDouble() * 10 - 5); // +/- 5 mg/dL
    newBloodSugar = newBloodSugar.clamp(
      60.0,
      200.0,
    ); // Keep within a reasonable range

    int newHeartRate = liveData.nabiz + (_random.nextInt(5) - 2); // +/- 2 bpm
    newHeartRate = newHeartRate.clamp(
      50,
      110,
    ); // Keep within a reasonable range

    double newBodyTemp =
        liveData.vucutSicakligi +
        (_random.nextDouble() * 0.4 - 0.2); // +/- 0.2 °C
    newBodyTemp = newBodyTemp.clamp(
      35.5,
      38.5,
    ); // Keep within a reasonable range

    // Simulate sensor connection occasionally dropping
    bool newSensorStatus =
        _random.nextDouble() > 0.05; // 5% chance to disconnect

    liveData.updateCanliDurum(
      kanSekeri: newBloodSugar,
      nabiz: newHeartRate,
      vucutSicakligi: newBodyTemp,
      veriAliciBagli: newSensorStatus,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CanliDurumData>(
      builder: (BuildContext context, CanliDurumData liveData, Widget? child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Canlı Sağlık Verileri',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildDataCard(
                context,
                icon: Icons.bloodtype,
                label: 'Kan Şekeri',
                value: '${liveData.kanSekeri.toStringAsFixed(1)} mg/dL',
                status: _getSugarStatus(liveData.kanSekeri),
                statusColor: _getSugarStatusColor(liveData.kanSekeri),
              ),
              const SizedBox(height: 16),
              _buildDataCard(
                context,
                icon: Icons.favorite,
                label: 'Nabız',
                value: '${liveData.nabiz} bpm',
                status: _getHeartRateStatus(liveData.nabiz),
                statusColor: _getHeartRateStatusColor(liveData.nabiz),
              ),
              const SizedBox(height: 16),
              _buildDataCard(
                context,
                icon: Icons.thermostat,
                label: 'Vücut Sıcaklığı',
                value: '${liveData.vucutSicakligi.toStringAsFixed(1)} °C',
                status: _getTempStatus(liveData.vucutSicakligi),
                statusColor: _getTempStatusColor(liveData.vucutSicakligi),
              ),
              const SizedBox(height: 16),
              _buildDataCard(
                context,
                icon: liveData.veriAliciBagli
                    ? Icons.sensors
                    : Icons.sensors_off,
                label: 'Veri Alıcısı',
                value: liveData.veriAliciBagli ? 'Bağlı' : 'Bağlı Değil',
                status: liveData.veriAliciBagli ? 'Aktif' : 'Pasif',
                statusColor: liveData.veriAliciBagli
                    ? Colors.green
                    : Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 36, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for a small graph or trend line
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'Grafik Alanı (Yakında)',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSugarStatus(double value) {
    if (value < 70) return 'Düşük';
    if (value > 140) return 'Yüksek';
    return 'Normal';
  }

  Color _getSugarStatusColor(double value) {
    if (value < 70 || value > 140) return Colors.red;
    if (value >= 100 && value <= 140)
      return Colors.orange; // Slightly high post-meal
    return Colors.green;
  }

  String _getHeartRateStatus(int value) {
    if (value < 60) return 'Düşük';
    if (value > 100) return 'Yüksek';
    return 'Normal';
  }

  Color _getHeartRateStatusColor(int value) {
    if (value < 60 || value > 100) return Colors.red;
    if (value >= 90 && value <= 100) return Colors.orange;
    return Colors.green;
  }

  String _getTempStatus(double value) {
    if (value < 36.0) return 'Düşük';
    if (value > 37.5) return 'Yüksek';
    return 'Normal';
  }

  Color _getTempStatusColor(double value) {
    if (value < 36.0 || value > 37.5) return Colors.red;
    if (value >= 37.0 && value <= 37.5) return Colors.orange;
    return Colors.green;
  }
}

class SekerAnalizSayfasi extends StatelessWidget {
  const SekerAnalizSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SekerAnalizData>(
      builder: (BuildContext context, SekerAnalizData sekerAnaliz, Widget? child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Kan Şekeri Analizi',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Genel Bakış',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        context,
                        'Ortalama Değer:',
                        '${sekerAnaliz.ortalamaSekerDegeri.toStringAsFixed(1)} mg/dL',
                        Icons.insights,
                      ),
                      _buildSummaryRow(
                        context,
                        'Toplam Okuma:',
                        '${sekerAnaliz.okumalar.length} adet',
                        Icons.timeline,
                      ),
                      // Add more analysis metrics here if needed
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tüm Okumalar',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      if (sekerAnaliz.okumalar.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Henüz hiç kan şekeri okuması eklenmemiş.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // To prevent inner scrolling
                          itemCount: sekerAnaliz.okumalar.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, dynamic> okuma =
                                sekerAnaliz.okumalar[index];
                            final String tarih = okuma['tarih'] as String;
                            final int deger = okuma['deger'] as int;
                            final Color valueColor = (deger > 180 || deger < 70)
                                ? Colors.red
                                : Colors.black87;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tarih,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    '$deger mg/dL',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: valueColor,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddReadingDialog(context),
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Yeni Okuma Ekle'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAddReadingDialog(BuildContext context) {
    final TextEditingController _readingController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Yeni Kan Şekeri Okuması Ekle'),
          content: TextField(
            controller: _readingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Değer (mg/dL)',
              hintText: 'örn: 120',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Ekle'),
              onPressed: () {
                final int? value = int.tryParse(_readingController.text);
                if (value != null && value > 0) {
                  final String currentTime =
                      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
                  Provider.of<SekerAnalizData>(
                    context,
                    listen: false,
                  ).addOkuma(currentTime, value);
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen geçerli bir değer girin.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class BeslenmeTakipSayfasi extends StatelessWidget {
  const BeslenmeTakipSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BeslenmeTakipData>(
      builder: (BuildContext context, BeslenmeTakipData beslenmeData, Widget? child) {
        // Calculate total calories for today
        final int todayCalories = beslenmeData.getTotalCaloriesForDate(
          DateTime.now(),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Beslenme Takibi',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Bugünkü Özet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        context,
                        'Bugün Tüketilen Kalori:',
                        '$todayCalories kcal',
                        Icons.local_fire_department,
                      ),
                      _buildSummaryRow(
                        context,
                        'Toplam Kayıt:',
                        '${beslenmeData.kayitlar.length} adet',
                        Icons.list_alt,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tüm Öğün Kayıtları',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      if (beslenmeData.kayitlar.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Henüz hiç beslenme kaydı eklenmemiş.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: beslenmeData.kayitlar.length,
                          itemBuilder: (BuildContext context, int index) {
                            final BeslenmeKayit kayit =
                                beslenmeData.kayitlar[index];
                            final String formattedDate =
                                '${kayit.tarihSaat.day.toString().padLeft(2, '0')}.${kayit.tarihSaat.month.toString().padLeft(2, '0')}.${kayit.tarihSaat.year}';
                            final String formattedTime =
                                '${kayit.tarihSaat.hour.toString().padLeft(2, '0')}:${kayit.tarihSaat.minute.toString().padLeft(2, '0')}';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          kayit.ogunTipi,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '$formattedDate $formattedTime',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      kayit.aciklama,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        '${kayit.kalori} kcal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddMealDialog(context),
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Yeni Öğün Ekle'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    String? selectedMealType = 'Kahvaltı'; // Default
    final List<String> mealTypes = [
      'Kahvaltı',
      'Öğle Yemeği',
      'Akşam Yemeği',
      'Ara Öğün',
    ];

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage dialog's internal state
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Yeni Öğün Kaydı Ekle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Öğün Tipi',
                        prefixIcon: Icon(Icons.restaurant_menu),
                      ),
                      value: selectedMealType,
                      items: mealTypes.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMealType = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama (örn: Izgara tavuk, salata)',
                        prefixIcon: Icon(Icons.description),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: caloriesController,
                      decoration: const InputDecoration(
                        labelText: 'Kalori (kcal)',
                        hintText: 'örn: 450',
                        prefixIcon: Icon(Icons.local_fire_department),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Ekle'),
                  onPressed: () {
                    final String description = descriptionController.text
                        .trim();
                    final int? calories = int.tryParse(caloriesController.text);

                    if (selectedMealType != null &&
                        description.isNotEmpty &&
                        calories != null &&
                        calories > 0) {
                      final BeslenmeKayit newKayit = BeslenmeKayit(
                        tarihSaat: DateTime.now(),
                        ogunTipi: selectedMealType!,
                        aciklama: description,
                        kalori: calories,
                      );
                      Provider.of<BeslenmeTakipData>(
                        context,
                        listen: false,
                      ).addKayit(newKayit);
                      Navigator.of(dialogContext).pop();
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen tüm alanları doğru doldurun.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AyarlarSayfasi extends StatefulWidget {
  const AyarlarSayfasi({super.key});

  @override
  State<AyarlarSayfasi> createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  late TextEditingController _adSoyadController;
  late TextEditingController _yasController;
  late TextEditingController _kiloController;
  late TextEditingController _boyController;
  String? _selectedKanGrubu;
  final List<String> _kanGruplari = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    '0+',
    '0-',
  ];

  @override
  void initState() {
    super.initState();
    final KisiselBilgilerData personalData = Provider.of<KisiselBilgilerData>(
      context,
      listen: false,
    );
    _adSoyadController = TextEditingController(text: personalData.adSoyad);
    _yasController = TextEditingController(text: personalData.yas.toString());
    _kiloController = TextEditingController(text: personalData.kilo.toString());
    _boyController = TextEditingController(text: personalData.boy.toString());
    _selectedKanGrubu = personalData.kanGrubu;
  }

  @override
  void dispose() {
    _adSoyadController.dispose();
    _yasController.dispose();
    _kiloController.dispose();
    _boyController.dispose();
    super.dispose();
  }

  void _savePersonalData() {
    final KisiselBilgilerData personalData = Provider.of<KisiselBilgilerData>(
      context,
      listen: false,
    );
    final String newAdSoyad = _adSoyadController.text;
    final int? newYas = int.tryParse(_yasController.text);
    final double? newKilo = double.tryParse(_kiloController.text);
    final double? newBoy = double.tryParse(_boyController.text);

    personalData.updateBilgiler(
      adSoyad: newAdSoyad,
      yas: newYas,
      kilo: newKilo,
      boy: newBoy,
      kanGrubu: _selectedKanGrubu,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bilgileriniz başarıyla güncellendi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Ayarlar',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Kişisel Bilgiler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  TextFormField(
                    controller: _adSoyadController,
                    decoration: const InputDecoration(
                      labelText: 'Ad Soyad',
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (String value) =>
                        _savePersonalData(), // Live update
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _yasController,
                    decoration: const InputDecoration(
                      labelText: 'Yaş',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) => _savePersonalData(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kiloController,
                    decoration: const InputDecoration(
                      labelText: 'Kilo (kg)',
                      prefixIcon: Icon(Icons.scale),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (String value) => _savePersonalData(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _boyController,
                    decoration: const InputDecoration(
                      labelText: 'Boy (cm)',
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (String value) => _savePersonalData(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Kan Grubu',
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                    value: _selectedKanGrubu,
                    items: _kanGruplari.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedKanGrubu = newValue;
                      });
                      _savePersonalData();
                    },
                  ),
                  const SizedBox(height: 24),
                  // No explicit "Save" button needed due to live updates, but keeping the pattern
                  // ElevatedButton(
                  //   onPressed: _savePersonalData,
                  //   child: const Text('Bilgileri Kaydet'),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Uygulama Ayarları',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Bildirimler'),
                    trailing: Switch(
                      value: true, // Example value
                      onChanged: (bool value) {
                        // Handle notification settings change
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Koyu Tema'),
                    trailing: Switch(
                      value: false, // Example value
                      onChanged: (bool value) {
                        // Handle theme change
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Simulate logout and navigate back to GirisSayfasi
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const GirisSayfasi(),
                ),
                (Route<void> route) => false, // Remove all previous routes
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Çıkış Yap'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
