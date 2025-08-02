import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Future.delayed
import 'dart:math'; // Required for Random
import 'package:url_launcher/url_launcher.dart'; // Allowed package for URL launching

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<KisiselBilgilerData>(
            create: (BuildContext context) => KisiselBilgilerData()),
        ChangeNotifierProvider<CanliDurumData>(
            create: (BuildContext context) => CanliDurumData()),
        ChangeNotifierProvider<SekerAnalizData>(
            create: (BuildContext context) => SekerAnalizData()),
        ChangeNotifierProvider<MotivasyonData>(
            create: (BuildContext context) => MotivasyonData()),
        ChangeNotifierProvider<IlacTakipData>(
            create: (BuildContext context) => IlacTakipData()),
        ChangeNotifierProvider<LabSonuclariData>(
            create: (BuildContext context) => LabSonuclariData()),
        ChangeNotifierProvider<AcilDurumData>(
            create: (BuildContext context) => AcilDurumData()),
        ChangeNotifierProvider<BeslenmeData>(
            create: (BuildContext context) => BeslenmeData()),
        ChangeNotifierProvider<EgzersizData>(
            create: (BuildContext context) => EgzersizData()),
        ChangeNotifierProvider<DanismaData>(
            create: (BuildContext context) => DanismaData()),
        // New provider for notification settings
        ChangeNotifierProvider<BildirimAyarlariData>(
            create: (BuildContext context) => BildirimAyarlariData()),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Sağlık Uygulaması', // System-level title for task switcher
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            appBarTheme: const AppBarTheme(
              backgroundColor:
                  Color(0xFFFBF9F2), // Light background for AppBar matching logo image
              foregroundColor: Colors.black, // Dark text/icon color on AppBar
              elevation: 1, // Subtle shadow for AppBar
              centerTitle: true, // Center app bar titles
            ),
            scaffoldBackgroundColor:
                const Color(0xFFFBF9F2), // Overall app background color matching logo image
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
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
    final double outerCircleRadius = minDim / 2 - outerCirclePaint.strokeWidth / 2;
    final Offset outerCircleCenter = Offset(width / 2, height / 2);

    // Draw outer circle
    canvas.drawCircle(outerCircleCenter, outerCircleRadius, outerCirclePaint);

    // Draw the teardrop shape using quadratic Bézier curves for smoothness
    Path dropPath = Path();

    // Define points relative to the available size to make the drawing responsive.
    final double startX = width / 2 - minDim * 0.3;
    final double startY = height / 2 + minDim * 0.35; // Bottom-left of the drop's base

    final double endX = width / 2 + minDim * 0.3;
    final double endY = height / 2 + minDim * 0.35; // Bottom-right of the drop's base

    final double tipX = width / 2;
    final double tipY = height / 2 - minDim * 0.45; // Top tip of the drop

    final double controlPoint1X = width / 2 - minDim * 0.4;
    final double controlPoint1Y = height / 2 - minDim * 0.1; // Control for left curve

    final double controlPoint2X = width / 2 + minDim * 0.4;
    final double controlPoint2Y = height / 2 - minDim * 0.1; // Control for right curve

    final double controlPoint3X = width / 2;
    final double controlPoint3Y = height / 2 + minDim * 0.5; // Control for bottom curve

    dropPath.moveTo(startX, startY);
    dropPath.quadraticBezierTo(controlPoint1X, controlPoint1Y, tipX, tipY); // Left curve to tip
    dropPath.quadraticBezierTo(controlPoint2X, controlPoint2Y, endX, endY); // Right curve to base
    dropPath.quadraticBezierTo(controlPoint3X, controlPoint3Y, startX, startY); // Bottom curve to close

    dropPath.close();
    canvas.drawPath(dropPath, dropPaint);

    // Draw circuit elements inside the drop
    final double circuitDotRadius = minDim * 0.025;

    // Positions for the three dots relative to the drop
    final Offset cDot1 = Offset(width / 2 - minDim * 0.12, height / 2 + minDim * 0.05); // Left
    final Offset cDot2 = Offset(width / 2 + minDim * 0.12, height / 2 + minDim * 0.05); // Right
    final Offset cDot3 = Offset(width / 2, height / 2 - minDim * 0.18); // Top

    canvas.drawCircle(cDot1, circuitDotRadius, circuitDotPaint);
    canvas.drawCircle(cDot2, circuitDotRadius, circuitDotPaint);
    canvas.drawCircle(cDot3, circuitDotRadius, circuitDotPaint);

    // Draw lines connecting them
    canvas.drawLine(cDot1, cDot3, circuitPaint);
    canvas.drawLine(cDot2, cDot3, circuitPaint);
    // Draw the main vertical line segment
    canvas.drawLine(Offset(width / 2, height / 2 + minDim * 0.25), cDot3, circuitPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _GlucoAIIconPainter) {
      return oldDelegate.dropColor != dropColor || oldDelegate.circuitColor != circuitColor;
    }
    return true; // Repaint if delegate type changes
  }
}

/// Widget to display the complete GlucoAI logo, combining the custom-drawn icon and text.
class GlucoAILogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;

  const GlucoAILogo({
    super.key,
    this.iconSize = 40.0,
    this.fontSize = 24.0,
  });

  // Colors derived from the provided image for consistency
  static const Color _kDropColor = Color(0xFF1E5B7B); // Dark teal/blue for the drop
  static const Color _kCircuitColor = Color(0xFF2FAAB1); // Light teal/blue for circuit and outer circle
  static const Color _kTextColor = Color(0xFF154160); // Very dark blue for text

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Use minimum space required by children
      children: <Widget>[
        CustomPaint(
          size: Size.square(iconSize), // Square canvas for the icon
          painter: _GlucoAIIconPainter(
            dropColor: _kDropColor,
            circuitColor: _kCircuitColor,
          ),
        ),
        SizedBox(width: iconSize * 0.15), // Spacing between icon and text
        Text(
          'GlucoAI',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: _kTextColor,
          ),
        ),
      ],
    );
  }
}

