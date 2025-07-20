
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; 
import 'dart:math'; 

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
        ChangeNotifierProvider<SaglikVerileriData>( 
            create: (BuildContext context) => SaglikVerileriData()),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Sağlık Uygulaması',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFBF9F2), 
              foregroundColor: Colors.black, 
              elevation: 1, 
              centerTitle: true, 
            ),
            scaffoldBackgroundColor: const Color(0xFFFBF9F2),
            inputDecorationTheme: InputDecorationTheme( 
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
          home: const GirisSayfasi(), 
        );
      },
    );
  }
}

class _GlucoAIIconPainter extends CustomPainter {
  final Color dropColor;
  final Color circuitColor;

  _GlucoAIIconPainter({required this.dropColor, required this.circuitColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double minDim = size.shortestSide;
    final double width = size.width;
    final double height = size.height;

    final Paint outerCirclePaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDim * 0.05;

    final Paint dropPaint = Paint()
      ..color = dropColor
      ..style = PaintingStyle.fill;

    final Paint circuitPaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDim * 0.02;
    final Paint circuitDotPaint = Paint()
      ..color = circuitColor
      ..style = PaintingStyle.fill;

    final double outerCircleRadius = minDim / 2 - outerCirclePaint.strokeWidth / 2;
    final Offset outerCircleCenter = Offset(width / 2, height / 2);

  
    canvas.drawCircle(outerCircleCenter, outerCircleRadius, outerCirclePaint);

    Path dropPath = Path();

   
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

    final double circuitDotRadius = minDim * 0.025;

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
    return true; 
  }
}

class GlucoAILogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;

  const GlucoAILogo({
    super.key,
    this.iconSize = 40.0,
    this.fontSize = 24.0,
  });

