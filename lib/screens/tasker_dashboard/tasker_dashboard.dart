// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/helpers/methods.dart';
import 'package:pairtasker/screens/tasker_dashboard/Ratio_widget.dart';
import 'package:pairtasker/screens/tasker_dashboard/active_tasks.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/tasker.dart';
import '../home_screen/drawer.dart';

class TaskerDashboard extends StatefulWidget {
  const TaskerDashboard({super.key});

  @override
  State<TaskerDashboard> createState() => _TaskerDashboardState();
}

class _TaskerDashboardState extends State<TaskerDashboard> {
  bool taskerMode = false;
  bool _isInit = true;
  String address = '';
  int totalTasks = 0;
  int thresholdLimit = 5;
  double rating = 0;
  int activeTasks = 0;
  int totalRequests = 0;
  int totalSaves = 0;
  int completedTasks = 0;
  int terminatedTasks = 0;
  int acceptanceRatio = 0;
  int availabilityRatio = 0;
  int avgTaskCompletionTime = 0;
  int network = 0;
  Map<dynamic, dynamic> workingCategories = {};

  final colorList = <Color>[
    const Color.fromRGBO(0, 127, 255, 1),
    const Color.fromRGBO(0, 127, 255, 0.8),
    const Color.fromRGBO(0, 127, 255, 0.6),
    const Color.fromRGBO(0, 127, 255, 0.4),
    const Color.fromRGBO(0, 127, 255, 0.2),
  ];

