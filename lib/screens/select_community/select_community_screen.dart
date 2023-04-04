import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:provider/provider.dart';
import 'community_widget.dart';
import 'package:pairtasker/helpers/methods.dart';

class SelectCommunityScreen extends StatefulWidget {
  final isUpdating;

  const SelectCommunityScreen({this.isUpdating, Key? key}) : super(key: key);

  @override
  State<SelectCommunityScreen> createState() => _SelectCommunityScreenState();
}

class _SelectCommunityScreenState extends State<SelectCommunityScreen> {
  String email = '';
  bool _isInit = true;
  List<dynamic> communities = [];
  List<dynamic> filteredCommunities = [];
  final keyword = TextEditingController();
  String selectedCommunityId = '';
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final response =
          await Provider.of<Auth>(context, listen: false).getCommunities();
      setState(() {
        communities = response;
        filteredCommunities = response;
      });
      fetchArguments();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchArguments() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      email = arguments['email'] ?? '';
    });
  }

  void updateCommunity() async {
    setState(() {
      isLoading = true;
    });
    final response = await Provider.of<Auth>(context, listen: false)
        .updateCommunity(selectedCommunityId);
    print(response);
    if (response.statusCode == 200) {
      if (widget.isUpdating) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/userform', arguments: {
        "email": email,
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 8 / 100,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              'Select Community',
              style: GoogleFonts.lato(
                color: HexColor('007fff'),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: keyword,
              onEditingComplete: () {
                final filtered = communities.where(
                  (community) => community['name']
                      .toString()
                      .toLowerCase()
                      .contains(keyword.text.toLowerCase()),
                );
                setState(() {
                  filteredCommunities = filtered.toList();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 12,
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: Helper.isDark(context) ? Colors.white : Colors.black,
                  ),
                ),
                hintText: "Type your Community name",
                hintStyle: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 171, 171, 173),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                filled: true,
                fillColor: const Color.fromARGB(63, 217, 220, 223),
                contentPadding: const EdgeInsets.only(
                  left: 27,
                  top: 13,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredCommunities.length,
                itemBuilder: (context, i) => InkWell(
                  onTap: () {
                    if (selectedCommunityId == filteredCommunities[i]['id']) {
                      setState(() {
                        selectedCommunityId = '';
                      });
                    } else {
                      setState(() {
                        selectedCommunityId = filteredCommunities[i]['id'];
                      });
                    }
                  },
                  child: ApartmentWidget(
                    key: ValueKey(i + 1),
                    isSelected:
                        selectedCommunityId == filteredCommunities[i]['id'],
                    name: filteredCommunities[i]['name'],
                    imageUrl: filteredCommunities[i]['picture'],
                    address: filteredCommunities[i]['address']['line'],
                    city:
                        '${filteredCommunities[i]['address']['city']}, ${filteredCommunities[i]['address']['state']}, ${filteredCommunities[i]['address']['pincode']}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedCommunityId.isNotEmpty
          ? Container(
              margin: const EdgeInsets.only(bottom: 20, right: 5),
              width: MediaQuery.of(context).size.width * 30 / 100,
              height: 50,
              decoration: BoxDecoration(
                color: HexColor('007FFF'),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
                onPressed: isLoading ? null : updateCommunity,
                child: isLoading
                    ? const LoadingSpinner()
                    : Text(
                        'Proceed',
                        style: GoogleFonts.poppins(
                          color: HexColor('FFFFFF'),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            )
          : Container(),
    );
  }
}