  static const Color _kDropColor = Color(0xFF1E5B7B); 
  static const Color _kCircuitColor = Color(0xFF2FAAB1); 
  static const Color _kTextColor = Color(0xFF154160); 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: <Widget>[
        CustomPaint(
          size: Size.square(iconSize), 
          painter: _GlucoAIIconPainter(
            dropColor: _kDropColor,
            circuitColor: _kCircuitColor,
          ),
        ),
        SizedBox(width: iconSize * 0.15), 
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
                child: const Text('Üye Ol'), 
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
              
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
      MaterialPageRoute<void>(builder: (_) => page), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GlucoAILogo(iconSize: 32.0, fontSize: 22.0), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor, 
        unselectedItemColor: Colors.grey, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
        onTap: (int index) {
          if (index == 1) { 
            navigateTo(context, const AyarlarPage());
          }
         
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
                children: <Widget>[
                  MenuItem(
                    icon: Icons.apple,
                    label: 'Beslenme',
                    onTap: () => navigateTo(
                      context,
                      ChangeNotifierProvider<BeslenmeData>(
                        create: (BuildContext context) => BeslenmeData(),
                        builder: (BuildContext context, Widget? child) => const BeslenmePage(),
                      ),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.directions_run,
                    label: 'Egzersiz',
                    onTap: () => navigateTo(
                      context,
                      ChangeNotifierProvider<EgzersizData>(
                        create: (BuildContext context) => EgzersizData(),
                        builder: (BuildContext context, Widget? child) => const EgzersizPage(),
                      ),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Danışma',
                    onTap: () => navigateTo(
                      context,
                      ChangeNotifierProvider<DanismaData>(
                        create: (BuildContext context) => DanismaData(),
                        builder: (BuildContext context, Widget? child) => const DanismaPage(),
                      ),
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
                    icon: Icons.self_improvement,
                    label: 'Psikolojik Destek',
                    onTap: () => navigateTo(context, const MotivasyonPage()),
                  ),
                  MenuItem(
                    icon: Icons.medication_outlined, 
                    label: 'İlaç Takip',
                    onTap: () => navigateTo(context, const IlacTakipPage()),
                  ),
                  MenuItem(
                    icon: Icons.science_outlined, 
                    label: 'Laboratuvar Sonuçları',
                    onTap: () => navigateTo(context, const LabSonuclariPage()),
                  ),
                  MenuItem(
                    icon: Icons.phone_in_talk_outlined,
                    label: 'Acil Durum',
                    onTap: () => navigateTo(context, const AcilDurumPage()),
                  ),
                  MenuItem( 
                    icon: Icons.health_and_safety_outlined,
                    label: 'Sağlık Değerlendirme',
                    onTap: () => navigateTo(
                      context,
                      const SaglikDegerlendirmePage(),
                    ),
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
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: Theme.of(context).primaryColor), // FIXED: Reduced icon size from 60 to 48
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

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
  double? _carbohydrateIntake;
  double? _insulinDose;
  List<MealPlanItem> _generatedMealPlan = <MealPlanItem>[];

  double? get carbohydrateIntake => _carbohydrateIntake;
  double? get insulinDose => _insulinDose;
  List<MealPlanItem> get generatedMealPlan => _generatedMealPlan;

  set carbohydrateIntake(double? value) {
    _carbohydrateIntake = value;
  }

  set insulinDose(double? value) {
    _insulinDose = value;
  }

  void generateMealPlan(double? currentGlucose) {
    _generatedMealPlan = <MealPlanItem>[]; 

    String breakfastSuggestion = "";
    String lunchSuggestion = "";
    String dinnerSuggestion = "";
    String snackSuggestion = "";

    if (currentGlucose != null) {
      if (currentGlucose > 180) { // High glucose
        breakfastSuggestion = "Yulaf ezmesi ve şekersiz çay.";
        lunchSuggestion = "Izgara tavuk salata, bol yeşillikli.";
        dinnerSuggestion = "Buharda sebze ve az yağlı balık.";
        snackSuggestion = "Bir avuç badem veya salatalık dilimleri.";
      } else if (currentGlucose < 70) { // Low glucose
        breakfastSuggestion = "Tam buğday ekmeği ile peynir ve meyve suyu.";
        lunchSuggestion = "Mercimek çorbası ve 1 dilim tam buğday ekmeği.";
        dinnerSuggestion = "Pirinç pilavı ve sebzeli köfte.";
        snackSuggestion = "Bir muz veya birkaç kuru üzüm.";
      } else { // Normal glucose
        breakfastSuggestion = "Yumurta, tam buğday ekmeği ve zeytin.";
        lunchSuggestion = "Baklagil yemeği ve yoğurt.";
        dinnerSuggestion = "Zeytinyağlı sebze yemeği ve bulgur pilavı.";
        snackSuggestion = "Mevsim meyvesi veya bir kase yoğurt.";
      }
    } else { // No glucose data
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
    _carbController.dispose();
    _insulinController.dispose();
    super.dispose();
  }

  void _generateMealPlan() {
    final BeslenmeData beslenmeData = Provider.of<BeslenmeData>(context, listen: false);
    final CanliDurumData canliDurumData = Provider.of<CanliDurumData>(context, listen: false);

    
    beslenmeData.carbohydrateIntake = double.tryParse(_carbController.text);
    beslenmeData.insulinDose = double.tryParse(_insulinController.text);

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
                        color: canliDurumData.currentGlucose < 70 ? Colors.red : (canliDurumData.currentGlucose > 180 ? Colors.orange : Colors.green),
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
                labelText: 'Hedeflenen Karbonhidrat Alımı (gram)', 
                hintText: 'Örn: 150',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _insulinController,
              decoration: const InputDecoration(
                labelText: 'Beklenen İnsülin Dozu (ünite)', 
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
    _generatedExercisePlan = <ExercisePlanItem>[]; 

    final String fitness = _currentFitnessLevel?.toLowerCase() ?? '';
    final String goal = _exerciseGoal?.toLowerCase() ?? '';

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
          activityType: 'Kuvvet', // Fixed typo 'Kuv kuvvet' to 'Kuvvet'
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
        _generatedExercisePlan.add(ExercisePlanItem( // Corrected the typo here
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
          activityType: 'Kuvvet', 
          description: 'Dumbbell lunge',
          durationOrSets: '3 set 12 tekrar',
        ));
      } else if (goal.contains('kas')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuvvet',
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
          activityType: 'Kuvvet',
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
          activityType: 'Kuvvet', // Corrected from Kuv kuvvet
          description: 'Deadlift veya squat (ağırlıklı)',
          durationOrSets: '4 set 6-8 tekrar',
        ));
      } else if (goal.contains('kas')) {
        _generatedExercisePlan.add(ExercisePlanItem(
          activityType: 'Kuvvet', // Corrected from Kuv kuvvet
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
  final List<ConversationMessage> _messages = <ConversationMessage>[];
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
                builder: (BuildContext context, DanismaData data, Widget? child) {
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
                    reverse: true, 
                    itemCount: data.messages.length + (data.isLoading ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (data.isLoading && index == 0) { 
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
                      final int actualMessageListIndex = data.messages.length - 1 - (data.isLoading ? index - 1 : index);

                    
                      if (actualMessageListIndex < 0 || actualMessageListIndex >= data.messages.length) {
                        return const SizedBox.shrink();
                      }

                      final ConversationMessage message = data.messages[actualMessageListIndex];
                      final bool isUser = message.sender == "user";
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUser ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[200],
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
                                style: TextStyle(color: isUser ? Theme.of(context).primaryColor : Colors.black87),
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
                  builder: (BuildContext context, DanismaData data, Widget? child) {
                    return FloatingActionButton(
                      onPressed: data.isLoading ? null : _soruGonder, // Disable while loading
                      backgroundColor: data.isLoading ? Colors.grey : Theme.of(context).primaryColor,
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

class GlucoseReading {
  final double value;
  final DateTime timestamp;

  GlucoseReading({required this.value, required this.timestamp});
}

class CanliDurumData extends ChangeNotifier {
  List<GlucoseReading> _glucoseHistory = <GlucoseReading>[];
  Timer? _timer;
  double _currentGlucose = 120.0; // Initial value
  bool _isSimulating = false;
  final Random _random = Random();

  CanliDurumData() {
    // Initialize with some dummy data if needed or start empty
    _glucoseHistory = <GlucoseReading>[
      GlucoseReading(value: 100, timestamp: DateTime.now().subtract(const Duration(minutes: 60))),
      GlucoseReading(value: 110, timestamp: DateTime.now().subtract(const Duration(minutes: 45))),
      GlucoseReading(value: 125, timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
      GlucoseReading(value: 120, timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
      GlucoseReading(value: 115, timestamp: DateTime.now().subtract(const Duration(minutes: 0))),
    ];
    _currentGlucose = _glucoseHistory.last.value;
  }

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
    final double fluctuation = (_random.nextBool() ? 1 : -1) *
        (10 + _random.nextInt(10)).toDouble();
    double newGlucose = _currentGlucose + fluctuation;

    if (newGlucose < 60) newGlucose = 60 + _random.nextInt(10).toDouble(); // Prevent going too low
    if (newGlucose > 250) newGlucose = 250 - _random.nextInt(10).toDouble(); // Prevent going too high

    _currentGlucose = newGlucose;
    _glucoseHistory.add(GlucoseReading(value: _currentGlucose, timestamp: DateTime.now()));
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
                          child: Text(
                            '${currentGlucose.toStringAsFixed(1)} mg/dL',
                            key: ValueKey<double>(currentGlucose), // Key to trigger animation on change
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
                      final GlucoseReading reading = data.glucoseHistory[data.glucoseHistory.length - 1 - index]; // Reverse order
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: Icon(Icons.monitor_heart, color: Theme.of(context).primaryColor),
                          title: Text('${reading.value.toStringAsFixed(1)} mg/dL'),
                          subtitle: Text('Zaman: ${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}/${reading.timestamp.day.toString().padLeft(2, '0')}/${reading.timestamp.month.toString().padLeft(2, '0')}'),
                          trailing: Icon(
                            reading.value < 70 ? Icons.arrow_downward : (reading.value > 180 ? Icons.arrow_upward : Icons.check),
                            color: reading.value < 70 ? Colors.red : (reading.value > 180 ? Colors.orange : Colors.green),
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

  Future<void> analyzeGlucoseData(BuildContext context) async {
    _isAnalyzing = true;
    notifyListeners();

   
    final List<GlucoseReading> readings = Provider.of<CanliDurumData>(context, listen: false).glucoseHistory;

    _analysisInsights = <String>[];
    _currentTrend = null;
    _averageGlucose = null;
    _minGlucose = null;
    _maxGlucose = null;

    if (readings.isEmpty) {
      _analysisInsights.add("Analiz edilecek glikoz verisi bulunmamaktadır. Lütfen canlı veri akışını başlatın.");
      _isAnalyzing = false;
      notifyListeners();
      return;
    }

    await Future<void>.delayed(const Duration(seconds: 2));

   
    final List<double> values = readings.map<double>((GlucoseReading r) => r.value).toList();
    _averageGlucose = values.reduce((double a, double b) => a + b) / values.length;
    _minGlucose = values.reduce(min);
    _maxGlucose = values.reduce(max);

    _analysisInsights.add("Verilerinizdeki anahtar istatistikler:");
    _analysisInsights.add("- Ortalama Glikoz: ${_averageGlucose!.toStringAsFixed(1)} mg/dL");
    _analysisInsights.add("- Minimum Glikoz: ${_minGlucose!.toStringAsFixed(1)} mg/dL");
    _analysisInsights.add("- Maksimum Glikoz: ${_maxGlucose!.toStringAsFixed(1)} mg/dL");
    _analysisInsights.add(""); // Spacer

  
    if (readings.length >= 3) {
      final double lastValue = readings.last.value;
      final double prevValue = readings[readings.length - 2].value;
      final double beforePrevValue = readings[readings.length - 3].value;

      const double trendThreshold = 5.0; 

      if (lastValue > prevValue + trendThreshold && prevValue > beforePrevValue + trendThreshold) {
        _currentTrend = 'Belirgin Yükseliş Eğilimi';
        _analysisInsights.add("Son ölçümlerinizde belirgin bir yükseliş eğilimi (${beforePrevValue.toStringAsFixed(1)} mg/dL -> ${prevValue.toStringAsFixed(1)} mg/dL -> ${lastValue.toStringAsFixed(1)} mg/dL) gözlemlenmektedir. Bu durum, yakın zamanda karbonhidrat alımınızın fazla olabileceğini veya aktivitenizin azaldığını gösterebilir. Lütfen beslenme ve egzersiz planınızı gözden geçirin.");
      } else if (lastValue < prevValue - trendThreshold && prevValue < beforePrevValue - trendThreshold) {
        _currentTrend = 'Belirgin Düşüş Eğilimi';
        _analysisInsights.add("Son ölçümlerinizde belirgin bir düşüş eğilimi (${beforePrevValue.toStringAsFixed(1)} mg/dL -> ${prevValue.toStringAsFixed(1)} mg/dL -> ${lastValue.toStringAsFixed(1)} mg/dL) bulunmaktadır. Hipoglisemi riskine karşı dikkatli olunuz ve gerekirse hızlı sindirilen bir karbonhidrat kaynağı tüketiniz.");
      } else if (lastValue >= 70 && lastValue <= 180 && prevValue >= 70 && prevValue <= 180 && beforePrevValue >= 70 && beforePrevValue <= 180) {
        _currentTrend = 'Stabil ve Normal Aralıkta';
        _analysisInsights.add("Glikoz seviyeleriniz genel olarak stabil ve sağlıklı aralıkta seyretmektedir. Mevcut yaşam tarzınızın bu dengeyi korumaya yardımcı olduğunu gösteriyor.");
      } else {
        _currentTrend = 'Stabil';
        _analysisInsights.add("Glikoz seviyeleriniz son zamanlarda göreceli olarak stabil seyretmektedir.");
      }
    } else {
      _currentTrend = 'Yeterli Veri Yok';
      _analysisInsights.add("Trend analizi için en az 3 ölçüme ihtiyacımız var. Daha fazla veri geldikçe trendleri analiz edebiliriz.");
    }
    _analysisInsights.add(""); // Spacer

 
    if (_maxGlucose! > 200) {
      _analysisInsights.add("Ölçümlerinizde yüksek glikoz değerleri (${_maxGlucose!.toStringAsFixed(1)} mg/dL) gözlemlenmiştir. Yemek sonrası yükselişler için karbonhidrat alımınızı, ilaç dozajınızı veya fiziksel aktivitenizi gözden geçiriniz. Bu değerler sürekli ise doktorunuza danışmalısınız.");
    } else if (_maxGlucose! > 140 && _maxGlucose! <= 200) {
        _analysisInsights.add("Yemek sonrası glikoz seviyelerinizde hafif yükselişler (${_maxGlucose!.toStringAsFixed(1)} mg/dL) görülmektedir. Porsiyon kontrolü ve besin seçimine dikkat edebilirsiniz.");
    }

    if (_minGlucose! < 70) {
      _analysisInsights.add("Ölçümlerinizde düşük glikoz değerleri (${_minGlucose!.toStringAsFixed(1)} mg/dL) gözlemlenmiştir. Hipoglisemi ataklarına karşı uyanık olunuz ve belirtiler hissettiğinizde hızlıca müdahale ediniz. Bu durumun nedenini doktorunuzla görüşün.");
    } else if (_minGlucose! < 85 && _minGlucose! >= 70) {
        _analysisInsights.add("Glikoz seviyeleriniz bazen normal aralığın alt sınırlarına (${_minGlucose!.toStringAsFixed(1)} mg/dL) yaklaşmaktadır. Bu durumlarda açlık sürenize veya egzersiz yoğunluğunuza dikkat ediniz.");
    }

  
    _analysisInsights.add("Genel Glikoz Yönetimi İpuçları:");
    _analysisInsights.add("- Düzenli ve dengeli öğünler tüketmek, kan şekeri dalgalanmalarını azaltmaya yardımcı olur.");
    _analysisInsights.add("- Fiziksel aktivite, insülin duyarlılığını artırır ve glikoz seviyelerini dengelemeye yardımcı olur.");
    _analysisInsights.add("- İlaçlarınızı ve insülin dozajınızı doktorunuzun önerdiği şekilde kullanmaya özen gösterin.");
    _analysisInsights.add("- Stres yönetimi ve yeterli uyku da glikoz kontrolünde önemli rol oynar.");
    _analysisInsights.add(""); // Spacer
    _analysisInsights.add("**Önemli Not:** Bu analizler yapay zeka tarafından sağlanan genel bilgilerdir. Kesin tıbbi teşhis, tedavi veya ilaç dozajı ayarlamaları için daima bir sağlık uzmanına, yani doktorunuza danışmanız gerekmektedir.");

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
          GenelRaporlarView(), 
         
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
  
  const SekerAnaliziView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SekerAnalizData, CanliDurumData>(
      builder: (BuildContext context, SekerAnalizData sekerAnalizData, CanliDurumData canliDurumData, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: sekerAnalizData.isAnalyzing
                    ? null
                    : () {
                       
                        sekerAnalizData.analyzeGlucoseData(context);
                      },
                icon: sekerAnalizData.isAnalyzing ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ) : const Icon(Icons.analytics_outlined),
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
                              _buildDetailRow('Ortalama Glikoz:', sekerAnalizData.averageGlucose != null ? '${sekerAnalizData.averageGlucose!.toStringAsFixed(1)} mg/dL' : 'N/A'),
                              _buildDetailRow('Minimum Glikoz:', sekerAnalizData.minGlucose != null ? '${sekerAnalizData.minGlucose!.toStringAsFixed(1)} mg/dL' : 'N/A'),
                              _buildDetailRow('Maksimum Glikoz:', sekerAnalizData.maxGlucose != null ? '${sekerAnalizData.maxGlucose!.toStringAsFixed(1)} mg/dL' : 'N/A'),
                              _buildDetailRow('Trend:', sekerAnalizData.currentTrend ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
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
                                          Icon(Icons.lightbulb_outline, size: 20, color: Theme.of(context).primaryColor),
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
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    final double chartHeight = 150.0; 

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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: chartHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: glucoseHistory.map<Widget>((GlucoseReading reading) {
                final double normalizedHeight = range > 0 ? (reading.value - minGlucose) / range : 0.5; 
                final double barHeight = chartHeight * 0.8 * (normalizedHeight + 0.2); 
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
                        width: 16,
                        height: barHeight,
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
      elevation: 0, 
      margin: EdgeInsets.zero, 
      shape: const RoundedRectangleBorder(), 
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
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300], indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}


enum AiModelSensitivity { dusuk, orta, yuksek }
enum AppThemeOption { acik, koyu }

class KisiselBilgilerData extends ChangeNotifier {
  String? _name;
  int? _age;
  double? _heightCm;
  double? _weightKg;
  String? _diabetesType;
  String _deviceConnectionStatus; 

  AiModelSensitivity _aiModelSensitivity; 
  bool _isAppLanguageTurkish; 
  AppThemeOption _appTheme; 
  
  KisiselBilgilerData()
      : _name = null,
        _age = null,
        _heightCm = null,
        _weightKg = null,
        _diabetesType = null,
        _deviceConnectionStatus = 'Bağlı Değil', 
        _aiModelSensitivity = AiModelSensitivity.orta,
        _isAppLanguageTurkish = true,
        _appTheme = AppThemeOption.acik;

  String? get name => _name;
  int? get age => _age;
  double? get heightCm => _heightCm;
  double? get weightKg => _weightKg;
  String? get diabetesType => _diabetesType;
  String get deviceConnectionStatus => _deviceConnectionStatus;

  AiModelSensitivity get aiModelSensitivity => _aiModelSensitivity;
  bool get isAppLanguageTurkish => _isAppLanguageTurkish;
  AppThemeOption get appTheme => _appTheme;

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

  bool get isProfileComplete {
    return _name != null && _name!.isNotEmpty &&
        _age != null && _age! > 0 &&
        _heightCm != null && _heightCm! > 0 &&
        _weightKg != null && _weightKg! > 0 &&
        _diabetesType != null && _diabetesType!.isNotEmpty;
  }
}

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

enum ConnectionStatus { idle, connecting, connected, failed }

class CihazBaglantiData extends ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.idle;

  ConnectionStatus get status => _status;

  Future<void> connectDevice(BuildContext context) async {
    _status = ConnectionStatus.connecting;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      final bool success = DateTime.now().second % 2 == 0; 
      if (success) {
        _status = ConnectionStatus.connected;
        Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlandı';
      } else {
        _status = ConnectionStatus.failed;
        Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlantı Başarısız';
      }
    } catch (e) {
      _status = ConnectionStatus.failed;
      Provider.of<KisiselBilgilerData>(context, listen: false).deviceConnectionStatus = 'Bağlantı Hatası';
    } finally {
      notifyListeners();
    }
  }
}

class CihazBaglantiPage extends StatefulWidget {
  const CihazBaglantiPage({super.key});

  @override
  State<CihazBaglantiPage> createState() => _CihazBaglantiPageState();
}

class _CihazBaglantiPageState extends State<CihazBaglantiPage> {
  @override
  void initState() {
    super.initState();
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
              showActionButton = false;
              break;
            case ConnectionStatus.connected:
              message = 'Cihaz başarıyla bağlandı!';
              icon = Icons.bluetooth;
              color = Colors.green;
              showProgress = false;
              showActionButton = true;
              action = () {
                
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


class KisiselBilgilerPage extends StatelessWidget {
  const KisiselBilgilerPage({super.key});

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
        builder: (BuildContext context, KisiselBilgilerData data, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              
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

             
              _ProfileDetailRow(label: 'Ad', value: data.name ?? 'Henüz Girilmedi'),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              _ProfileDetailRow(label: 'Yaş', value: data.age?.toString() ?? 'Henüz Girilmedi'),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              _ProfileDetailRow(label: 'Boy', value: data.heightCm != null ? '${data.heightCm!.toStringAsFixed(0)} cm' : 'Henüz Girilmedi'),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              _ProfileDetailRow(label: 'Kilo', value: data.weightKg != null ? '${data.weightKg!.toStringAsFixed(0)} kg' : 'Henüz Girilmedi'),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              _ProfileDetailRow(label: 'Cihaz bağlantı durumu', value: data.deviceConnectionStatus),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),

              
              _ProfileActionRow(
                label: 'AI model ayarları (hassasiyet seviyesi)',
                value: data.getLocalizedAiModelSensitivity(),
                onTap: () => navigateTo(context, const AiModelAyarlariPage()),
              ),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              const SizedBox(height: 24),

             
              const Text(
                'Uygulama dili & tema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: GlucoAILogo._kTextColor,
                ),
              ),
              const SizedBox(height: 16),

              
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
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),


              _ProfileActionRow(
                label: 'Tema',
                value: data.getLocalizedAppTheme(),
                onTap: () => navigateTo(context, const TemaAyarlariPage()),
              ),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
            ],
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
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
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
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Row(
              children: <Widget>[
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
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
        builder: (BuildContext context, KisiselBilgilerData data, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Yapay Zeka Model Hassasiyeti',
                  style: Theme.of(context).textTheme.titleLarge,
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
                  style: Theme.of(context).textTheme.bodyMedium,
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
        builder: (BuildContext context, KisiselBilgilerData data, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Uygulama Teması',
                  style: Theme.of(context).textTheme.titleLarge,
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
                  style: Theme.of(context).textTheme.bodyMedium,
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

class BildirimAyarlariPage extends StatelessWidget {
  const BildirimAyarlariPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bildirim Ayarları")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Bildirim ayarları (kan şekeri ölçüm, ilaç hatırlatıcıları vb.) buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Veri gizliliği, şifre değiştirme, biyometrik giriş gibi güvenlik ayarları buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "KVKK / HIPAA ve diğer yasal veri izinleri ile ilgili bilgiler ve ayarlar buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Uygulama hakkında genel bilgiler, sürüm detayları ve lisans bilgileri buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
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
    return Scaffold(
      appBar: AppBar(title: const Text("SSS (Sıkça Sorulan Sorular)")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Uygulama kullanımı ile ilgili sıkça sorulan soruların cevapları buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class CanliDestekPage extends StatelessWidget {
  const CanliDestekPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canlı Destek")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Uygulama içi canlı destek sohbeti veya iletişim bilgileri buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class KullanimRehberiVideolariPage extends StatelessWidget {
  const KullanimRehberiVideolariPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kullanım Rehberi Videoları")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Uygulama özelliklerini tanıtan video rehberleri buraya eklenecektir.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class GeriBildirimGonderPage extends StatelessWidget {
  const GeriBildirimGonderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geri Bildirim Gönder")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Uygulama ile ilgili görüş, öneri veya hata bildirimi gönderme formu buraya gelecek.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}


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
  final List<Map<String, String>> _moodHistory = <Map<String, String>>[];

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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Bu modül henüz geliştirme aşamasındadır. Yakında psikolojik destek ve motivasyonel içeriklere erişebilecekti.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}


class IlacKaydi {
  final String ilacAdi;
  final String dozaj;
  final DateTime zaman;

  IlacKaydi({required this.ilacAdi, required this.dozaj, required this.zaman});
}

class IlacTakipData extends ChangeNotifier {
  final List<IlacKaydi> _ilacGecmisi = <IlacKaydi>[];

  List<IlacKaydi> get ilacGecmisi => _ilacGecmisi;

  void ilacEkle(String ilacAdi, String dozaj) {
    if (ilacAdi.isNotEmpty && dozaj.isNotEmpty) {
      _ilacGecmisi.add(IlacKaydi(ilacAdi: ilacAdi, dozaj: dozaj, zaman: DateTime.now()));
      notifyListeners();
    }
  }
}


class IlacTakipPage extends StatelessWidget {
  const IlacTakipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlaç Takip Modülü")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Bu modül henüz geliştirme aşamasındadır. Yakında ilaçlarınızı takip edebilecek ve hatırlatıcılar alabileceksiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}


class LabSonucu {
  final String testAdi;
  final String deger;
  final String birim;
  final DateTime tarih;

  LabSonucu({required this.testAdi, required this.deger, required this.birim, required this.tarih});
}

class LabSonuclariData extends ChangeNotifier {
  final List<LabSonucu> _sonuclar = <LabSonucu>[];

  List<LabSonucu> get sonuclar => _sonuclar;

  void sonucEkle(String testAdi, String deger, String birim) {
    if (testAdi.isNotEmpty && deger.isNotEmpty && birim.isNotEmpty) {
      _sonuclar.add(LabSonucu(testAdi: testAdi, deger: deger, birim: birim, tarih: DateTime.now()));
      notifyListeners();
    }
  }
}


class LabSonuclariPage extends StatelessWidget {
  const LabSonuclariPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laboratuvar Sonuçları ve Sağlık Kayıtları")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Bu modül henüz geliştirme aşamasındadır. Yakında laboratuvar sonuçlarınızı ve sağlık kayıtlarınızı görüntüleyebileceksiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}


class AcilDurumData extends ChangeNotifier {
  String _emergencyContactName = "Belirtilmedi";
  String _emergencyContactPhone = "Belirtilmedi";
  String _medicalConditionNote = "Belirtilmedi";

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
    return Scaffold(
      appBar: AppBar(title: const Text("Acil Durum Modülü")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Bu modül henüz geliştirme aşamasındadır. Yakında acil durum bilgilerinizi yönetebilecek ve hızlı arama/mesajlaşma yapabileceksiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

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
                const KisiselBilgilerPage(), 
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
            icon: Icons.article_outlined, 
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


class SaglikVerileriData extends ChangeNotifier {
  int? _age;
  String? _gender; 
  bool? _highCholesterol;
  bool? _cholesterolChecked;
  double? _bmi;
  bool? _smokes;
  bool? _heartDiseaseOrAttack;
  String? _physicalActivity; 
  String? _fruitConsumption; 
  String? _vegetableConsumption; 
  List<String> _analysisInsights = <String>[];
  bool _isAnalyzing = false;

  SaglikVerileriData()
      : _age = null,
        _gender = null,
        _highCholesterol = null,
        _cholesterolChecked = null,
        _bmi = null,
        _smokes = null,
        _heartDiseaseOrAttack = null,
        _physicalActivity = null,
        _fruitConsumption = null,
        _vegetableConsumption = null;

  int? get age => _age;
  String? get gender => _gender;
  bool? get highCholesterol => _highCholesterol;
  bool? get cholesterolChecked => _cholesterolChecked;
  double? get bmi => _bmi;
  bool? get smokes => _smokes;
  bool? get heartDiseaseOrAttack => _heartDiseaseOrAttack;
  String? get physicalActivity => _physicalActivity;
  String? get fruitConsumption => _fruitConsumption;
  String? get vegetableConsumption => _vegetableConsumption;
  List<String> get analysisInsights => _analysisInsights;
  bool get isAnalyzing => _isAnalyzing;

  set age(int? value) {
    if (_age != value) {
      _age = value;
      notifyListeners();
    }
  }

  set gender(String? value) {
    if (_gender != value) {
      _gender = value;
      notifyListeners();
    }
  }

  set highCholesterol(bool? value) {
    if (_highCholesterol != value) {
      _highCholesterol = value;
      notifyListeners();
    }
  }

  set cholesterolChecked(bool? value) {
    if (_cholesterolChecked != value) {
      _cholesterolChecked = value;
      notifyListeners();
    }
  }

  set bmi(double? value) {
    if (_bmi != value) {
      _bmi = value;
      notifyListeners();
    }
  }

  set smokes(bool? value) {
    if (_smokes != value) {
      _smokes = value;
      notifyListeners();
    }
  }

  set heartDiseaseOrAttack(bool? value) {
    if (_heartDiseaseOrAttack != value) {
      _heartDiseaseOrAttack = value;
      notifyListeners();
    }
  }

  set physicalActivity(String? value) {
    if (_physicalActivity != value) {
      _physicalActivity = value;
      notifyListeners();
    }
  }

  set fruitConsumption(String? value) {
    if (_fruitConsumption != value) {
      _fruitConsumption = value;
      notifyListeners();
    }
  }

  set vegetableConsumption(String? value) {
    if (_vegetableConsumption != value) {
      _vegetableConsumption = value;
      notifyListeners();
    }
  }

  Future<void> analyzeHealthData() async {
    _isAnalyzing = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2)); 

    _analysisInsights = <String>[]; 


    int riskScore = 0;

    if (_age != null && _age! >= 40) {
      _analysisInsights.add("Yaşınız, bazı sağlık riskleri için düzenli taramaları önemli kılmaktadır.");
      riskScore += 1;
    }

    if (_gender == 'Erkek' && _age != null && _age! >= 45) {
      _analysisInsights.add("Erkeklerde kalp hastalığı riski yaşla birlikte artabilir, düzenli kontrol önerilir.");
      riskScore += 1;
    } else if (_gender == 'Kadın' && _age != null && _age! >= 55) {
      _analysisInsights.add("Kadınlarda menopoz sonrası kalp hastalığı riski artabilir.");
      riskScore += 1;
    }

    if (_highCholesterol == true) {
      _analysisInsights.add("Yüksek kolesterol tespitiniz varsa, diyet ve yaşam tarzı değişiklikleri önemlidir. Doktorunuzun önerilerine uyun.");
      riskScore += 2;
      if (_cholesterolChecked != true) {
        _analysisInsights.add("Kolesterol seviyelerinizi düzenli olarak kontrol ettirmeniz hayati önem taşımaktadır.");
        riskScore += 1;
      }
    } else if (_highCholesterol == false && _cholesterolChecked != true) {
       _analysisInsights.add("Kolesterol seviyelerinizin yakın zamanda kontrol edildiğinden emin olun.");
    }


    if (_bmi != null) {
      if (_bmi! >= 30) {
        _analysisInsights.add("Vücut Kitle İndeksiniz obezite sınıfında. Kilo yönetimi, diyabet ve kalp hastalığı riskini azaltabilir.");
        riskScore += 3;
      } else if (_bmi! >= 25) {
        _analysisInsights.add("Vücut Kitle İndeksiniz fazla kilolu sınıfında. Sağlıklı kilo aralığına ulaşmak genel sağlığınızı iyileştirir.");
        riskScore += 1;
      } else {
        _analysisInsights.add("Vücut Kitle İndeksiniz sağlıklı aralıkta. Mevcut kilonuzu korumaya devam edin.");
      }
    }

    if (_smokes == true) {
      _analysisInsights.add("Sigara içmek, kalp hastalığı, diyabet komplikasyonları ve birçok kanser türü riskini ciddi şekilde artırır. Bırakmayı şiddetle düşünmelisiniz.");
      riskScore += 4;
    } else if (_smokes == false) {
      _analysisInsights.add("Sigara içmemeniz sağlığınız için harika bir adımdır!");
    }


    if (_heartDiseaseOrAttack == true) {
      _analysisInsights.add("Geçmişte kalp hastalığı veya krizi yaşamanız, gelecekteki riskler için düzenli tıbbi takibi zorunlu kılar.");
      riskScore += 5;
    }

    if (_physicalActivity == 'Hareketsiz') {
      _analysisInsights.add("Fiziksel aktivite seviyeniz düşük görünüyor. Düzenli egzersiz, kan şekeri kontrolü ve kalp sağlığı için kritik öneme sahiptir.");
      riskScore += 2;
    } else if (_physicalActivity == 'Orta') {
      _analysisInsights.add("Orta düzeyde fiziksel aktivite iyi bir başlangıç. Daha aktif olmak için hedefler belirleyebilirsiniz.");
    } else if (_physicalActivity == 'Aktif') {
      _analysisInsights.add("Fiziksel olarak aktif olmanız sağlığınız için çok değerli. Bu alışkanlığı sürdürün.");
    }

    if (_fruitConsumption == 'Nadiren') {
      _analysisInsights.add("Meyve tüketiminizi artırmanız önerilir. Meyveler lif ve vitamin açısından zengindir.");
      riskScore += 1;
    } else if (_fruitConsumption == 'Haftada Birkaç Kez' || _fruitConsumption == 'Her Gün') {
      _analysisInsights.add("Meyve tüketiminiz iyi düzeyde. Şeker içeriğine dikkat ederek çeşitliliği koruyun.");
    }

    if (_vegetableConsumption == 'Nadiren') {
      _analysisInsights.add("Sebze tüketiminizi artırmanız sağlığınız için çok önemlidir. Çeşitli renklerde sebzeler tercih edin.");
      riskScore += 1;
    } else if (_vegetableConsumption == 'Haftada Birkaç Kez' || _vegetableConsumption == 'Her Gün') {
      _analysisInsights.add("Sebze tüketiminiz iyi düzeyde. Lif ve besin alımınızı sürdürün.");
    }

    if (_analysisInsights.isEmpty) {
      _analysisInsights.add("Tüm verileriniz analiz edildi. Henüz belirgin bir risk faktörü bulunamadı veya daha fazla veri girişi gerekmektedir.");
    } else {
      String overallRisk;
      if (riskScore >= 7) {
        overallRisk = "Yüksek Risk";
      } else if (riskScore >= 3) {
        overallRisk = "Orta Risk";
      } else {
        overallRisk = "Düşük Risk";
      }
      _analysisInsights.insert(0, "Genel sağlık risk değerlendirmeniz: **$overallRisk**.");
      _analysisInsights.add("Unutmayın, bu analizler yapay zeka tarafından sağlanan genel bilgilerdir. Kesin tıbbi teşhis ve tedavi için daima bir sağlık uzmanına danışın.");
    }

    _isAnalyzing = false;
    notifyListeners();
  }

  void resetData() {
    _age = null;
    _gender = null;
    _highCholesterol = null;
    _cholesterolChecked = null;
    _bmi = null;
    _smokes = null;
    _heartDiseaseOrAttack = null;
    _physicalActivity = null;
    _fruitConsumption = null;
    _vegetableConsumption = null;
    _analysisInsights = <String>[];
    _isAnalyzing = false;
    notifyListeners();
  }
}

class SaglikDegerlendirmePage extends StatefulWidget {
  const SaglikDegerlendirmePage({super.key});

  @override
  State<SaglikDegerlendirmePage> createState() => _SaglikDegerlendirmePageState();
}

class _SaglikDegerlendirmePageState extends State<SaglikDegerlendirmePage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();

  final List<String> _genderOptions = <String>['Erkek', 'Kadın', 'Diğer'];
  final List<String> _physicalActivityOptions = <String>['Hareketsiz', 'Orta', 'Aktif'];
  final List<String> _consumptionOptions = <String>['Her Gün', 'Haftada Birkaç Kez', 'Nadiren'];

  @override
  void initState() {
    super.initState();
    final SaglikVerileriData data = Provider.of<SaglikVerileriData>(context, listen: false);
    _ageController.text = data.age?.toString() ?? '';
    _bmiController.text = data.bmi?.toStringAsFixed(1) ?? '';
  }

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    super.dispose();
  }

  void _performAnalysis() {
    final SaglikVerileriData data = Provider.of<SaglikVerileriData>(context, listen: false);

    data.age = int.tryParse(_ageController.text);
    data.bmi = double.tryParse(_bmiController.text);


    if (data.age == null || data.age! <= 0 || data.bmi == null || data.bmi! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen yaş ve VKİ bilgilerinizi doğru giriniz.')),
      );
      return;
    }

    data.analyzeHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sağlık Değerlendirme")),
      body: Consumer<SaglikVerileriData>(
        builder: (BuildContext context, SaglikVerileriData data, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: 'Yaş'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: data.gender,
                          decoration: const InputDecoration(labelText: 'Cinsiyet'),
                          hint: const Text('Cinsiyet Seçin'),
                          items: _genderOptions
                              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            data.gender = newValue;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bmiController,
                          decoration: const InputDecoration(
                            labelText: 'Vücut Kitle İndeksi (VKİ)',
                            hintText: 'Örn: 24.5',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title: const Text('Yüksek Kolesterol'),
                          value: data.highCholesterol ?? false,
                          onChanged: (bool value) {
                            data.highCholesterol = value;
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Kolesterol Kontrolü Yapıldı mı?'),
                          value: data.cholesterolChecked ?? false,
                          onChanged: (bool value) {
                            data.cholesterolChecked = value;
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Sigara İçiyor mu?'),
                          value: data.smokes ?? false,
                          onChanged: (bool value) {
                            data.smokes = value;
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Kalp Hastalığı veya Krizi Geçirdi mi?'),
                          value: data.heartDiseaseOrAttack ?? false,
                          onChanged: (bool value) {
                            data.heartDiseaseOrAttack = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: data.physicalActivity,
                          decoration: const InputDecoration(labelText: 'Fiziksel Aktivite Seviyesi'),
                          hint: const Text('Seviye Seçin'),
                          items: _physicalActivityOptions
                              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            data.physicalActivity = newValue;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: data.fruitConsumption,
                          decoration: const InputDecoration(labelText: 'Meyve Tüketimi'),
                          hint: const Text('Tüketim Sıklığı Seçin'),
                          items: _consumptionOptions
                              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            data.fruitConsumption = newValue;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: data.vegetableConsumption,
                          decoration: const InputDecoration(labelText: 'Sebze Tüketimi'),
                          hint: const Text('Tüketim Sıklığı Seçin'),
                          items: _consumptionOptions
                              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            data.vegetableConsumption = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: data.isAnalyzing ? null : _performAnalysis,
                  icon: data.isAnalyzing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Icon(Icons.analytics_outlined),
                  label: Text(data.isAnalyzing ? 'Sağlık Verileri Analiz Ediliyor...' : 'Sağlık Verilerini Analiz Et'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: GlucoAILogo._kCircuitColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                if (data.analysisInsights.isNotEmpty || data.isAnalyzing)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Yapay Zeka Sağlık Değerlendirmesi',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GlucoAILogo._kDropColor),
                          ),
                          const SizedBox(height: 8),
                          if (data.isAnalyzing)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.analysisInsights.map<Widget>((String insight) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.lightbulb_outline, size: 20, color: Theme.of(context).primaryColor),
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
                  )
                else
                  const Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Yukarıdaki bilgileri doldurup "Sağlık Verilerini Analiz Et" butonuna tıklayarak yapay zeka destekli sağlık değerlendirmenizi alabilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
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
