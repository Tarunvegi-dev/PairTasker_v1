import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/home_screen/tasker_widget.dart';
import '../helpers/methods.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final keywordController = TextEditingController();
  final List<dynamic> _workingCategories = [];
  List<dynamic> filteredTaskers = [];

  Future<void> searchTaskers() async {
    final response = await Provider.of<User>(context, listen: false).getTaskers(
      search: true,
      keyword: keywordController.text,
      workingCategories: _workingCategories.join(" "),
    );
    setState(() {
      filteredTaskers = response;
    });
  }

  List<dynamic> selectedTaskers = [];

  void selectTaskers(String id) {
    if (selectedTaskers.contains(id)) {
      setState(() {
        selectedTaskers.remove(id);
      });
    } else {
      setState(() {
        selectedTaskers.add(id);
      });
    }
  }

  void manageWorkingCategories(category) {
    if (_workingCategories.contains(category)) {
      setState(() {
        _workingCategories.remove(category);
      });
    } else {
      setState(() {
        _workingCategories.add(category.toString().trim());
      });
    }
    searchTaskers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 8 / 100,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Helper.isDark(context) ? Colors.white : Colors.black,
                    width: 0.2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: HexColor('99A4AE'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                    onEditingComplete: () => searchTaskers(),
                    controller: keywordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: HexColor('99A4AE'),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () => manageWorkingCategories('Mechanic'),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _workingCategories.contains('Mechanic')
                            ? HexColor('007FFF')
                            : Helper.isDark(context)
                                ? const Color.fromRGBO(255, 255, 255, 0.1)
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Mechanic',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => manageWorkingCategories('deliveryboy'),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: _workingCategories.contains('deliveryboy')
                            ? HexColor('007FFF')
                            : Helper.isDark(context)
                                ? const Color.fromRGBO(255, 255, 255, 0.1)
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Delivery Boy',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => manageWorkingCategories('Photographer'),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: _workingCategories.contains('Photographer')
                            ? HexColor('007FFF')
                            : Helper.isDark(context)
                                ? const Color.fromRGBO(255, 255, 255, 0.1)
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Photographer',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => manageWorkingCategories('Rider'),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: _workingCategories.contains('Rider')
                            ? HexColor('007FFF')
                            : Helper.isDark(context)
                                ? const Color.fromRGBO(255, 255, 255, 0.1)
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Rider',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (filteredTaskers.isEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                color: Helper.isDark(context) ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: const Center(
                  child: Text('No Taskers Found, please try again!'),
                ),
              ),
            Container(
              padding: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('DEE0E0'),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredTaskers.length,
                itemBuilder: (BuildContext context, int i) => TaskerWidget(
                  index: i,
                  username: filteredTaskers[i]['user']['username'],
                  availability: filteredTaskers[i]['availability'],
                  id: filteredTaskers[i]['id'],
                  displayName: filteredTaskers[i]['user']['displayName'],
                  workingCategories: filteredTaskers[i]['workingCategories'],
                  rating: filteredTaskers[i]['rating'].toString(),
                  saves: filteredTaskers[i]['saves'].toString(),
                  tasks: filteredTaskers[i]['totalTasks'].toString(),
                  profilePicture: filteredTaskers[i]['user']['profilePicture'],
                  selectedTaskers: selectedTaskers,
                  isSelected:
                      selectedTaskers.contains(filteredTaskers[i]['id']) !=
                          false,
                  selectTaskers: selectTaskers,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: selectedTaskers.isNotEmpty
          ? Row(
              children: [
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('F2F2F3'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTaskers = [];
                      });
                    },
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: HexColor('99A4AE'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: HexColor('007FFF'),
                    ),
                    onPressed: () => Helper.showRequestModal(
                      context,
                      selectedTaskers,
                    ),
                    child: Text(
                      'Request',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: HexColor('FFFFFF'),
                      ),
                    ),
                  ),
                )
              ],
            )
          : null,
    );
  }
}