/// New initial login/onboarding page
class GirisSayfasi extends StatelessWidget {
  const GirisSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const GlucoAILogo(iconSize: 80.0, fontSize: 48.0),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const UyelikSayfasi(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: GlucoAILogo._kCircuitColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Üye Ol'), // Changed from 'Yeni Üye Ol' to 'Üye Ol'
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // For "Giriş Yap", we'll navigate to the device connection page
                  // This simulates a user returning to the app and needing to connect their device.
                  // In a real app, this would involve checking persisted login/profile state.
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ChangeNotifierProvider<CihazBaglantiData>(
                        create: (BuildContext context) => CihazBaglantiData(),
                        builder: (BuildContext context, Widget? child) => const CihazBaglantiPage(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: GlucoAILogo._kTextColor,
                  elevation: 0,
                ),
                child: const Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnaMenu extends StatelessWidget {
  const AnaMenu({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => page), // Explicit type argument
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlucoAILogo(iconSize: 32.0, fontSize: 22.0), // Smaller size for AppBar
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor, // Use theme primary color
        unselectedItemColor: Colors.grey, // Grey for unselected items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
        onTap: (int index) {
          // Handle navigation for BottomNavigationBar items
          if (index == 1) {
            // If settings tab is tapped
            navigateTo(context, const AyarlarPage());
          }
          // If index is 0 (home), we are already on the AnaMenu, so no action needed.
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Consumer<CanliDurumData>(
              builder: (BuildContext context, CanliDurumData canliDurumData, Widget? child) {
                final double currentGlucose = canliDurumData.currentGlucose;
                String glucoseStatus;
                Color statusColor;

                if (currentGlucose < 70) {
                  glucoseStatus = 'Düşük';
                  statusColor = Colors.red;
                } else if (currentGlucose > 180) {
                  glucoseStatus = 'Yüksek';
                  statusColor = Colors.orange;
                } else {
                  glucoseStatus = 'Normal';
                  statusColor = Colors.green;
                }
                return Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Mevcut Glikoz Seviyesi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${currentGlucose.toStringAsFixed(1)} mg/dL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Durum: $glucoseStatus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        // Removed the simulation control button and status text from AnaMenu
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7, // Adjusted to make items taller, giving more space for text
                children: <Widget>[
                  MenuItem(
                    icon: Icons.apple,
                    label: 'Beslenme',
                    onTap: () => navigateTo(
                      context,
                      const BeslenmePage(),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.directions_run,
                    label: 'Egzersiz',
                    onTap: () => navigateTo(
                      context,
                      const EgzersizPage(),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Danışma',
                    onTap: () => navigateTo(
                      context,
                      const DanismaPage(),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.medical_services_outlined,
                    label: 'Doktor',
                    onTap: () => navigateTo(context, const DoktorPage()),
                  ),
                  MenuItem(
                    icon: Icons.insert_chart_outlined,
                    label: 'Raporlar ve Analiz',
                    onTap: () => navigateTo(
                      context,
                      const RaporlarVeAnalizPage(),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.analytics_outlined,
                    label: 'Canlı Durum',
                    onTap: () => navigateTo(
                      context,
                      const CanliDurumVeSekerAnaliziPage(),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.self_improvement, // New icon for psychology
                    label: 'Psikolojik Destek',
                    onTap: () => navigateTo(context, const MotivasyonPage()),
                  ),
                  MenuItem(
                    icon: Icons.medication_outlined, // New icon for medication
                    label: 'İlaç Takip',
                    onTap: () => navigateTo(context, const IlacTakipPage()),
                  ),
                  MenuItem(
                    icon: Icons.science_outlined, // New icon for lab results
                    label: 'Laboratuvar Sonuçları',
                    onTap: () => navigateTo(context, const LabSonuclariPage()),
                  ),
                  MenuItem(
                    icon: Icons.phone_in_talk_outlined, // New icon for emergency
                    label: 'Acil Durum',
                    onTap: () => navigateTo(context, const AcilDurumPage()),
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

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuItem({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // Added Card for better visual separation and elevation
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: Theme.of(context).primaryColor), // FIXED: Reduced icon size from 60 to 48
            const SizedBox(height: 8), // FIXED: Reduced SizedBox height from 10 to 8
            Text(
              label,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ), // Added textAlign for wrapped text
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for BeslenmePage
enum MealType { kahvalti, ogleYemegi, aksamYemegi, araOgun }

class MealPlanItem {
  final MealType mealType;
  final String description;

  MealPlanItem({required this.mealType, required this.description});

  String getLocalizedMealType() {
    switch (mealType) {
      case MealType.kahvalti:
        return 'Kahvaltı';
      case MealType.ogleYemegi:
        return 'Öğle Yemeği';
      case MealType.aksamYemegi:
        return 'Akşam Yemeği';
      case MealType.araOgun:
        return 'Ara Öğün';
    }
  }
}

class BeslenmeData extends ChangeNotifier {
  // Removed _currentGlucose, as it will be passed directly from CanliDurumData
  double? _carbohydrateIntake;
  double? _insulinDose;
  List<MealPlanItem> _generatedMealPlan = <MealPlanItem>[];

  double? get carbohydrateIntake => _carbohydrateIntake;
  double? get insulinDose => _insulinDose;
  List<MealPlanItem> get generatedMealPlan => _generatedMealPlan;

  set carbohydrateIntake(double? value) {
    _carbohydrateIntake = value;
    // No notifyListeners here.
  }

  set insulinDose(double? value) {
    _insulinDose = value;
    // No notifyListeners here.
  }

  // Modified to take currentGlucose as a parameter
  void generateMealPlan(double? currentGlucose) {
    // Simulate AI logic based on glucose level
    _generatedMealPlan = <MealPlanItem>[]; // Clear previous plan

    String breakfastSuggestion = "";
    String lunchSuggestion = "";
    String dinnerSuggestion = "";
    String snackSuggestion = "";

    if (currentGlucose != null) {
      if (currentGlucose > 180) {
        // High glucose
        breakfastSuggestion = "Yulaf ezmesi ve şekersiz çay.";
        lunchSuggestion = "Izgara tavuk salata, bol yeşillikli.";
        dinnerSuggestion = "Buharda sebze ve az yağlı balık.";
        snackSuggestion = "Bir avuç badem veya salatalık dilimleri.";
      } else if (currentGlucose < 70) {
        // Low glucose
        breakfastSuggestion = "Tam buğday ekmeği ile peynir ve meyve suyu.";
        lunchSuggestion = "Mercimek çorbası ve 1 dilim tam buğday ekmeği.";
        dinnerSuggestion = "Pirinç pilavı ve sebzeli köfte.";
        snackSuggestion = "Bir muz veya birkaç kuru üzüm.";
      } else {
        // Normal glucose
        breakfastSuggestion = "Yumurta, tam buğday ekmeği ve zeytin.";
        lunchSuggestion = "Baklagil yemeği ve yoğurt.";
        dinnerSuggestion = "Zeytinyağlı sebze yemeği ve bulgur pilavı.";
        snackSuggestion = "Mevsim meyvesi veya bir kase yoğurt.";
      }
    } else {
      // No glucose data
      breakfastSuggestion = "Glikoz değeri cihazdan alınamadı. Menü oluşturmak için glikoz verisi gereklidir.";
      lunchSuggestion = "";
      dinnerSuggestion = "";
      snackSuggestion = "";
    }

    if (breakfastSuggestion.isNotEmpty) {
      _generatedMealPlan.add(MealPlanItem(mealType: MealType.kahvalti, description: breakfastSuggestion));
    }
    if (lunchSuggestion.isNotEmpty) {
      _generatedMealPlan.add(MealPlanItem(mealType: MealType.ogleYemegi, description: lunchSuggestion));
    }
    if (dinnerSuggestion.isNotEmpty) {
      _generatedMealPlan.add(MealPlanItem(mealType: MealType.aksamYemegi, description: dinnerSuggestion));
    }
    if (snackSuggestion.isNotEmpty) {
      _generatedMealPlan.add(MealPlanItem(mealType: MealType.araOgun, description: snackSuggestion));
    }

    notifyListeners();
  }
}

class BeslenmePage extends StatefulWidget {
  const BeslenmePage({super.key});
  @override
  State<BeslenmePage> createState() => _BeslenmePageState();
}

class _BeslenmePageState extends State<BeslenmePage> {
  // Removed _glucoseController
  final TextEditingController _carbController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();

  @override
  void dispose() {
    // _glucoseController.dispose(); // No longer needed
    _carbController.dispose();
    _insulinController.dispose();
    super.dispose();
  }

  void _generateMealPlan() {
    final BeslenmeData beslenmeData = Provider.of<BeslenmeData>(context, listen: false);
    final CanliDurumData canliDurumData = Provider.of<CanliDurumData>(context, listen: false);

    // Update data model properties from controllers
    // beslenmeData.currentGlucose = double.tryParse(_glucoseController.text); // No longer manually set
    beslenmeData.carbohydrateIntake = double.tryParse(_carbController.text);
    beslenmeData.insulinDose = double.tryParse(_insulinController.text);

    // Call the generation logic, passing the current glucose from live data
    beslenmeData.generateMealPlan(canliDurumData.currentGlucose);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to both BeslenmeData and CanliDurumData
    final BeslenmeData beslenmeData = Provider.of<BeslenmeData>(context);
    final CanliDurumData canliDurumData = Provider.of<CanliDurumData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Beslenme Planı Oluşturucu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Canlı Glikoz Seviyesi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${canliDurumData.currentGlucose.toStringAsFixed(1)} mg/dL',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: canliDurumData.currentGlucose < 70
                            ? Colors.red
                            : (canliDurumData.currentGlucose > 180 ? Colors.orange : Colors.green),
                      ),
                    ),
                    Text(
                      canliDurumData.isSimulating ? '(Canlı Akış Aktif)' : '(Canlı Akış Duraklatıldı)',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _carbController,
              decoration: const InputDecoration(
                labelText: 'Hedeflenen Karbonhidrat Alımı (gram)', // Changed label for clarity
                hintText: 'Örn: 150',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _insulinController,
              decoration: const InputDecoration(
                labelText: 'Beklenen İnsülin Dozu (ünite)', // Changed label for clarity
                hintText: 'Örn: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateMealPlan,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Yapay Zeka ile Menü Oluştur'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: beslenmeData.generatedMealPlan.isEmpty
                  ? const Center(
                      child: Text(
                        'Cihazdan alınan canlı verilere ve girdiğiniz bilgilere göre yapay zeka destekli menü önerileri burada görüntülenecektir.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: beslenmeData.generatedMealPlan.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MealPlanItem item = beslenmeData.generatedMealPlan[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.getLocalizedMealType(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: GlucoAILogo._kDropColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for EgzersizPage
class ExercisePlanItem {
  final String activityType;
  final String description;
  final String durationOrSets;

  ExercisePlanItem({
    required this.activityType,
    required this.description,
    required this.durationOrSets,
  });
}

class EgzersizData extends ChangeNotifier {
  String? _currentFitnessLevel;
  String? _exerciseGoal;
  List<ExercisePlanItem> _generatedExercisePlan = <ExercisePlanItem>[];

  String? get currentFitnessLevel => _currentFitnessLevel;
  String? get exerciseGoal => _exerciseGoal;
  List<ExercisePlanItem> get generatedExercisePlan => _generatedExercisePlan;

  set currentFitnessLevel(String? value) {
    _currentFitnessLevel = value;
  }

  set exerciseGoal(String? value) {
    _exerciseGoal = value;
  }

  void generateExercisePlan() {
    _generatedExercisePlan = <ExercisePlanItem>[]; // Clear previous plan

    final String fitness = _currentFitnessLevel?.toLowerCase() ?? '';
    final String goal = _exerciseGoal?.toLowerCase() ?? '';

    // Simulate AI logic based on fitness level and goal
    if (fitness.contains('başlangıç')) {
      if (goal.contains('kilo verme')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Hafif tempolu yürüyüş',
          durationOrSets: '30 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuvvet',
          description: 'Vücut ağırlığı squat',
          durationOrSets: '3 set 10 tekrar',
        ));
      } else if (goal.contains('kas')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuvvet',
          description: 'Duvar şınavı',
          durationOrSets: '3 set 8 tekrar',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Eliptik bisiklet',
          durationOrSets: '20 dakika',
        ));
      } else {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Genel',
          description: 'Hafif tempolu yürüyüş veya bisiklet sürme',
          durationOrSets: '25-30 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Esneklik',
          description: 'Temel esneme hareketleri',
          durationOrSets: '10 dakika',
        ));
      }
    } else if (fitness.contains('orta')) {
      if (goal.contains('kilo verme')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Tempolu koşu veya yüzme',
          durationOrSets: '45 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuv kuvvet',
          description: 'Dumbbell lunge',
          durationOrSets: '3 set 12 tekrar',
        ));
      } else if (goal.contains('kas')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuv kuvvet',
          description: 'Bench press veya şınav',
          durationOrSets: '4 set 8 tekrar',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Interval koşu',
          durationOrSets: '30 dakika',
        ));
      } else {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Genel',
          description: 'Orta yoğunlukta koşu veya ip atlama',
          durationOrSets: '40 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuv kuvvet',
          description: 'Vücut ağırlığı egzersizleri (squat, lunge, plank)',
          durationOrSets: '30 dakika',
        ));
      }
    } else if (fitness.contains('ileri')) {
      if (goal.contains('kilo verme')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Yüksek yoğunluklu interval antrenmanı (HIIT)',
          durationOrSets: '20-30 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuv kuvvet',
          description: 'Deadlift veya squat (ağırlıklı)',
          durationOrSets: '4 set 6-8 tekrar',
        ));
      } else if (goal.contains('kas')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuv kuvvet',
          description: 'İleri seviye ağırlık antrenmanı (bileşik hareketler)',
          durationOrSets: '60 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kardiyo',
          description: 'Kısa ve patlayıcı kardiyo seansları',
          durationOrSets: '15 dakika',
        ));
      } else {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Genel',
          description: 'İleri seviye çapraz antrenman veya fonksiyonel antrenman',
          durationOrSets: '60 dakika',
        ));
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Esneklik',
          description: 'Yoga veya pilates',
          durationOrSets: '30 dakika',
        ));
      }
    } else {
      _generatedExercisePlan.add(ExercisePlanItem(
        activityType: 'Bilgi Gerekli',
        description: 'Lütfen fitness seviyenizi (Başlangıç, Orta, İleri) ve egzersiz hedefinizi (Kilo Verme, Kas Kazanımı vb.) girin.',
        durationOrSets: '',
      ));
    }

    notifyListeners();
  }
}

class EgzersizPage extends StatefulWidget {
  const EgzersizPage({super.key});

  @override
  State<EgzersizPage> createState() => _EgzersizPageState();
}

class _EgzersizPageState extends State<EgzersizPage> {
  final TextEditingController _fitnessLevelController = TextEditingController();
  final TextEditingController _exerciseGoalController = TextEditingController();

  @override
  void dispose() {
    _fitnessLevelController.dispose();
    _exerciseGoalController.dispose();
    super.dispose();
  }

  void _generateExercisePlan() {
    final EgzersizData egzersizData = Provider.of<EgzersizData>(context, listen: false);

    egzersizData.currentFitnessLevel = _fitnessLevelController.text;
    egzersizData.exerciseGoal = _exerciseGoalController.text;

    egzersizData.generateExercisePlan();
  }

