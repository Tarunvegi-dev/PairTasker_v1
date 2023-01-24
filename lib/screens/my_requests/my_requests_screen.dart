import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/screens/my_requests/request_widget.dart';
import 'package:provider/provider.dart';
import '../../theme/widgets.dart';
import '../../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  var _isInit = true;
  List<dynamic> loadedRequests = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final prefs = await SharedPreferences.getInstance();
      final requestPref = prefs.getString('requests');
      Map<String, dynamic> requestsdata =
          jsonDecode(requestPref!) as Map<String, dynamic>;
      if (requestsdata['active'].length > 0) {
        // ignore: use_build_context_synchronously
        final response = await Provider.of<User>(context, listen: false)
            .getMyRequests(active: true);
        setState(() {
          loadedRequests = response['active'];
          loadedRequests.addAll(response['completed']);
        });
        return;
      } else {
        setState(() {
          loadedRequests = requestsdata['active'];
          loadedRequests.addAll(requestsdata['completed']);
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 8 / 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Helper.isDark(context) ? Colors.white : Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text(
                  'My Requests',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (loadedRequests.isEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Helper.isDark(context) ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: const Center(
                    child: Text('No Requests Found!'),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color:
                      HexColor(Helper.isDark(context) ? '252B30' : '#E4ECF5'),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: loadedRequests.length,
                  itemBuilder: (ctx, i) => RequestWidget(
                    requestId: loadedRequests[i]['reqId'],
                    message: loadedRequests[i]['message'],
                    status: loadedRequests[i]['status'],
                    currentTasker: loadedRequests[i]['currentTasker'],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(2),
    );
  }
}
