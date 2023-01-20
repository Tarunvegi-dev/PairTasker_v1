import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/screens/my_requests/request_widget.dart';
import '../../theme/widgets.dart';
import '../../helpers/methods.dart';
import 'package:provider/provider.dart';
import 'package:pairtasker/providers/user.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<User>(context).getMyRequests().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final requestsdata = Provider.of<User>(context);
    final loadedRequests = requestsdata.requests;
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