  @override
  void didChangeDependencies() async {
    final prefs = await SharedPreferences.getInstance();
    final a = prefs.getString('address');
    setState(() {
      address = a.toString();
    });
    if (_isInit) {
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      if (userdata['isTasker'] != null) {
        setState(() {
          taskerMode = userdata['tasker']['isOnline'];
        });
      }
    }
    fetchTaskerMetrics();
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> fetchTaskerMetrics() async {
    final response =
        await Provider.of<Tasker>(context, listen: false).getTaskerMetrics();
    if (response.statusCode == 200) {
      setState(() {
        totalTasks = response.data['data']['totalTasks'];
        totalRequests = response.data['data']['totalRequests'];
        totalSaves = response.data['data']['saves'];
        rating = double.parse(response.data['data']['rating'].toString());
        activeTasks = response.data['data']['activeTasks'];
        completedTasks = response.data['data']['completedTasks'];
        thresholdLimit = int.parse(response.data['data']['thresholdLimit']);
        acceptanceRatio = response.data['data']['acceptanceRatio'];
        availabilityRatio = response.data['data']['availabilityRatio'];
        avgTaskCompletionTime = response.data['data']['avgTaskCompletionTime'];
        network = response.data['data']['network'];
        terminatedTasks = totalTasks - completedTasks - activeTasks;
        if (response.data['data']['taskCategoriesCount'] != null) {
          workingCategories = response.data['data']['taskCategoriesCount'].map(
            (key, value) => MapEntry(
              key.toString(),
              double.parse(value.toString()),
            ),
          );
        }
      });
    }
  }

  Future<void> updateTaskerStatus(bool status) async {
    setState(() {
      taskerMode = status;
    });
    final response = await Provider.of<Tasker>(context, listen: false)
        .setTaskerOnline(status);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(
            seconds: 2,
          ),
          backgroundColor: taskerMode ? HexColor('00CE15') : HexColor('FF033E'),
          content: Text(
            response.data['message'],
            style: GoogleFonts.poppins(
              color: Helper.isDark(context) ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      drawer: const DrawerWidget(),
      body: Builder(
        builder: ((context) => SafeArea(
              child: RefreshIndicator(
                onRefresh: fetchTaskerMetrics,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 0.2,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(
                                    right: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(125),
                                    ),
                                    color: Helper.isDark(context)
                                        ? const Color.fromRGBO(
                                            242,
                                            242,
                                            243,
                                            0.349,
                                          )
                                        : const Color.fromRGBO(0, 0, 0, 0.1),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () =>
                                          Scaffold.of(context).openDrawer(),
                                      child: SvgPicture.asset(
                                        'assets/images/icons/menu.svg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: HexColor('#007FFF'),
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    address != 'null'
                                        ? address
                                        : 'Andhra Pradesh',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => updateTaskerStatus(!taskerMode),
                            child: SvgPicture.asset(
                              'assets/images/icons/${taskerMode ? 'online' : 'offline'}.svg',
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor(
                            Helper.isDark(context) ? '252B30' : '#E4ECF5',
                          ),
                        ),
                        child: ListView(
                          children: [
                            const ActiveTasks(),
                            Container(
                              decoration: BoxDecoration(
                                color: Helper.isDark(context)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 25,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                          color: HexColor('FFC72C'),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/icons/rating.svg',
                                          ),
                                          Text(
                                            rating.toStringAsPrecision(2),
                                            style: GoogleFonts.lato(
                                              color: HexColor('FFC72C'),
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                          color: HexColor('FF033E'),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/icons/wishlist_dark.svg',
                                          ),
                                          Text(
                                            totalSaves.toString(),
                                            style: GoogleFonts.lato(
                                              color: HexColor('FF033E'),
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                          color: HexColor('551BFB'),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/icons/network.svg',
                                          ),
                                          Text(
                                            network.toString(),
                                            style: GoogleFonts.lato(
                                              color: HexColor('551BFB'),
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            RatioWidget(
                              icon: 'availability',
                              title: 'Availability Ratio',
                              description: 'Active tasks by Threshold',
                              ratio: '$activeTasks/0$thresholdLimit',
                              percentage: availabilityRatio,
                              color: '007FFF',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            RatioWidget(
                              icon: 'acceptance',
                              title: 'Acceptance Ratio',
                              description:
                                  'Total accepted tasks by Number of Requests',
                              ratio: '$totalTasks/$totalRequests',
                              percentage: acceptanceRatio,
                              color: '00CE15',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            RatioWidget(
                              icon: 'time',
                              title: 'Average Task completion time',
                              description:
                                  'Sum of all task completion time by Completed Tasks',
                              ratio: '',
                              percentage: 0,
                              time: Helper.convertTimeFromMilliSeconds(
                                avgTaskCompletionTime.toDouble(),
                              ),
                              color: '551BFB',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Helper.isDark(context)
                                      ? Colors.black
                                      : Colors.white,
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Completed Tasks',
                                            style: GoogleFonts.lato(
                                                color: HexColor('99A4AE'),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '$completedTasks',
                                                style: GoogleFonts.lato(
                                                    color: HexColor('00CE15'),
                                                    fontSize: 42,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '  / $totalTasks',
                                                style: GoogleFonts.lato(
                                                    color: HexColor('AAABAB'),
                                                    fontSize: 32,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        color: HexColor('99A4AE'),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Terminated Tasks',
                                            style: GoogleFonts.lato(
                                                color: HexColor('99A4AE'),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '$terminatedTasks',
                                                style: GoogleFonts.lato(
                                                  color: HexColor('FF033E'),
                                                  fontSize: 42,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '  / $totalTasks',
                                                style: GoogleFonts.lato(
                                                  color: HexColor('AAABAB'),
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 3,
                                      width: (completedTasks / totalTasks).isNaN
                                          ? 0
                                          : MediaQuery.of(context).size.width *
                                              completedTasks /
                                              totalTasks,
                                      color: HexColor('00CE15'),
                                    ),
                                    Container(
                                      height: 3,
                                      width: (terminatedTasks / totalTasks)
                                              .isNaN
                                          ? 0
                                          : MediaQuery.of(context).size.width *
                                              terminatedTasks /
                                              totalTasks,
                                      color: HexColor('FF033E'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (workingCategories.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(20),
                                color: Helper.isDark(context)
                                    ? Colors.black
                                    : Colors.white,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Working Categories Pie Chart',
                                        style: GoogleFonts.lato(
                                          color: HexColor('99A4AE'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      PieChart(
                                        dataMap: workingCategories.cast(),
                                        colorList: colorList,
                                        chartValuesOptions:
                                            const ChartValuesOptions(
                                          showChartValueBackground: true,
                                          showChartValues: false,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 0,
                                        ),
                                      )
                                    ]),
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar: const TaskerBottomNavBarWidget(0),
    );
  }
}