  @override
  Widget build(BuildContext context) {
    final EgzersizData egzersizData = Provider.of<EgzersizData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Egzersiz Planı Oluşturucu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _fitnessLevelController,
              decoration: const InputDecoration(
                labelText: 'Mevcut Fitness Seviyesi',
                hintText: 'Örn: Başlangıç, Orta, İleri',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _exerciseGoalController,
              decoration: const InputDecoration(
                labelText: 'Egzersiz Hedefi',
                hintText: 'Örn: Kilo Verme, Kas Kazanımı, Kardiyo',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateExercisePlan,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Yapay Zeka ile Egzersiz Planı Oluştur'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: egzersizData.generatedExercisePlan.isEmpty
                  ? const Center(
                      child: Text(
                        'Fitness seviyenizi ve egzersiz hedefinizi girerek yapay zeka destekli bir egzersiz planı alın.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: egzersizData.generatedExercisePlan.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ExercisePlanItem item = egzersizData.generatedExercisePlan[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.activityType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: GlucoAILogo._kDropColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (item.durationOrSets.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Süre/Tekrar: ${item.durationOrSets}',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for DanismaPage
class ConversationMessage {
  final String sender; // "user" or "ai"
  final String text;
  final DateTime timestamp;

  ConversationMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

class DanismaData extends ChangeNotifier {
  final List<ConversationMessage> _messages = <ConversationMessage>[
    ConversationMessage(
        sender: "ai",
        text: "Merhaba! Size nasıl yardımcı olabilirim? Sağlığınızla ilgili her türlü soruyu sorabilirsiniz.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    ConversationMessage(
        sender: "user",
        text: "Diyabet beslenmesi hakkında bilgi verebilir misin?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    ConversationMessage(
        sender: "ai",
        text:
            "Elbette! Dengeli bir beslenme planı diyabet yönetiminin temelidir. Öğünlerinizi düzenli yemek, karbonhidratları kontrol altında tutmak ve lifli gıdalar tüketmek önemlidir. Daha detaylı bilgi almak istediğiniz bir alan var mı?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 1))),
  ];
  bool _isLoading = false;

  List<ConversationMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void addMessage(String sender, String text) {
    _messages.add(ConversationMessage(sender: sender, text: text, timestamp: DateTime.now()));
    notifyListeners();
  }

  Future<void> askAI(String question) async {
    if (question.trim().isEmpty) {
      return;
    }

    // Add user's question immediately
    addMessage("user", question);

    _isLoading = true;
    notifyListeners();

    // Simulate network delay for AI response
    await Future<void>.delayed(const Duration(seconds: 2));

    final String aiResponse = _getAIResponse(question);
    addMessage("ai", aiResponse);

    _isLoading = false;
    notifyListeners();
  }

  String _getAIResponse(String question) {
    final String lowerQuestion = question.toLowerCase();

    if (lowerQuestion.contains('glikoz') || lowerQuestion.contains('şeker')) {
      return "Glikoz seviyenizle ilgili ne öğrenmek istersiniz? Beslenme, egzersiz veya kan şekeri ölçümü hakkında bilgi verebilirim.";
    } else if (lowerQuestion.contains('beslenme') || lowerQuestion.contains('yemek') || lowerQuestion.contains('diyet')) {
      return "Beslenme düzeniniz hakkında özel bir sorunuz mu v ar? Günlük menü önerileri veya karbonhidrat sayımı hakkında bilgi verebilirim.";
    } else if (lowerQuestion.contains('egzersiz') || lowerQuestion.contains('spor') || lowerQuestion.contains('aktivite')) {
      return "Egzersiz planlaması yaparken nelere dikkat etmeliyiz? Hedefleriniz veya mevcut durumunuz hakkında bilgi verirseniz daha spesifik tavsiyelerde bulunabilirim.";
    } else if (lowerQuestion.contains('ilaç') || lowerQuestion.contains('insülin') || lowerQuestion.contains('doktor')) {
      return "Önemli uyarı: İlaç kullanımı, insülin dozajı veya tıbbi teşhis gibi konularda kesinlikle bir sağlık profesyoneli, yani doktorunuza danışmalısınız. Ben bir yapay zekayım ve tıbbi tavsiye veremem.";
    } else if (lowerQuestion.contains('merhaba') || lowerQuestion.contains('selam')) {
      return "Merhaba! Size nasıl yardımcı olabilirim? Sağlığınızla ilgili her türlü soruyu sorabilirsiniz.";
    } else {
      return "Anladım. Bu konuda size daha fazla bilgi verebilmem için lütfen sorunuzu biraz daha açar mısınız? Veya farklı bir konu hakkında mı konuşmak istersiniz?";
    }
  }
}

class DanismaPage extends StatefulWidget {
  const DanismaPage({super.key});

  @override
  State<DanismaPage> createState() => _DanismaPageState();
}

class _DanismaPageState extends State<DanismaPage> {
  final TextEditingController _soruController = TextEditingController();

  void _soruGonder() {
    final DanismaData danismaData = Provider.of<DanismaData>(context, listen: false);
    danismaData.askAI(_soruController.text);
    _soruController.clear();
  }

  @override
  void dispose() {
    _soruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yapay Zeka Danışma")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<DanismaData>(
                builder: (BuildContext consumerContext, DanismaData data, Widget? child) {
                  if (data.messages.isEmpty && !data.isLoading) {
                    return const Center(
                      child: Text(
                        "Bir şey mi danışmak istiyorsunuz? Sorunuzu yazıp yapay zekaya sorun.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true, // Show latest messages at the bottom
                    itemCount: data.messages.length + (data.isLoading ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (data.isLoading && index == 0) {
                        // This will be the very bottom item if loading
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 10),
                                Text("Yapay zeka yanıt yazıyor..."),
                              ],
                            ),
                          ),
                        );
                      }
                      // Calculate the actual message index from the `_messages` list
                      final int actualMessageListIndex =
                          data.messages.length - 1 - (data.isLoading ? index - 1 : index);

                      // Ensure the index is within bounds, especially if messages list is empty
                      // but isLoading was true and then became false.
                      if (actualMessageListIndex < 0 || actualMessageListIndex >= data.messages.length) {
                        return const SizedBox.shrink(); // Should not happen with correct logic, but for safety
                      }

                      final ConversationMessage message = data.messages[actualMessageListIndex];
                      final bool isUser = message.sender == "user";
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Theme.of(consumerContext).primaryColor.withAlpha((255 * 0.1).round())
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0).copyWith(
                              bottomLeft: isUser ? const Radius.circular(15.0) : const Radius.circular(0),
                              bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(15.0),
                              topLeft: isUser ? const Radius.circular(0) : const Radius.circular(15.0),
                              topRight: isUser ? const Radius.circular(15.0) : const Radius.circular(0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                message.text,
                                style: TextStyle(color: isUser ? Theme.of(consumerContext).primaryColor : Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _soruController,
                    decoration: InputDecoration(
                      hintText: "Sorunuzu buraya yazın...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<DanismaData>(
                  builder: (BuildContext consumerContext, DanismaData data, Widget? child) {
                    return FloatingActionButton(
                      onPressed: data.isLoading ? null : _soruGonder, // Disable while loading
                      backgroundColor: data.isLoading ? Colors.grey : Theme.of(consumerContext).primaryColor,
                      child: data.isLoading
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Icon(Icons.send, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DoktorPage extends StatelessWidget {
  const DoktorPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doktor")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.medical_services_outlined, size: 80, color: GlucoAILogo._kDropColor),
              const SizedBox(height: 20),
              const Text(
                "Doktorunuzla sağlıklı veri paylaşımı ve danışmanlık burada gerçekleşir.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verileriniz doktorunuzla paylaşıldı (Simülasyon).')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Doktorunuzla Veri Paylaş'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: GlucoAILogo._kCircuitColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Randevu takviminiz açıldı (Simülasyon).')),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Randevu Oluştur/Görüntüle'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: GlucoAILogo._kTextColor,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// New page for Live Status and Glucose Analysis
class GlucoseReading {
  final double value;
  final DateTime timestamp;

  GlucoseReading({required this.value, required this.timestamp});
}

class CanliDurumData extends ChangeNotifier {
  List<GlucoseReading> _glucoseHistory;
  Timer? _timer;
  double _currentGlucose; // Initial value
  bool _isSimulating = false;
  final Random _random = Random();

  CanliDurumData()
      : _glucoseHistory = <GlucoseReading>[
          GlucoseReading(value: 100, timestamp: DateTime.now().subtract(const Duration(minutes: 60))),
          GlucoseReading(value: 110, timestamp: DateTime.now().subtract(const Duration(minutes: 45))),
          GlucoseReading(value: 125, timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
          GlucoseReading(value: 120, timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
          GlucoseReading(value: 115, timestamp: DateTime.now().subtract(const Duration(minutes: 0))),
        ],
        _currentGlucose = 115.0; // Set to the last value in the history

  List<GlucoseReading> get glucoseHistory => _glucoseHistory;
  double get currentGlucose => _currentGlucose;
  bool get isSimulating => _isSimulating;

  void toggleSimulation() {
    if (_isSimulating) {
      _timer?.cancel();
      _isSimulating = false;
    } else {
      _isSimulating = true;
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => _generateNewReading());
    }
    notifyListeners();
  }

  void _generateNewReading() {
    // Simulate glucose fluctuations (e.g., +/- 10-20 mg/dL)
    final double fluctuation =
        (_random.nextBool() ? 1 : -1) * (10 + _random.nextInt(10)).toDouble(); // Random fluctuation between 10-19
    double newGlucose = _currentGlucose + fluctuation;

    // Keep glucose within a reasonable range (e.g., 60-250)
    if (newGlucose < 60) newGlucose = 60 + _random.nextInt(10).toDouble(); // Prevent going too low
    if (newGlucose > 250) newGlucose = 250 - _random.nextInt(10).toDouble(); // Prevent going too high

    _currentGlucose = newGlucose;
    _glucoseHistory.add(GlucoseReading(value: _currentGlucose, timestamp: DateTime.now()));
    // Keep history to a reasonable size, e.g., last 20 readings
    if (_glucoseHistory.length > 20) {
      _glucoseHistory.removeAt(0);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CanliDurumVeSekerAnaliziPage extends StatelessWidget {
  const CanliDurumVeSekerAnaliziPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canlı Durum ve Şeker Analizi")),
      body: Consumer<CanliDurumData>(
        builder: (BuildContext context, CanliDurumData data, Widget? child) {
          final double currentGlucose = data.currentGlucose;
          String glucoseStatus;
          Color statusColor;
          String alertMessage = '';

          if (currentGlucose < 70) {
            glucoseStatus = 'Düşük';
            statusColor = Colors.red;
            alertMessage = 'Glikoz seviyeniz düşük! Acil önlem almaniz gerekebilir.';
          } else if (currentGlucose > 180) {
            glucoseStatus = 'Yüksek';
            statusColor = Colors.orange;
            alertMessage = 'Glikoz seviyeniz yüksek! Beslenmenizi ve aktivitenizi gözden geçirin.';
          } else {
            glucoseStatus = 'Normal';
            statusColor = Colors.green;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Mevcut Glikoz Seviyesi',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          key: ValueKey<double>(currentGlucose), // Key to trigger animation on change
                          child: Text(
                            // Changed Text to be the direct child for AnimatedSwitcher
                            '${currentGlucose.toStringAsFixed(1)} mg/dL',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Durum: $glucoseStatus',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        if (alertMessage.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 10),
                          Text(
                            alertMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: statusColor, fontWeight: FontWeight.w500),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: data.toggleSimulation,
                          icon: Icon(data.isSimulating ? Icons.pause_circle_filled : Icons.play_circle_fill),
                          label: Text(data.isSimulating ? 'Canlı Veri Akışını Durdur' : 'Canlı Veri Akışını Başlat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GlucoAILogo._kCircuitColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Son Glikoz Okumaları',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.glucoseHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      final GlucoseReading reading =
                          data.glucoseHistory[data.glucoseHistory.length - 1 - index]; // Reverse order
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: Icon(Icons.monitor_heart, color: Theme.of(context).primaryColor),
                          title: Text('${reading.value.toStringAsFixed(1)} mg/dL'),
                          subtitle: Text(
                              'Zaman: ${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}/${reading.timestamp.day.toString().padLeft(2, '0')}/${reading.timestamp.month.toString().padLeft(2, '0')}'),
                          trailing: Icon(
                            reading.value < 70
                                ? Icons.arrow_downward
                                : (reading.value > 180 ? Icons.arrow_upward : Icons.check),
                            color: reading.value < 70
                                ? Colors.red
                                : (reading.value > 180 ? Colors.orange : Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// DATA_MODEL for Glucose Analysis (new)
class SekerAnalizData extends ChangeNotifier {
  List<String> _analysisInsights = <String>[];
  String? _currentTrend;
  double? _averageGlucose;
  double? _minGlucose;
  double? _maxGlucose;
  bool _isAnalyzing = false;

  List<String> get analysisInsights => _analysisInsights;
  String? get currentTrend => _currentTrend;
  double? get averageGlucose => _averageGlucose;
  double? get minGlucose => _minGlucose;
  double? get maxGlucose => _maxGlucose;
  bool get isAnalyzing => _isAnalyzing;

  // Modified to take BuildContext to directly access CanliDurumData
  Future<void> analyzeGlucoseData(BuildContext context) async {
    _isAnalyzing = true;
    notifyListeners();

    // Get the latest glucose history directly from CanliDurumData
    final List<GlucoseReading> readings = Provider.of<CanliDurumData>(context, listen: false).glucoseHistory;

    _analysisInsights = <String>[];
    _currentTrend = null;
    _averageGlucose = null;
    _minGlucose = null;
    _maxGlucose = null;

    if (readings.isEmpty) {
      _analysisInsights.add("Analiz edilecek glikoz verisi bulunmamaktadır.");
    } else {
      await Future<void>.delayed(const Duration(seconds: 2)); // Simulate AI processing time

      final List<double> values = readings.map<double>((GlucoseReading r) => r.value).toList();
      _averageGlucose = values.reduce((double a, double b) => a + b) / values.length;
      _minGlucose = values.reduce(min);
      _maxGlucose = values.reduce(max);

      // Simple trend analysis based on last few readings
      if (readings.length >= 3) {
        final double lastValue = readings.last.value;
        final double prevValue = readings[readings.length - 2].value;
        final double beforePrevValue = readings[readings.length - 3].value;

        if (lastValue > prevValue && prevValue > beforePrevValue + 5) {
          // Threshold for significant rise
          _currentTrend = 'Yükseliş Eğilimi';
          _analysisInsights.add(
              "Glikoz seviyelerinizde belirgin bir yükseliş eğilimi gözlemlenmektedir. Karbonhidrat alımınızı kontrol etmeniz veya doktorunuza danışmanız önerilir.");
        } else if (lastValue < prevValue && prevValue < beforePrevValue - 5) {
          // Threshold for significant drop
          _currentTrend = 'Düşüş Eğilimi';
          _analysisInsights.add(
              "Glikoz seviyelerinizde düşüş eğilimi bulunmaktadır. Hafif, yavaş sindirilen bir ara öğün tüketmek veya doktorunuza danışmak faydalı olabilir.");
        } else {
          _currentTrend = 'Stabil';
          _analysisInsights.add("Glikoz seviyeleriniz genel olarak stabil seyretmektedir. Mevcut yaşam tarzınıza devam edebilirsiniz.");
        }
      } else {
        _currentTrend = 'Yeterli veri yok';
      }

      // Add insights based on overall min/max
      if (_maxGlucose! > 200) {
        _analysisInsights.add(
            "Ölçümlerinizde yüksek glikoz değerleri (${_maxGlucose!.toStringAsFixed(1)} mg/dL) gözlemlemiştir. Yemek sonrası yükselişler için beslenme düzeninizi gözden geçiriniz.");
      }
      if (_minGlucose! < 80) {
        _analysisInsights.add(
            "Ölçümlerinizde düşük glikoz değerleri (${_minGlucose!.toStringAsFixed(1)} mg/dL) gözlemlenmiştir. Hipoglisemi riskine karşı dikkatli olunuz.");
      }

      // General advice
      _analysisInsights.add("Glikoz yönetimi için düzenli egzersiz ve dengeli beslenme önemlidir.");
      _analysisInsights.add("Tıbbi tavsiye için her zaman doktorunuza başvurunuz.");
    }

    _isAnalyzing = false;
    notifyListeners();
  }

  void resetAnalysis() {
    _analysisInsights = <String>[];
    _currentTrend = null;
    _averageGlucose = null;
    _minGlucose = null;
    _maxGlucose = null;
    _isAnalyzing = false;
    notifyListeners();
  }
}

/// New combined page for Reports and Glucose Analysis using tabs
class RaporlarVeAnalizPage extends StatefulWidget {
  const RaporlarVeAnalizPage({super.key});

  @override
  State<RaporlarVeAnalizPage> createState() => _RaporlarVeAnalizPageState();
}

class _RaporlarVeAnalizPageState extends State<RaporlarVeAnalizPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Raporlar ve Analiz"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Genel Raporlar', icon: Icon(Icons.description)),
            Tab(text: 'Şeker Analizi', icon: Icon(Icons.trending_up)),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          GenelRaporlarView(), // Existing placeholder, can be expanded later
          // SekerAnaliziView no longer needs glucoseHistory as a parameter
          SekerAnaliziView(),
        ],
      ),
    );
  }
}

class GenelRaporlarView extends StatelessWidget {
  const GenelRaporlarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          "Genel sağlık raporlarınız ve diğer veriler burada görüntülenecektir.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class SekerAnaliziView extends StatelessWidget {
  // Removed glucoseHistory from constructor, it will now be fetched directly within SekerAnalizData
  const SekerAnaliziView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SekerAnalizData, CanliDurumData>(
      builder: (BuildContext consumerContext, SekerAnalizData sekerAnalizData, CanliDurumData canliDurumData, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: sekerAnalizData.isAnalyzing
                    ? null
                    : () {
                        // Pass consumerContext to analyzeGlucoseData so it can fetch CanliDurumData
                        sekerAnalizData.analyzeGlucoseData(consumerContext);
                      },
                icon: sekerAnalizData.isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Icon(Icons.analytics_outlined),
                label: Text(sekerAnalizData.isAnalyzing ? 'Veri Analiz Ediliyor...' : 'Glikoz Verilerini Analiz Et'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: GlucoAILogo._kCircuitColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              if (sekerAnalizData.analysisInsights.isNotEmpty || sekerAnalizData.currentTrend != null)
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Genel Glikoz Durumu',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GlucoAILogo._kDropColor),
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                  'Ortalama Glikoz:',
                                  sekerAnalizData.averageGlucose != null
                                      ? '${sekerAnalizData.averageGlucose!.toStringAsFixed(1)} mg/dL'
                                      : 'N/A'),
                              _buildDetailRow(
                                  'Minimum Glikoz:',
                                  sekerAnalizData.minGlucose != null
                                      ? '${sekerAnalizData.minGlucose!.toStringAsFixed(1)} mg/dL'
                                      : 'N/A'),
                              _buildDetailRow(
                                  'Maksimum Glikoz:',
                                  sekerAnalizData.maxGlucose != null
                                      ? '${sekerAnalizData.maxGlucose!.toStringAsFixed(1)} mg/dL'
                                      : 'N/A'),
                              _buildDetailRow('Trend:', sekerAnalizData.currentTrend ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Glucose History Chart (Simple Bar Chart)
                      Text(
                        'Son Okumaların Görseli',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GlucoAILogo._kDropColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      _GlucoseHistoryChart(glucoseHistory: canliDurumData.glucoseHistory),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Yapay Zeka Önerileri ve Analizi',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GlucoAILogo._kDropColor),
                              ),
                              const SizedBox(height: 8),
                              if (sekerAnalizData.analysisInsights.isEmpty && !sekerAnalizData.isAnalyzing)
                                const Text(
                                  'Verilerinizi analiz etmek için "Glikoz Verilerini Analiz Et" butonuna tıklayın.',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                )
                              else if (sekerAnalizData.analysisInsights.isEmpty && sekerAnalizData.isAnalyzing)
                                const Center(
                                  child: CircularProgressIndicator(),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: sekerAnalizData.analysisInsights.map<Widget>((String insight) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.lightbulb_outline, size: 20, color: Theme.of(consumerContext).primaryColor),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              insight,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Expanded(
                  child: Center(
                    child: Text(
                      'Glikoz verilerinizi Bluetooth ile cihazınızdan çekmek ve yapay zeka destekli analizler almak için yukarıdaki butona tıklayın.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis, // FIXED: Added TextOverflow.ellipsis
          ),
          Flexible( // FIXED: Wrapped value in Flexible
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis, // Added TextOverflow.ellipsis
            ),
          ),
        ],
      ),
    );
  }
}

class _GlucoseHistoryChart extends StatelessWidget {
  final List<GlucoseReading> glucoseHistory;

  const _GlucoseHistoryChart({required this.glucoseHistory});

  @override
  Widget build(BuildContext context) {
    if (glucoseHistory.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text('Görüntülenecek geçmiş glikoz verisi yok.'),
        ),
      );
    }

    // Determine min/max values for scaling the bars
    final double maxGlucose = glucoseHistory.map<double>((GlucoseReading r) => r.value).reduce(max);
    final double minGlucose = glucoseHistory.map<double>((GlucoseReading r) => r.value).reduce(min);
    final double range = maxGlucose - minGlucose;
    const double chartHeight = 150.0; // Fixed height for the chart area

    // Calculate fixed height consumed by Text and SizedBoxes within each bar column
    // Approximate line heights for fontSize 10 (14px) and 9 (12px), plus SizedBoxes (4px each)
    const double fixedContentHeight = 14.0 + 4.0 + 4.0 + 12.0; // Sum = 34.0
    // Adjusted availableHeightForBar to account for potential tiny rendering overflows
    final double availableHeightForBar = max(0.0, chartHeight - fixedContentHeight - 1.0); // Subtracted 1.0 pixel
    const double minBarDisplayHeight = 5.0; // Minimum height for the bar to be visible

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: chartHeight, // This SizedBox now provides the exact height for the Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: glucoseHistory.map<Widget>((GlucoseReading reading) {
                final double normalizedValue = range > 0 ? (reading.value - minGlucose) / range : 0.0;
                final double barHeight = max(minBarDisplayHeight, normalizedValue * availableHeightForBar);

                Color barColor;
                if (reading.value < 70) {
                  barColor = Colors.red;
                } else if (reading.value > 180) {
                  barColor = Colors.orange;
                } else {
                  barColor = Colors.green;
                }

                return Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        reading.value.toStringAsFixed(0),
                        style: TextStyle(fontSize: 10, color: barColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity, // FIXED: Changed from fixed 16 to double.infinity
                        height: barHeight, // This is now correctly scaled within the available space
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A common tile widget for settings pages.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // No extra elevation beyond the ListTile's implicit padding/margin
      margin: EdgeInsets.zero, // Remove card margin to allow ListTile to fill
      shape: const RoundedRectangleBorder(), // No rounded corners for list items
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(icon, color: Colors.grey[700]),
            title: Text(title, style: const TextStyle(fontSize: 16)),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  )
                : null,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300], indent: 16, endIndent: 16), // Separator
        ],
      ),
    );
  }
}

// DATA_MODEL for KisiselBilgilerPage (now updated for nullable fields for onboarding)
enum AiModelSensitivity { dusuk, orta, yuksek }
enum AppThemeOption { acik, koyu }

class KisiselBilgilerData extends ChangeNotifier {
  String? _name;
  int? _age;
  double? _heightCm;
  double? _weightKg;
  String? _diabetesType;
  String _deviceConnectionStatus; // Status string, updated externally

  AiModelSensitivity _aiModelSensitivity; // Default value for settings
  bool _isAppLanguageTurkish; // Default value for settings
  AppThemeOption _appTheme; // Default value for settings
  bool _biometricAuthEnabled; // New setting for biometric authentication
  bool _dataSharingConsent; // New setting for KVKK/HIPAA consent

  // Initialize all fields in the initializer list
  KisiselBilgilerData()
      : _name = 'Ayşe Yılmaz',
        _age = 35,
        _heightCm = 165.0,
        _weightKg = 70.0,
        _diabetesType = 'Tip 2 Diyabet',
        _deviceConnectionStatus = 'Bağlı Değil', // Default status for a new user
        _aiModelSensitivity = AiModelSensitivity.orta, // Default settings
        _isAppLanguageTurkish = true,
        _appTheme = AppThemeOption.acik,
        _biometricAuthEnabled = false,
        _dataSharingConsent = false; // Default biometric auth off

  String? get name => _name;
  int? get age => _age;
  double? get heightCm => _heightCm;
  double? get weightKg => _weightKg;
  String? get diabetesType => _diabetesType;
  String get deviceConnectionStatus => _deviceConnectionStatus;

  AiModelSensitivity get aiModelSensitivity => _aiModelSensitivity;
  bool get isAppLanguageTurkish => _isAppLanguageTurkish;
  AppThemeOption get appTheme => _appTheme;
  bool get biometricAuthEnabled => _biometricAuthEnabled;
  bool get dataSharingConsent => _dataSharingConsent;

  String getLocalizedAiModelSensitivity() {
    switch (_aiModelSensitivity) {
      case AiModelSensitivity.dusuk:
        return 'Düşük';
      case AiModelSensitivity.orta:
        return 'Orta';
      case AiModelSensitivity.yuksek:
        return 'Yüksek';
    }
  }

  String getLocalizedAppTheme() {
    switch (_appTheme) {
      case AppThemeOption.acik:
        return 'Açık';
      case AppThemeOption.koyu:
        return 'Koyu';
    }
  }

  // Setters for personal info (used during sign-up/profile edit)
  set name(String? value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  set age(int? value) {
    if (_age != value) {
      _age = value;
      notifyListeners();
    }
  }

  set heightCm(double? value) {
    if (_heightCm != value) {
      _heightCm = value;
      notifyListeners();
    }
  }

  set weightKg(double? value) {
    if (_weightKg != value) {
      _weightKg = value;
      notifyListeners();
    }
  }

  set diabetesType(String? value) {
    if (_diabetesType != value) {
      _diabetesType = value;
      notifyListeners();
    }
  }

  set deviceConnectionStatus(String value) {
    if (_deviceConnectionStatus != value) {
      _deviceConnectionStatus = value;
      notifyListeners();
    }
  }

  // Setters for settings
  set aiModelSensitivity(AiModelSensitivity value) {
    if (_aiModelSensitivity != value) {
      _aiModelSensitivity = value;
      notifyListeners();
    }
  }

  set isAppLanguageTurkish(bool value) {
    if (_isAppLanguageTurkish != value) {
      _isAppLanguageTurkish = value;
      notifyListeners();
    }
  }

  set appTheme(AppThemeOption value) {
    if (_appTheme != value) {
      _appTheme = value;
      notifyListeners();
    }
  }

  set biometricAuthEnabled(bool value) {
    if (_biometricAuthEnabled != value) {
      _biometricAuthEnabled = value;
      notifyListeners();
    }
  }

  set dataSharingConsent(bool value) {
    if (_dataSharingConsent != value) {
      _dataSharingConsent = value;
      notifyListeners();
    }
  }

  // Check if all essential profile information is complete
  bool get isProfileComplete {
    return _name != null &&
        _name!.isNotEmpty &&
        _age != null &&
        _age! > 0 &&
        _heightCm != null &&
        _heightCm! > 0 &&
        _weightKg != null &&
        _weightKg! > 0 &&
        _diabetesType != null &&
        _diabetesType!.isNotEmpty;
  }
}

// New page for user registration/onboarding
class UyelikSayfasi extends StatefulWidget {
  const UyelikSayfasi({super.key});

  @override
  State<UyelikSayfasi> createState() => _UyelikSayfasiState();
}

class _UyelikSayfasiState extends State<UyelikSayfasi> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _diabetesTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing data if available (e.g., if user navigated back)
    final KisiselBilgilerData data = Provider.of<KisiselBilgilerData>(context, listen: false);
    _nameController.text = data.name ?? '';
    _ageController.text = data.age?.toString() ?? '';
    _heightController.text = data.heightCm?.toStringAsFixed(0) ?? '';
    _weightController.text = data.weightKg?.toStringAsFixed(0) ?? '';
    _diabetesTypeController.text = data.diabetesType ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diabetesTypeController.dispose();
    super.dispose();
  }

  void _saveProfileAndConnect() {
    final KisiselBilgilerData data = Provider.of<KisiselBilgilerData>(context, listen: false);

    data.name = _nameController.text.trim();
    data.age = int.tryParse(_ageController.text);
    data.heightCm = double.tryParse(_heightController.text);
    data.weightKg = double.tryParse(_weightController.text);
    data.diabetesType = _diabetesTypeController.text.trim();

    // Validate input
    if (!data.isProfileComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm kişisel bilgileri eksiksiz ve geçerli giriniz.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeNotifierProvider<CihazBaglantiData>(
          create: (BuildContext context) => CihazBaglantiData(),
          builder: (BuildContext context, Widget? child) => const CihazBaglantiPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Üyelik Bilgileri")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Yaş'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Boy (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Kilo (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diabetesTypeController,
              decoration: const InputDecoration(labelText: 'Diyabet Tipi (Örn: Tip 1, Tip 2)'),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveProfileAndConnect,
              icon: const Icon(Icons.save),
              label: const Text('Kaydet ve Cihaz Bağla'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// DATA_MODEL for Device Connection Page
enum ConnectionStatus { idle, connecting, connected, failed }

class CihazBaglantiData extends ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.idle;

  ConnectionStatus get status => _status;

  Future<void> connectDevice(BuildContext context) async {
    _status = ConnectionStatus.connecting;
    notifyListeners();

    try {
      // Simulate connection delay
      await Future<void>.delayed(const Duration(seconds: 3));

      // Simulate success or failure
      final bool success = DateTime.now().second % 2 == 0; // Simple simulation for demo
      if (success) {
        _status = ConnectionStatus.connected;
        // Update the global KisiselBilgilerData with the device connection status
        Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlandı';
      } else {
        _status = ConnectionStatus.failed;
        // Update the global KisiselBilgilerData with the device connection status
        Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlantı Başarısız';
      }
    } catch (e) {
      _status = ConnectionStatus.failed;
      // Update the global KisiselBilgilerData with the device connection status
      Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlantı Hatası';
    } finally {
      notifyListeners();
    }
  }
}

/// New page for simulating device connection
class CihazBaglantiPage extends StatefulWidget {
  const CihazBaglantiPage({super.key});

  @override
  State<CihazBaglantiPage> createState() => _CihazBaglantiPageState();
}

class _CihazBaglantiPageState extends State<CihazBaglantiPage> {
  @override
  void initState() {
    super.initState();
    // Start connection process automatically when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CihazBaglantiData>(context, listen: false).connectDevice(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cihaz Bağlantısı")),
      body: Consumer<CihazBaglantiData>(
        builder: (BuildContext context, CihazBaglantiData data, Widget? child) {
          String message;
          IconData icon;
          Color color;
          bool showProgress = false;
          bool showActionButton = false;
          VoidCallback? action;
          String actionText = '';

          switch (data.status) {
            case ConnectionStatus.idle:
              message = 'Cihaz bağlantısı bekleniyor...';
              icon = Icons.bluetooth_searching;
              color = Colors.grey;
              showProgress = false;
              showActionButton = true;
              action = () => data.connectDevice(context);
              actionText = 'Tekrar Dene';
              break;
            case ConnectionStatus.connecting:
              message = 'Cihaz aranıyor ve bağlanıyor...';
              icon = Icons.bluetooth_connected;
              color = GlucoAILogo._kCircuitColor;
              showProgress = true;
              showActionButton = false; // Disable button while connecting
              break;
            case ConnectionStatus.connected:
              message = 'Cihaz başarıyla bağlandı!';
              icon = Icons.bluetooth;
              color = Colors.green;
              showProgress = false;
              showActionButton = true;
              action = () {
                // Navigate to AnaMenu upon successful connection.
                // CanliDurumData and SekerAnalizData are now provided at MyApp level, so no need to provide them here.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AnaMenu(),
                  ),
                );
              };
              actionText = 'Ana Menüye Git';
              break;
            case ConnectionStatus.failed:
              message = 'Cihaz bağlantısı başarısız oldu. Lütfen tekrar deneyin.';
              icon = Icons.bluetooth_disabled;
              color = Colors.red;
              showProgress = false;
              showActionButton = true;
              action = () => data.connectDevice(context);
              actionText = 'Tekrar Dene';
              break;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 100, color: color),
                  const SizedBox(height: 20),
                  if (showProgress)
                    const Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                      ],
                    ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  if (showActionButton)
                    ElevatedButton(
                      onPressed: action,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(actionText),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Placeholder Pages for Settings
class KisiselBilgilerPage extends StatefulWidget {
  const KisiselBilgilerPage({super.key});

  @override
  State<KisiselBilgilerPage> createState() => _KisiselBilgilerPageState();
}

class _KisiselBilgilerPageState extends State<KisiselBilgilerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _diabetesTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate controllers from the data model
    final KisiselBilgilerData data = Provider.of<KisiselBilgilerData>(context, listen: false);
    _nameController.text = data.name ?? '';
    _ageController.text = data.age?.toString() ?? '';
    _heightController.text = data.heightCm?.toStringAsFixed(0) ?? '';
    _weightController.text = data.weightKg?.toStringAsFixed(0) ?? '';
    _diabetesTypeController.text = data.diabetesType ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diabetesTypeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final KisiselBilgilerData data = Provider.of<KisiselBilgilerData>(context, listen: false);

    data.name = _nameController.text.trim();
    data.age = int.tryParse(_ageController.text);
    data.heightCm = double.tryParse(_heightController.text);
    data.weightKg = double.tryParse(_weightController.text);
    data.diabetesType = _diabetesTypeController.text.trim();

    // Basic validation
    if (!data.isProfileComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm kişisel bilgileri eksiksiz ve geçerli giriniz.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kişisel bilgiler başarıyla güncellendi.')),
    );
  }

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kişisel Bilgiler")),
      body: Consumer<KisiselBilgilerData>(
        builder: (BuildContext consumerContext, KisiselBilgilerData data, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // "Ad" title and "Profil & Kişiselleştirme" section title
                const Text(
                  'Ad',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Profil & Kişiselleştirme',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: GlucoAILogo._kTextColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Editable personal information fields
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Yaş'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Boy (cm)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Kilo (kg)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _diabetesTypeController,
                  decoration: const InputDecoration(labelText: 'Diyabet Tipi (Örn: Tip 1, Tip 2)'),
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text('Değişiklikleri Kaydet'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: GlucoAILogo._kCircuitColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Fixed device connection status display
                _ProfileDetailRow(label: 'Cihaz bağlantı durumu', value: data.deviceConnectionStatus),
                const Divider(height: 1, thickness: 0.5, color: Colors.grey),
                const SizedBox(height: 24), // Add spacing after device status

                // Application Language & Theme Section Header
                const Text(
                  'Uygulama dili & tema',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GlucoAILogo._kTextColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Application Language
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Uygulama dili',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Switch(
                      value: data.isAppLanguageTurkish,
                      onChanged: (bool value) {
                        data.isAppLanguageTurkish = value;
                      },
                      activeColor: Theme.of(consumerContext).primaryColor,
                    ),
                  ],
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.grey),

                // AI Model Settings
                _ProfileActionRow(
                  label: 'AI model ayarları (hassasiyet seviyesi)',
                  value: data.getLocalizedAiModelSensitivity(),
                  onTap: () => navigateTo(consumerContext, const AiModelAyarlariPage()),
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.grey),

                // Theme
                _ProfileActionRow(
                  label: 'Tema',
                  value: data.getLocalizedAppTheme(),
                  onTap: () => navigateTo(consumerContext, const TemaAyarlariPage()),
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis, // FIXED: Added TextOverflow.ellipsis
          ),
          Flexible( // FIXED: Wrapped value in Flexible
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis, // Added TextOverflow.ellipsis
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ProfileActionRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded( // FIXED: The label should take precedence in space allocation, wrap with Expanded
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                overflow: TextOverflow.ellipsis, // Ensure label doesn't overflow
              ),
            ),
            const SizedBox(width: 8), // Space between label and value/icon
            Row( // This Row contains value and icon, should take minimum space
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible( // FIXED: Value text can still be long, make it flexible
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                  ),
                ),
                if (onTap != null) const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AiModelAyarlariPage extends StatelessWidget {
  const AiModelAyarlariPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Model Ayarları")),
      body: Consumer<KisiselBilgilerData>(
        builder: (BuildContext consumerContext, KisiselBilgilerData data, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Yapay Zeka Model Hassasiyeti',
                  style: Theme.of(consumerContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                RadioListTile<AiModelSensitivity>(
                  title: const Text('Düşük (Daha az agresif öneriler)'),
                  value: AiModelSensitivity.dusuk,
                  groupValue: data.aiModelSensitivity,
                  onChanged: (AiModelSensitivity? value) {
                    if (value != null) {
                      data.aiModelSensitivity = value;
                    }
                  },
                ),
                RadioListTile<AiModelSensitivity>(
                  title: const Text('Orta (Dengeli öneriler)'),
                  value: AiModelSensitivity.orta,
                  groupValue: data.aiModelSensitivity,
                  onChanged: (AiModelSensitivity? value) {
                    if (value != null) {
                      data.aiModelSensitivity = value;
                    }
                  },
                ),
                RadioListTile<AiModelSensitivity>(
                  title: const Text('Yüksek (Daha proaktif öneriler)'),
                  value: AiModelSensitivity.yuksek,
                  groupValue: data.aiModelSensitivity,
                  onChanged: (AiModelSensitivity? value) {
                    if (value != null) {
                      data.aiModelSensitivity = value;
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Bu ayar, yapay zeka modelinin size sunacağı önerilerin hassasiyetini ve proaktifliğini belirler.',
                  style: Theme.of(consumerContext).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TemaAyarlariPage extends StatelessWidget {
  const TemaAyarlariPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tema Ayarları")),
      body: Consumer<KisiselBilgilerData>(
        builder: (BuildContext consumerContext, KisiselBilgilerData data, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Uygulama Teması',
                  style: Theme.of(consumerContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                RadioListTile<AppThemeOption>(
                  title: const Text('Açık Tema'),
                  value: AppThemeOption.acik,
                  groupValue: data.appTheme,
                  onChanged: (AppThemeOption? value) {
                    if (value != null) {
                      data.appTheme = value;
                    }
                  },
                ),
                RadioListTile<AppThemeOption>(
                  title: const Text('Koyu Tema'),
                  value: AppThemeOption.koyu,
                  groupValue: data.appTheme,
                  onChanged: (AppThemeOption? value) {
                    if (value != null) {
                      data.appTheme = value;
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Uygulamanın görsel temasını buradan değiştirebilirsiniz.',
                  style: Theme.of(consumerContext).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// DATA_MODEL for BildirimAyarlariPage
class BildirimAyarlariData extends ChangeNotifier {
  bool _glucoseAlertsEnabled;
  bool _medicationRemindersEnabled;
  bool _mealRemindersEnabled;
  bool _exerciseRemindersEnabled;

  BildirimAyarlariData()
      : _glucoseAlertsEnabled = true,
        _medicationRemindersEnabled = true,
        _mealRemindersEnabled = false,
        _exerciseRemindersEnabled = false;

  bool get glucoseAlertsEnabled => _glucoseAlertsEnabled;
  bool get medicationRemindersEnabled => _medicationRemindersEnabled;
  bool get mealRemindersEnabled => _mealRemindersEnabled;
  bool get exerciseRemindersEnabled => _exerciseRemindersEnabled;

  set glucoseAlertsEnabled(bool value) {
    if (_glucoseAlertsEnabled != value) {
      _glucoseAlertsEnabled = value;
      notifyListeners();
    }
  }

  set medicationRemindersEnabled(bool value) {
    if (_medicationRemindersEnabled != value) {
      _medicationRemindersEnabled = value;
      notifyListeners();
    }
  }

  set mealRemindersEnabled(bool value) {
    if (_mealRemindersEnabled != value) {
      _mealRemindersEnabled = value;
      notifyListeners();
    }
  }

  set exerciseRemindersEnabled(bool value) {
    if (_exerciseRemindersEnabled != value) {
      _exerciseRemindersEnabled = value;
      notifyListeners();
    }
  }
}

class BildirimAyarlariPage extends StatelessWidget {
  const BildirimAyarlariPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bildirim Ayarları")),
      body: Consumer<BildirimAyarlariData>(
        builder: (BuildContext consumerContext, BildirimAyarlariData data, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Text(
                'Bildirim Tercihleri',
                style: Theme.of(consumerContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Glikoz Seviyesi Uyarıları'),
                subtitle: const Text('Yüksek veya düşük glikoz seviyesi durumunda bildirim al.'),
                value: data.glucoseAlertsEnabled,
                onChanged: (bool value) => data.glucoseAlertsEnabled = value,
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              SwitchListTile(
                title: const Text('İlaç Hatırlatıcıları'),
                subtitle: const Text('İlaçlarınızı alma zamanı geldiğinde bildirim al.'),
                value: data.medicationRemindersEnabled,
                onChanged: (bool value) => data.medicationRemindersEnabled = value,
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              SwitchListTile(
                title: const Text('Yemek Hatırlatıcıları'),
                subtitle: const Text('Öğün zamanları için bildirim al.'),
                value: data.mealRemindersEnabled,
                onChanged: (bool value) => data.mealRemindersEnabled = value,
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              SwitchListTile(
                title: const Text('Egzersiz Hatırlatıcıları'),
                subtitle: const Text('Egzersiz yapma zamanı geldiğinde bildirim al.'),
                value: data.exerciseRemindersEnabled,
                onChanged: (bool value) => data.exerciseRemindersEnabled = value,
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Bildirim ayarlarınızı buradan kişiselleştirebilirsiniz.',
                style: Theme.of(consumerContext).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class VeriGizliligiVeGuvenlikPage extends StatelessWidget {
  const VeriGizliligiVeGuvenlikPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veri Gizliliği ve Güvenlik")),
      body: Consumer<KisiselBilgilerData>(
        builder: (BuildContext consumerContext, KisiselBilgilerData data, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Text(
                'Hesap Güvenliği',
                style: Theme.of(consumerContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Şifreyi Değiştir'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    const SnackBar(content: Text('Şifre değiştirme ekranı açıldı (Simülasyon).')),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Biyometrik Kimlik Doğrulama'),
                subtitle: const Text('Parmak izi veya yüz tanıma ile giriş yap.'),
                value: data.biometricAuthEnabled,
                onChanged: (bool value) {
                  data.biometricAuthEnabled = value;
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Biyometrik Kimlik Doğrulama ${value ? 'açıldı' : 'kapatıldı'} (Simülasyon).')),
                  );
                },
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              const Divider(),
              Text(
                'Veri Gizliliği',
                style: Theme.of(consumerContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Uygulama Verilerini Yedekle'),
                subtitle: const Text('Verilerinizi buluta yedekleyin.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    const SnackBar(content: Text('Veri yedekleme işlemi başlatıldı (Simülasyon).')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_for_offline_outlined),
                title: const Text('Verilerimi İndir'),
                subtitle: const Text('Tüm kişisel verilerinizin bir kopyasını indirin.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    const SnackBar(content: Text('Veri indirme linki e-postanıza gönderildi (Simülasyon).')),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Hesabınızın ve verilerinizin güvenliğini sağlamak için ayarlarınızı düzenleyin.',
                style: Theme.of(consumerContext).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class KVKKHIPAAPage extends StatelessWidget {
  const KVKKHIPAAPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KVKK / HIPAA İzinleri")),
      body: Consumer<KisiselBilgilerData>(
        builder: (BuildContext consumerContext, KisiselBilgilerData data, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              const Icon(Icons.policy_outlined, size: 60, color: GlucoAILogo._kDropColor),
              const SizedBox(height: 20),
              Text(
                'Veri Gizliliği ve Yasal İzinler',
                style: Theme.of(consumerContext).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Sağlık verilerinizin güvenliği ve gizliliği bizim için en önemli önceliktir. Aşağıdaki ayarlar ile kişisel verilerinizin kullanımına ve paylaşımına ilişkin izinlerinizi yönetebilirsiniz.',
                style: Theme.of(consumerContext).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Sağlık Verisi Paylaşım İzni'),
                subtitle: const Text('Anonimleştirilmiş verilerinizin araştırma ve uygulama geliştirme amaçlı kullanılmasına izin verin.'),
                value: data.dataSharingConsent,
                onChanged: (bool value) {
                  data.dataSharingConsent = value;
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    SnackBar(
                        content: Text('Veri paylaşım izni ${value ? 'açıldı' : 'kapatıldı'}.')),
                  );
                },
                activeColor: Theme.of(consumerContext).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Bu izinler, KVKK (Kişisel Verilerin Korunması Kanunu) ve HIPAA (Health Insurance Portability and Accountability Act) standartlarına uygun olarak yönetilmektedir. Detaylı bilgi için gizlilik politikamızı inceleyiniz.',
                style: Theme.of(consumerContext).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar(
                    const SnackBar(content: Text('Gizlilik politikası görüntülendi (Simülasyon).')),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Gizlilik Politikasını Görüntüle'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: GlucoAILogo._kCircuitColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HakkindaSurumBilgisiPage extends StatelessWidget {
  const HakkindaSurumBilgisiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hakkında / Sürüm Bilgisi")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const GlucoAILogo(iconSize: 60.0, fontSize: 36.0),
              const SizedBox(height: 30),
              Text(
                'Uygulama Adı: GlucoAI',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Sürüm: 1.0.0',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Derleme Numarası: 12345',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bu uygulama, diyabet yönetimi ve sağlıklı yaşam için yapay zeka destekli çözümler sunmaktadır.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lisans bilgileri görüntülendi (Simülasyon).')),
                  );
                },
                icon: const Icon(Icons.book_outlined),
                label: const Text('Lisans Bilgileri ve Teşekkürler'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: GlucoAILogo._kCircuitColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SSSPage extends StatelessWidget {
  const SSSPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = <Map<String, String>>[
      <String, String>{
        'question': 'Uygulama nasıl çalışır?',
        'answer':
            'Uygulama, Bluetooth bağlantısı üzerinden uyumlu glikoz ölçüm cihazlarından verileri alır, bu verileri yapay zeka algoritmaları ile analiz eder ve size kişiselleştirilmiş beslenme, egzersiz ve ilaç takip önerileri sunar. Ayrıca doktorunuzla veri paylaşımı, acil durum desteği ve psikolojik motivasyon gibi özellikler de sağlar.'
      },
      <String, String>{
        'question': 'Hangi cihazlarla uyumludur?',
        'answer': 'Şu anda sadece X marka Bluetooth destekli glikoz ölçüm cihazları ile uyumludur. Gelecekte daha fazla cihaz desteği eklenecektir.'
      },
      <String, String>{
        'question': 'Yapay zeka önerileri ne kadar güvenilir?',
        'answer':
            'Yapay zeka önerileri, en güncel tıbbi kılavuzlar ve bilimsel veriler ışığında geliştirilmiştir. Ancak, unutmayın ki bunlar sadece öneridir. Her zaman doktorunuza danışmalı ve tıbbi teşhis veya tedavi için bir sağlık profesyoneline başvurmalısınız.'
      },
      <String, String>{
        'question': 'Verilerim güvende mi?',
        'answer':
            'Evet, kişisel ve sağlık verileriniz en yüksek güvenlik standartları ile korunmaktadır. Tüm veriler şifrelenmiş olarak saklanır ve KVKK/HIPAA gibi uluslararası veri gizliliği yasalarına uygun hareket edilir. Detaylı bilgi için gizlilik politikamızı inceleyebilirsiniz.'
      },
      <String, String>{
        'question': 'Uygulamayı kullanmak ücretli mi?',
        'answer': 'Uygulamanın temel özellikleri ücretsizdir. Bazı gelişmiş özellikler ve kişiselleştirilmiş danışmanlık hizmetleri için premium abonelik seçenekleri sunulmaktadır.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("SSS (Sıkça Sorulan Sorular)")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> faq = faqs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ExpansionTile(
              leading: Icon(Icons.question_answer_outlined, color: Theme.of(context).primaryColor),
              title: Text(
                faq['question']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CanliDestekPage extends StatelessWidget {
  const CanliDestekPage({super.key});

  Future<void> _launchEmail(BuildContext context) async { // Added context parameter
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@glucoai.com',
      queryParameters: <String, String>{
        'subject': 'GlucoAI Uygulaması Destek Talebi',
        'body': 'Lütfen sorununuzu detaylıca açıklayınız:',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'E-posta uygulaması bulunamadı. Lütfen manuel olarak support@glucoai.com adresine mail atınız.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( // Using provided context
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canlı Destek")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(Icons.support_agent_outlined, size: 80, color: GlucoAILogo._kDropColor),
            const SizedBox(height: 20),
            Text(
              'Size Yardımcı Olmaktan Mutluluk Duyarız!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Her türlü sorunuz, geri bildiriminiz veya teknik destek ihtiyacınız için aşağıdaki yöntemleri kullanabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Canlı sohbet başlatılıyor... (Simülasyon)')),
                );
              },
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Canlı Sohbet Başlat'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchEmail(context), // Pass context here
              icon: const Icon(Icons.email_outlined),
              label: const Text('E-posta Gönder'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey[200],
                foregroundColor: GlucoAILogo._kTextColor,
                elevation: 0,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Telefon: +90 123 456 78 90 (Hafta içi 09:00 - 18:00)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class KullanimRehberiVideolariPage extends StatelessWidget {
  const KullanimRehberiVideolariPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = <Map<String, String>>[
      <String, String>{
        'title': 'Cihaz Bağlantısı Nasıl Yapılır?',
        'url': 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        'description': 'Glikoz ölçüm cihazınızı uygulamaya bağlama adımları.',
      },
      <String, String>{
        'title': 'Beslenme Planı Oluşturma Rehberi',
        'url': 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        'description': 'Yapay zeka destekli beslenme planınızı nasıl oluşturacağınızı öğrenin.',
      },
      <String, String>{
        'title': 'Glikoz Verileri Nasıl Analiz Edilir?',
        'url': 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        'description': 'Kan şekeri trendlerinizi anlama ve yorumlama.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Kullanım Rehberi Videoları")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: videos.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> video = videos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  video['url']!,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                  },
                ),
              ),
              title: Text(
                video['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                video['description']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: Icon(Icons.play_circle_fill, color: Theme.of(context).primaryColor, size: 30),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${video['title']} oynatılıyor (Simülasyon).')),
                );
                // In a real app, you would launch a video player or YouTube link
                // launchUrl(Uri.parse(video['url']!));
              },
            ),
          );
        },
      ),
    );
  }
}

class GeriBildirimGonderPage extends StatefulWidget {
  const GeriBildirimGonderPage({super.key});

  @override
  State<GeriBildirimGonderPage> createState() => _GeriBildirimGonderPageState();
}

class _GeriBildirimGonderPageState extends State<GeriBildirimGonderPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geri bildiriminizi yazınız.')),
      );
      return;
    }

    // Simulate sending feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Geri bildiriminiz başarıyla gönderildi! Teşekkür ederiz. Geri Bildirim: "${_feedbackController.text.trim()}"')),
    );
    _feedbackController.clear();
    _emailController.clear();
    // Optionally, navigate back or show a success message then navigate back
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geri Bildirim Gönder")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(Icons.feedback_outlined, size: 80, color: GlucoAILogo._kDropColor),
            const SizedBox(height: 20),
            Text(
              'Görüşleriniz Bizim İçin Değerli!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Uygulamamızı geliştirmemize yardımcı olmak için görüşlerinizi, önerilerinizi veya karşılaştığınız hataları bizimle paylaşabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Geri Bildiriminiz',
                hintText: 'Uygulamayı nasıl geliştirebiliriz?',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta Adresiniz (İsteğe Bağlı)',
                hintText: 'Size geri dönüş yapabilmemiz için',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _sendFeedback,
              icon: const Icon(Icons.send),
              label: const Text('Geri Bildirimi Gönder'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for MotivasyonPage
class MotivasyonData extends ChangeNotifier {
  final List<String> _quotes = <String>[
    "Unutma, her küçük adım hedefine giden yoldadır.",
    "Bugün en iyi halin ol. Kendine inan!",
    "Diyabet yönetiminde kararlılığın en büyük gücün.",
    "Kendine iyi bakmak, en büyük zaferindir.",
    "Sağlıklı seçimler, mutlu bir yaşamın anahtarıdır.",
    "Her yeni gün, yeni bir başlangıçtır.",
    "İyileşmek bir yolculuktur, sabırla devam et.",
  ];
  final List<String> _moods = <String>['Harika', 'İyi', 'Normal', 'Kötü', 'Çok Kötü'];
  final List<Map<String, String>> _moodHistory;

  MotivasyonData()
      : _moodHistory = <Map<String, String>>[
          <String, String>{'mood': 'İyi', 'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)).toIso8601String()},
          <String, String>{'mood': 'Normal', 'timestamp': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String()},
        ];

  String get currentQuote => _quotes[Random().nextInt(_quotes.length)];
  List<String> get moods => _moods;
  List<Map<String, String>> get moodHistory => _moodHistory;

  void addMood(String mood) {
    _moodHistory.add(<String, String>{'mood': mood, 'timestamp': DateTime.now().toIso8601String()});
    notifyListeners();
  }
}

class MotivasyonPage extends StatelessWidget {
  const MotivasyonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Psikolojik Destek ve Motivasyon")),
      body: Consumer<MotivasyonData>(
        builder: (BuildContext consumerContext, MotivasyonData data, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        const Icon(Icons.self_improvement, size: 60, color: GlucoAILogo._kDropColor),
                        const SizedBox(height: 16),
                        Text(
                          'Günün Motivasyon Sözü:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.currentQuote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bugünkü Ruh Haliniz:',
                  style: Theme.of(consumerContext).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Ruh Halinizi Seçin',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  items: data.moods.map<DropdownMenuItem<String>>((String mood) {
                    return DropdownMenuItem<String>(
                      value: mood,
                      child: Text(mood),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      data.addMood(value);
                      ScaffoldMessenger.of(consumerContext).showSnackBar(
                        SnackBar(content: Text('Ruh haliniz kaydedildi: $value')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Geçmiş Ruh Halleri:',
                  style: Theme.of(consumerContext).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: data.moodHistory.isEmpty
                      ? const Center(
                          child: Text(
                            'Henüz ruh hali kaydı yapmadınız.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.moodHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, String> entry =
                                data.moodHistory[data.moodHistory.length - 1 - index]; // Reverse order
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                leading: Icon(Icons.mood, color: Theme.of(consumerContext).primaryColor),
                                title: Text('Ruh Hali: ${entry['mood']}'),
                                subtitle: Text('Tarih: ${DateTime.parse(entry['timestamp']!)
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16)}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// DATA_MODEL for IlacTakipPage
class IlacKaydi {
  final String ilacAdi;
  final String dozaj;
  final DateTime zaman;

  IlacKaydi({required this.ilacAdi, required this.dozaj, required this.zaman});
}

class IlacTakipData extends ChangeNotifier {
  final List<IlacKaydi> _ilacGecmisi;

  IlacTakipData()
      : _ilacGecmisi = <IlacKaydi>[
          IlacKaydi(ilacAdi: 'İnsülin Glargin', dozaj: '12 ünite', zaman: DateTime.now().subtract(const Duration(days: 2, hours: 8))),
          IlacKaydi(ilacAdi: 'Metformin', dozaj: '500 mg', zaman: DateTime.now().subtract(const Duration(days: 1, hours: 14))),
          IlacKaydi(ilacAdi: 'İnsülin Aspart', dozaj: '8 ünite', zaman: DateTime.now().subtract(const Duration(hours: 2))),
        ];

  List<IlacKaydi> get ilacGecmisi => _ilacGecmisi;

  void ilacEkle(String ilacAdi, String dozaj) {
    if (ilacAdi.isNotEmpty && dozaj.isNotEmpty) {
      _ilacGecmisi.add(IlacKaydi(ilacAdi: ilacAdi, dozaj: dozaj, zaman: DateTime.now()));
      notifyListeners();
    }
  }
}

class IlacTakipPage extends StatefulWidget {
  const IlacTakipPage({super.key});

  @override
  State<IlacTakipPage> createState() => _IlacTakipPageState();
}

class _IlacTakipPageState extends State<IlacTakipPage> {
  final TextEditingController _ilacAdiController = TextEditingController();
  final TextEditingController _dozajController = TextEditingController();

  @override
  void dispose() {
    _ilacAdiController.dispose();
    _dozajController.dispose();
    super.dispose();
  }

  void _ilacKaydet() {
    final IlacTakipData data = Provider.of<IlacTakipData>(context, listen: false);
    data.ilacEkle(_ilacAdiController.text.trim(), _dozajController.text.trim());
    _ilacAdiController.clear();
    _dozajController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İlaç kaydı başarıyla eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlaç Takip Modülü")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _ilacAdiController,
              decoration: const InputDecoration(labelText: 'İlaç Adı'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dozajController,
              decoration: const InputDecoration(labelText: 'Dozaj (örn: 10 ünite, 500 mg)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _ilacKaydet,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the content of the button
                children: <Widget>[
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 8), // Spacing between icon and text
                  Text('Sonuç Kaydet'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'İlaç Kullanım Geçmişi:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<IlacTakipData>(
                builder: (BuildContext context, IlacTakipData data, Widget? child) {
                  return data.ilacGecmisi.isEmpty
                      ? const Center(
                          child: Text(
                            'Henüz ilaç kaydı bulunmamaktadır.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.ilacGecmisi.length,
                          itemBuilder: (BuildContext context, int index) {
                            final IlacKaydi kayit = data.ilacGecmisi[data.ilacGecmisi.length - 1 - index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                leading: Icon(Icons.receipt_long, color: Theme.of(context).primaryColor),
                                title: Text('${kayit.ilacAdi} - ${kayit.dozaj}'),
                                subtitle: Text(
                                    'Zaman: ${kayit.zaman.hour}:${kayit.zaman.minute.toString().padLeft(2, '0')} - ${kayit.zaman.day}/${kayit.zaman.month}/${kayit.zaman.year}'),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for LabSonuclariPage
class LabSonucu {
  final String testAdi;
  final String deger;
  final String birim;
  final DateTime tarih;

  LabSonucu({required this.testAdi, required this.deger, required this.birim, required this.tarih});
}

class LabSonuclariData extends ChangeNotifier {
  final List<LabSonucu> _sonuclar;

  LabSonuclariData()
      : _sonuclar = <LabSonucu>[
          LabSonucu(testAdi: 'HbA1c', deger: '6.8', birim: '%', tarih: DateTime.now().subtract(const Duration(days: 90))),
          LabSonucu(testAdi: 'Açlık Kan Şekeri', deger: '125', birim: 'mg/dL', tarih: DateTime.now().subtract(const Duration(days: 30))),
          LabSonucu(testAdi: 'Kolesterol (Toplam)', deger: '180', birim: 'mg/dL', tarih: DateTime.now().subtract(const Duration(days: 15))),
        ];

  List<LabSonucu> get sonuclar => _sonuclar;

  void sonucEkle(String testAdi, String deger, String birim) {
    if (testAdi.isNotEmpty && deger.isNotEmpty && birim.isNotEmpty) {
      _sonuclar.add(LabSonucu(testAdi: testAdi, deger: deger, birim: birim, tarih: DateTime.now()));
      notifyListeners();
    }
  }
}

class LabSonuclariPage extends StatefulWidget {
  const LabSonuclariPage({super.key});

  @override
  State<LabSonuclariPage> createState() => _LabSonuclariPageState();
}

class _LabSonuclariPageState extends State<LabSonuclariPage> {
  final TextEditingController _testAdiController = TextEditingController();
  final TextEditingController _degerController = TextEditingController();
  final TextEditingController _birimController = TextEditingController();

  @override
  void dispose() {
    _testAdiController.dispose();
    _degerController.dispose();
    _birimController.dispose();
    super.dispose();
  }

  void _sonucKaydet() {
    final LabSonuclariData data = Provider.of<LabSonuclariData>(context, listen: false);
    data.sonucEkle(_testAdiController.text.trim(), _degerController.text.trim(), _birimController.text.trim());
    _testAdiController.clear();
    _degerController.clear();
    _birimController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Laboratuvar sonucu başarıyla eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laboratuvar Sonuçları ve Sağlık Kayıtları")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _testAdiController,
              decoration: const InputDecoration(labelText: 'Test Adı (örn: HbA1c, Kolesterol, Tansiyon)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _degerController,
              decoration: const InputDecoration(labelText: 'Değer'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _birimController,
              decoration: const InputDecoration(labelText: 'Birim (örn: %, mg/dL, mmHg)'),
            ),
            const SizedBox(height: 24),
            // Modified ElevatedButton to center icon and text
            ElevatedButton(
              onPressed: _sonucKaydet,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: GlucoAILogo._kCircuitColor,
                foregroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the content of the button
                children: <Widget>[
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 8), // Spacing between icon and text
                  Text('Sonuç Kaydet'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Geçmiş Laboratuvar Sonuçları:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<LabSonuclariData>(
                builder: (BuildContext context, LabSonuclariData data, Widget? child) {
                  return data.sonuclar.isEmpty
                      ? const Center(
                          child: Text(
                            'Henüz laboratuvar sonucu kaydı bulunmamaktadır.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.sonuclar.length,
                          itemBuilder: (BuildContext context, int index) {
                            final LabSonucu sonuc = data.sonuclar[data.sonuclar.length - 1 - index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                leading: Icon(Icons.medical_information_outlined, color: Theme.of(context).primaryColor),
                                title: Text('${sonuc.testAdi}: ${sonuc.deger} ${sonuc.birim}'),
                                subtitle: Text('Tarih: ${sonuc.tarih.day}/${sonuc.tarih.month}/${sonuc.tarih.year}'),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DATA_MODEL for AcilDurumPage
class AcilDurumData extends ChangeNotifier {
  String _emergencyContactName;
  String _emergencyContactPhone;
  String _medicalConditionNote;

  AcilDurumData()
      : _emergencyContactName = "Mehmet Yılmaz",
        _emergencyContactPhone = "55555555555",
        _medicalConditionNote = "Tip 2 Diyabet, İnsülin kullanıyor, Alerji: Penisilin";

  String get emergencyContactName => _emergencyContactName;
  String get emergencyContactPhone => _emergencyContactPhone;
  String get medicalConditionNote => _medicalConditionNote;

  void updateEmergencyInfo({String? name, String? phone, String? note}) {
    if (name != null) _emergencyContactName = name;
    if (phone != null) _emergencyContactPhone = phone;
    if (note != null) _medicalConditionNote = note;
    notifyListeners();
  }
}

class AcilDurumPage extends StatelessWidget {
  const AcilDurumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AcilDurumData data = Provider.of<AcilDurumData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Acil Durum Modülü")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(Icons.warning_amber_outlined, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Acil Durum Bilgileri',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Acil Durum Kişisi:', data.emergencyContactName),
                    _buildDetailRow('Telefon Numarası:', data.emergencyContactPhone),
                    _buildDetailRow('Tıbbi Notlar:', data.medicalConditionNote),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Simulate opening a form to edit
                        _showEditEmergencyInfoDialog(context, data);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Bilgileri Düzenle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlucoAILogo._kCircuitColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Acil durum SMS\'i gönderildi (Simülasyon).')),
                );
              },
              icon: const Icon(Icons.sms_outlined),
              label: const Text('Acil Durum SMS\'i Gönder'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('En yakın hastaneler harita üzerinde gösterildi (Simülasyon).')),
                );
              },
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('En Yakın Sağlık Kuruluşunu Bul'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Önemli Bilgi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Hipoglisemi veya Hiperglisemi gibi acil durumlarda bu modül hayati önem taşır. Lütfen acil durum bilgilerinizi güncel tutunuz ve sevdiklerinizi bilgilendiriniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis, // FIXED: Added TextOverflow.ellipsis
          ),
          Flexible( // FIXED: Wrapped value in Flexible
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis, // Added TextOverflow.ellipsis
            ),
          ),
        ],
      ),
    );
  }

  void _showEditEmergencyInfoDialog(BuildContext context, AcilDurumData data) {
    final TextEditingController nameController = TextEditingController(text: data.emergencyContactName);
    final TextEditingController phoneController = TextEditingController(text: data.emergencyContactPhone);
    final TextEditingController noteController = TextEditingController(text: data.medicalConditionNote);

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Acil Durum Bilgilerini Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Acil Durum Kişisi Adı'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon Numarası'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Tıbbi Notlar (Alerjiler, özel durumlar)'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                data.updateEmergencyInfo(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  note: noteController.text.trim(),
                );
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Acil durum bilgileri güncellendi.')),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}

// Updated AyarlarPage based on the image and requirements
class AyarlarPage extends StatelessWidget {
  const AyarlarPage({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: <Widget>[
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Kişisel Bilgiler',
            subtitle: 'Profil bilgilerinizi düzenleyin',
            onTap: () => navigateTo(
              context,
              const KisiselBilgilerPage(), // KisiselBilgilerData is now provided at root
            ),
          ),
          SettingsTile(
            icon: Icons.notifications_none,
            title: 'Bildirim ayarları',
            onTap: () => navigateTo(context, const BildirimAyarlariPage()),
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Veri gizliliği ve güvenlik',
            subtitle: 'Şifre değiştir, biyometrik giriş',
            onTap: () => navigateTo(context, const VeriGizliligiVeGuvenlikPage()),
          ),
          SettingsTile(
            icon: Icons.article_outlined, // Changed from All icon to article
            title: 'KVKK / HIPAA izinleri',
            onTap: () => navigateTo(context, const KVKKHIPAAPage()),
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'Hakkında / Sürüm bilgisi',
            onTap: () => navigateTo(context, const HakkindaSurumBilgisiPage()),
          ),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'SSS (Sıkça Sorulan Sorular)',
            onTap: () => navigateTo(context, const SSSPage()),
          ),
          SettingsTile(
            icon: Icons.chat_bubble_outline,
            title: 'Canlı destek',
            subtitle: '(sohbet / e-posta)',
            onTap: () => navigateTo(context, const CanliDestekPage()),
          ),
          SettingsTile(
            icon: Icons.play_circle_outline,
            title: 'Kullanım rehberi videoları',
            onTap: () => navigateTo(context, const KullanimRehberiVideolariPage()),
          ),
          SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Geri bildirim gönder',
            onTap: () => navigateTo(context, const GeriBildirimGonderPage()),
          ),
        ],
      ),
    );
  }
}
