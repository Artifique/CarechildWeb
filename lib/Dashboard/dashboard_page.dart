
import 'package:accessability/Modele/enfant_modele%20.dart';
import 'package:accessability/Services/enfant_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UtilisateurService utilisateurService = UtilisateurService();
  final EnfantService enfantService = EnfantService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 800;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  if (isSmallScreen)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLeftColumn(context, isSmallScreen),
                        _buildRightColumn(context, isSmallScreen),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildLeftColumn(context, isSmallScreen)),
                        Expanded(child: _buildRightColumn(context, isSmallScreen)),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

Widget _buildLeftColumn(BuildContext context, bool isSmallScreen) {
  double widthFactor = isSmallScreen
      ? MediaQuery.of(context).size.width / 1.2
      : MediaQuery.of(context).size.width / 3;

  return Column(
    children: [
      Row(
        mainAxisAlignment:
            isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTotalContainer(
              context,
              utilisateurService.getTotalParents(),
              "Total des parents",
              widthFactor,
            ),
          ),
          if (!isSmallScreen)
            Expanded(
              child: _buildTotalContainer(
                context,
                utilisateurService.getTotalSpecialistes(),
                "Total des spécialistes",
                widthFactor,
              ),
            ),
          if (!isSmallScreen)
            Expanded(
              child: _buildTotalContainer(
                context,
                 enfantService.getTotalEnfants(),
                "Total des Enfants",
                widthFactor,
              ),
            ),
        ],
      ),
      if (isSmallScreen)
        _buildTotalContainer(
          context,
          enfantService.getTotalEnfants(),
          "Total des Enfants",
          widthFactor,
        ),
      if (isSmallScreen) _buildContainer3(context, widthFactor),
      Row(
        mainAxisAlignment:
            isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Expanded(child: _buildProfileCards(context, isSmallScreen)),
          if (!isSmallScreen) _buildAddIcon(context),
        ],
      ),
      if (isSmallScreen) _buildAddIcon(context),
      _buildLargeContainer(
        context,
        isSmallScreen
            ? MediaQuery.of(context).size.width / 1.2
            : MediaQuery.of(context).size.width / 1.8,
      ),
    ],
  );
}

  Widget _buildRightColumn(BuildContext context, bool isSmallScreen) {
    double widthFactor = isSmallScreen ? MediaQuery.of(context).size.width / 1.2 : MediaQuery.of(context).size.width / 6;

    return Column(
      children: [
        _buildImageContainer(context, widthFactor),
        _buildPieChart(context, widthFactor),

      ],
    );
  }

  // Function to create total containers
  Widget _buildTotalContainer(BuildContext context, Future<int> future, String title, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20,left: 20),
      width: width,
      height: MediaQuery.of(context).size.height / 4.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 88, 87, 87),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: FutureBuilder<int>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else {
            int total = snapshot.data ?? 0;
            return Center(
              child: Text(
                "$title : $total",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContainer3(BuildContext context, double width) {
    return FutureBuilder<int>(
      future: enfantService.getTotalEnfants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        } else {
          int totalEnfants = snapshot.data ?? 0;
          return Container(
            margin: const EdgeInsets.all(20),
            width: width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 88, 87, 87),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Total des Enfants : $totalEnfants",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileCards(BuildContext context, bool isSmallScreen) {
    return FutureBuilder<List<Enfant>>(
      future: enfantService.getAllEnfants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        } else {
          List<Enfant> enfants = snapshot.data ?? [];

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: enfants.map((enfant) {
              return _buildProfileCard(context, enfant);
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, Enfant enfant) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 150,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 88, 87, 87),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.child_care, size: 80, color: Colors.black),
          SizedBox(height: 10),
          Text(
            enfant.nom,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            enfant.typeHandicap,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddIcon(BuildContext context) {
    return Container(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 170, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildLargeContainer(BuildContext context, double width) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: width,
      height: MediaQuery.of(context).size.height / 2.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 88, 87, 87),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 10,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const style = TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    switch (value.toInt()) {
                      case 0:
                        return const Text('L', style: style);
                      case 1:
                        return const Text('M', style: style);
                      case 2:
                        return const Text('M', style: style);
                      case 3:
                        return const Text('J', style: style);
                      case 4:
                        return const Text('V', style: style);
                      case 5:
                        return const Text('S', style: style);
                      case 6:
                        return const Text('D', style: style);
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(
                  toY: 5,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                  toY: 8,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(
                  toY: 3,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(
                  toY: 10,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(
                  toY: 7,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(
                  toY: 4,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(
                  toY: 6,
                  color: Colors.lightBlue,
                  width: 20,
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, double width) {
    List<double> data = [30, 20, 50];
    List<String> labels = ["Handicap A", "Handicap B", "Handicap C"];

    return Container(
      margin: const EdgeInsets.all(20),
      width: width * 1.2,
      height: MediaQuery.of(context).size.height / 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 88, 87, 87),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PieChart(
          PieChartData(
            sections: List.generate(data.length, (index) {
              return PieChartSectionData(
                value: data[index],
                title: labels[index],
                color: Colors.primaries[index % Colors.primaries.length],
                radius: 30,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, double width) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: width,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 88, 87, 87),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/care.png', height: 200, width: 200),
        ],
      ),
    );
  }

}