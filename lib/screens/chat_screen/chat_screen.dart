import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/providers/chat.dart';
import 'package:pairtasker/screens/chat_screen/message_widget.dart';
import 'package:pairtasker/screens/chat_screen/view_image.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../helpers/methods.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pairtasker/theme/widgets.dart';
import 'package:pairtasker/theme/theme.dart';

import '../../providers/tasker.dart';
import '../../providers/user.dart';

class ChatScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController msgController = TextEditingController();
  String screenType = '';
  String taskId = '';
  String userId = '';
  String userName = '';
  String reqId = '';
  List<dynamic> pendingTaskers = [];
  List<dynamic> terminatedTaskers = [];
  String reqMessage = '';
  String reqImage = '';
  Map<String, dynamic> currentTasker = {};
  Map<String, dynamic> currentUser = {};
  bool local = true;
  bool remote = false;
  bool _isInit = true;
  String imageURL = '';
  File? image;
  bool _needsScroll = true;
  final ScrollController _scrollController = ScrollController();
  String messageStatus = '';
  int taskStatus = 1;
  var error = '';
  bool isLoading = false;
  bool isTimerEnded = false;
  bool isMessageEmpty = true;
  bool isTerminated = false;

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    socket.emit('iam-offline', taskId);
    setState(() {
      isTimerEnded = true;
    });
    super.dispose();
  }

  void updateIsMessageEmpty() {
    if (msgController.text.isEmpty) {
      setState(() {
        isMessageEmpty = true;
      });
    } else {
      setState(() {
        isMessageEmpty = false;
      });
    }
  }

  void fetchArguments() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      screenType = arguments['screenType'];
      taskId = arguments['taskId'];
    });
  }

  @override
  void didChangeDependencies() {
    fetchArguments();
    if (_isInit) {
      if (screenType == 'user') {
        fetchRequestDetails();
      } else {
        fetchTaskDetails();
      }
      checkUnreadMessages();
      fetchUserData();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    msgController.addListener(() {
      updateIsMessageEmpty();
    });
    socket = IO.io(
      BaseURL.socketURL,
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
    );
    socket.connect();
    socket.on('connect', (data) {
      socket.emit(
        'join-room',
        taskId,
      );
    });
    socket.on('reconnect', (data) => socket.emit('join-room', taskId));
    socket.on(
      'recieved-message',
      (data) => recieveMessage(data),
    );
    socket.on('online', (data) {
      if (local && !remote) {
        socket.emit('iam-online', taskId);
      }
      setState(() {
        remote = true;
      });
    });
    socket.on('message-sent', (data) {
      setState(() {
        messageStatus = 'Sent';
      });
    });
    socket.on('message-seen-ack', (data) {
      setState(() {
        messageStatus = 'Seen';
      });
    });
    socket.on('task-confirmed-ack', (data) => confirmTask(ack: true));
    socket.on('task-completed-ack', (data) => completeTask(ack: true));
    socket.on('tasker-terminated-ack', (data) => terminateTasker(ack: true));
    socket.on('task-withdraw-ack', (data) => withdrawRequest(ack: true));
    socket.on('offline', (data) {
      setState(() {
        remote = false;
      });
    });
    super.initState();
  }

  void checkUnreadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.containsKey('unread-messages')) {
      final pendingPref = prefs.getString('unread-messages');
      Map<String, dynamic> pendingData =
          jsonDecode(pendingPref!) as Map<String, dynamic>;
      if (pendingData[taskId] != null && pendingData[taskId] > 0) {
        socket.emit('message-seen', taskId);
        pendingData[taskId] = 0;
        prefs.setString('unread-messages', jsonEncode(pendingData));
      }
    }
  }

  void recieveMessage(message) async {
    if (message['type'] == 'task-completion') {
      Provider.of<User>(context).getMyRequests();
    }
    // ignore: use_build_context_synchronously
    Provider.of<Chat>(context, listen: false).updateMessages(
      taskId,
      message,
      isRecieve: true,
    );
    setState(() {
      _needsScroll = true;
    });
    socket.emit('message-seen', taskId);
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      userId = userdata['id'];
      userName = userdata['username'];
    });
    // ignore: use_build_context_synchronously
    Provider.of<Chat>(context, listen: false).fetchMessages(
      taskId,
      screenType,
    );
  }

  void fetchRequestDetails() async {
    final response = await Provider.of<Chat>(context, listen: false)
        .getRequestDetails(taskId);
    final responsedata = response.data['data']['request'];
    if (response.statusCode == 200) {
      setState(() {
        reqId = responsedata['reqId'];
        pendingTaskers = responsedata['pending'];
        terminatedTaskers = responsedata['terminated'];
        reqMessage = responsedata['message'];
        reqImage = responsedata['image'] ?? '';
        currentTasker = responsedata['currentTasker'] ?? {};
        taskStatus = int.parse(responsedata['status']);
      });
    }
  }

  void fetchTaskDetails() async {
    final response =
        await Provider.of<Chat>(context, listen: false).getTaskDetails(taskId);
    final responsedata = response.data['data']['request'];
    if (response.statusCode == 200) {
      setState(() {
        reqId = responsedata['reqId'];
        reqMessage = responsedata['message'];
        currentUser = responsedata['user'];
        taskStatus = int.parse(responsedata['status']);
        isTerminated = responsedata['terminated'];
      });
    }
  }

  Future<void> sendMessage(String message, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    Map<String, dynamic> data = {
      "type": type,
      "text": message,
      "sender": userId,
      "reciever": screenType == 'user' && currentTasker.isEmpty
          ? userId
          : screenType == 'tasker' && currentUser.isEmpty
              ? userId
              : screenType == 'user'
                  ? currentTasker['id'].toString()
                  : currentUser['id'].toString(),
      "timestamp": '${DateTime.now()}',
      "image": imageURL,
      "sentBy": {"username": userdata['username']}.toString(),
      "taskId": taskId,
      "screenType": screenType
    };
    if (type == 'prompt') {
      data = {...data, "text": '${userdata['username']} ${data['text']}'};
    }
    final notification = {
      "title": userdata['displayName'],
      "body": imageURL.isNotEmpty ? 'Photo' : message,
      "tag": taskId
    };
    socket.emit('send-message', {
      "data": data,
      "room": taskId,
      "fcmId": screenType == 'user'
          ? currentTasker['deviceId']
          : currentUser['deviceId'],
      "notification": notification,
    });
    // ignore: use_build_context_synchronously
    Provider.of<Chat>(context, listen: false).updateMessages(
      taskId,
      data,
    );
    setState(() {
      msgController.text = '';
      imageURL = '';
      image = null;
      _needsScroll = true;
    });
  }

  Future<void> _takePicture(ImageSource source) async {
    Navigator.of(context).pop();
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );
    // ignore: unnecessary_null_comparison
    if (imageFile == null) {
      return;
    }
    File tempFile = File(imageFile.path);
    // ignore: use_build_context_synchronously
    await Provider.of<Auth>(context, listen: false)
        .uploadImage(tempFile)
        .then((res) {
      setState(() {
        imageURL = res;
        image = tempFile;
      });
      sendMessage('', 'message');
    });
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 50,
    );
    return result;
  }

  void confirmTask({bool ack = false}) async {
    if (!ack) {
      final res =
          await Provider.of<User>(context, listen: false).confirmTask(taskId);
      if (res.statusCode == 200) {
        sendMessage('Task confirmed', 'task-confirmation');
        socket.emit('task-confirmed', taskId);
      }
    }
    setState(() {
      taskStatus = 2;
    });
  }

  void cancelTaskRequest({bool ack = false}) async {
    if (!ack) {
      sendMessage('Task confirmation cancelled', 'info');
    }
  }

  void completeTask({bool ack = false}) async {
    if (!ack) {
      sendMessage('Task Completed', 'task-completion');
      socket.emit('task-completed', taskId);
      Provider.of<Tasker>(context, listen: false).getMyTasks();
    }
    setState(() {
      taskStatus = 3;
    });
  }

  void terminateTasker({bool ack = false, String taskerId = ''}) async {
    if (!ack) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        showCancelBtn: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        title: screenType == 'user'
            ? 'Are you sure want to terminate ${currentTasker['username']}'
            : 'Are you sure want to terminate from task?',
        onConfirmBtnTap: () async {
          final res =
              await Provider.of<Tasker>(context, listen: false).terminateTask(
            taskId,
            taskerId,
          );
          if (res.statusCode == 200) {
            if (taskerId.isEmpty) {
              sendMessage('Tasker terminated', 'tasker-terminated');
              socket.emit('tasker-terminated', taskId);
            } else {
              sendMessage(
                '$userName terminated ${currentTasker['username']}',
                'tasker-terminated',
              );
              socket.emit('tasker-terminated', taskId);
            }
            updateTerminatedStatus();
          }
        },
      );
    } else {
      updateTerminatedStatus();
    }
  }

  void updateTerminatedStatus() {
    if (screenType == 'user') {
      setState(() {
        taskStatus = 0;
      });
    } else {
      setState(() {
        taskStatus = 0;
        Provider.of<Tasker>(context, listen: false).getMyTasks();
      });
    }
  }

  void withdrawRequest({bool ack = false}) async {
    if (!ack) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          showCancelBtn: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textTextStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: HexColor('FF0338'),
          ),
          title: 'Are you sure want to withdraw request?',
          text:
              'confirming this action will remove the notification from all the requested taskers',
          onConfirmBtnTap: () async {
            final res = await Provider.of<User>(context, listen: false)
                .withdrawRequest(taskId);
            if (res.statusCode == 200) {
              sendMessage('Task has been withdrawn', 'task-cancellation');
              // ignore: use_build_context_synchronously
              Provider.of<User>(context, listen: false).getMyRequests();
              socket.emit('task-withdraw', taskId);
              setState(() {
                taskStatus = -1;
              });
            }
          });
    } else {
      setState(() {
        taskStatus = -1;
      });
    }
  }

  GlobalKey<ScaffoldState> key = GlobalKey();

  void showStatus() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Helper.isDark(context) ? Colors.black : Colors.white,
        child: Wrap(
          children: [
            if (pendingTaskers.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('E4ECF5'),
                child: ListView.builder(
                  itemCount: pendingTaskers.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, i) => Container(
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  pendingTaskers[i]['profilePicture'] != null
                                      ? NetworkImage(
                                          pendingTaskers[i]['profilePicture'],
                                        )
                                      : const AssetImage(
                                          'assets/images/default_user.png',
                                        ) as ImageProvider,
                            ),
                            Text(
                              '@${pendingTaskers[i]['username']}',
                              style: GoogleFonts.lato(
                                color: HexColor('AAABAB'),
                              ),
                            ),
                            Text(
                              'pending',
                              style: GoogleFonts.lato(
                                color: HexColor('007FFF'),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            if (terminatedTaskers.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('E4ECF5'),
                child: ListView.builder(
                  itemCount: terminatedTaskers.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, i) => Container(
                        margin: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  terminatedTaskers[i]['profilePicture'] != null
                                      ? NetworkImage(
                                          terminatedTaskers[i]
                                              ['profilePicture'],
                                        )
                                      : const AssetImage(
                                          'assets/images/default_user.png',
                                        ) as ImageProvider,
                            ),
                            Text(
                              '@${terminatedTaskers[i]['username']}',
                              style: GoogleFonts.lato(),
                            ),
                            Text(
                              'terminated',
                              style: GoogleFonts.lato(
                                color: HexColor('FF033E'),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    List<dynamic> loadedMessages = [];
    loadedMessages = Provider.of<Chat>(context).messages;
    bool showKeyBoard() {
      if (taskStatus == 1) {
        if (loadedMessages.isNotEmpty) {
          if (loadedMessages.last['type'] == 'prompt') {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      }
      return false;
    }

    bool showPrompt() {
      if (loadedMessages.isNotEmpty) {
        if (loadedMessages.last['type'] == 'prompt' && screenType == 'user') {
          return true;
        }
      }
      return false;
    }

    return Scaffold(
      backgroundColor: Helper.isDark(context) ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Helper.isDark(context) ? Colors.white : Colors.black,
                    width: 0.2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      if (screenType == 'user')
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reqId,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (currentTasker.isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        '${currentTasker['username']}',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: HexColor('#AAABAB'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Container(
                                          width: 3.0,
                                          height: 3.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('AAABAB'),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        remote ? 'Online' : 'Offline',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: HexColor('#AAABAB'),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ],
                        ),
                      if (screenType == 'tasker')
                        Row(
                          children: [
                            SizedBox(
                              width: 42,
                              height: 42,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    currentUser['profilePicture'] != null
                                        ? NetworkImage(
                                            currentUser['profilePicture'],
                                          )
                                        : const AssetImage(
                                            'assets/images/default_user.png',
                                          ) as ImageProvider,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentUser['displayName'] ?? '',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  remote ? 'Online' : 'Offline',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: HexColor('#AAABAB'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                  PopupMenuButton(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      itemBuilder: (_) => [
                            if (screenType == 'tasker' &&
                                taskStatus < 2 &&
                                !isTerminated)
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => terminateTasker(),
                                  );
                                },
                                child: Text(
                                  'Terminate',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (screenType == 'user' &&
                                taskStatus >= 0 &&
                                taskStatus < 2)
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                    const Duration(
                                      seconds: 0,
                                    ),
                                    () => withdrawRequest(),
                                  );
                                },
                                child: Text(
                                  'Withdraw request',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (screenType == 'user' &&
                                taskStatus < 2 &&
                                taskStatus > 0 &&
                                currentTasker.isNotEmpty)
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => terminateTasker(
                                      taskerId: currentTasker['id'],
                                    ),
                                  );
                                },
                                child: Text(
                                  'Terminate ${currentTasker['username']}',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (screenType == 'user' &&
                                taskStatus == 1 &&
                                currentTasker.isNotEmpty)
                              PopupMenuItem(
                                onTap: confirmTask,
                                child: Text(
                                  'Confirm task',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (taskStatus > 0)
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => Helper.showReportModal(
                                      context,
                                      screenType == 'user'
                                          ? currentTasker['id']
                                          : currentUser['id'],
                                      userId,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.report),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Report',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ])
                ],
              ),
            ),
            if (screenType == 'user' &&
                (pendingTaskers.isNotEmpty || terminatedTaskers.isNotEmpty))
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                color: Helper.isDark(context)
                    ? HexColor('252B30')
                    : HexColor('E4ECF5'),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [...pendingTaskers, ...terminatedTaskers]
                              .map((tasker) {
                            var taskers = [
                              ...pendingTaskers,
                              ...terminatedTaskers
                            ];
                            var index = taskers.indexOf(tasker);
                            return Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? 0 : index + 18,
                              ),
                              // left: index+10,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundImage:
                                    tasker['profilePicture'] != null
                                        ? NetworkImage(tasker['profilePicture'])
                                        : const AssetImage(
                                            'assets/images/default_user.png',
                                          ) as ImageProvider,
                              ),
                            );
                          }).toList(),
                        ),
                        InkWell(
                            onTap: () {
                              showStatus();
                            },
                            child: Text(
                              'view status',
                              style: GoogleFonts.poppins(
                                color: HexColor('007FFF'),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 8,
                bottom: 12,
              ),
              margin: const EdgeInsets.only(
                top: 5,
              ),
              color: Helper.isDark(context)
                  ? HexColor('252B30')
                  : HexColor('E4ECF5'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requested message',
                    style: GoogleFonts.poppins(
                      color: HexColor('007FFF'),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ReadMoreText(
                    reqMessage,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'more',
                    trimExpandedText: 'less',
                    style: GoogleFonts.lato(
                      color: HexColor('6F7273'),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    moreStyle: GoogleFonts.lato(
                      color: HexColor('007FFF'),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    lessStyle: GoogleFonts.lato(
                      color: HexColor('007FFF'),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (reqImage.toString().isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  if (reqImage.toString().isNotEmpty)
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewImage(
                            Image: reqImage,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            reqImage,
                            height: 30,
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: SvgPicture.asset(
                              'assets/images/image.svg',
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: loadedMessages.length,
                itemBuilder: (BuildContext context, int i) => loadedMessages[i]
                                ['type'] ==
                            'task-completion' ||
                        loadedMessages[i]['type'] == 'task-confirmation' ||
                        loadedMessages[i]['type'] == 'task-cancellation'
                    ? TaskMessage(
                        message: '${loadedMessages[i]['text']}',
                        type: loadedMessages[i]['type'],
                      )
                    : loadedMessages[i]['type'] == 'info' ||
                            loadedMessages[i]['type'] == 'tasker-terminated'
                        ? InfoMessage(
                            message: '${loadedMessages[i]['text']}',
                          )
                        : loadedMessages[i]['sender'] == userId
                            ? OutgoingMessage(
                                isPrompt: loadedMessages[i]['type'] == 'prompt',
                                message: loadedMessages[i]['text'],
                                timestamp: loadedMessages[i]['timestamp'],
                                msgStatus: messageStatus,
                                showMsgStatus: messageStatus.isNotEmpty &&
                                    loadedMessages.last['sender'] == userId &&
                                    loadedMessages.last['type'] == 'message' &&
                                    i == loadedMessages.length - 1,
                                image: loadedMessages[i]['image']
                                        .toString()
                                        .isNotEmpty
                                    ? loadedMessages[i]['image']
                                    : '',
                              )
                            : IncomingMessage(
                                senderImage: currentTasker['profilePicture'],
                                message: loadedMessages[i]['text'],
                                isPrompt: loadedMessages[i]['type'] == 'prompt',
                                screenType: screenType,
                                timestamp: loadedMessages[i]['timestamp'],
                                sender: loadedMessages[i]['sentBy']
                                    .toString()
                                    .substring(10)
                                    .replaceAll(
                                      '}',
                                      '',
                                    ),
                                image: loadedMessages[i]['image']
                                        .toString()
                                        .isNotEmpty
                                    ? loadedMessages[i]['image']
                                    : '',
                              ),
              ),
            ),
            if (showKeyBoard())
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Helper.isDark(context) ? Colors.black : Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 5 / 100,
                              maxHeight: MediaQuery.of(context).size.height *
                                  15 /
                                  100),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Helper.isDark(context)
                                  ? HexColor('FFFFFF')
                                  : HexColor('E4ECF5'),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.only(
                              left: 25,
                              top: 10,
                            ),
                            child: TextField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.lato(
                                color: HexColor('252B30'),
                              ),
                              onTap: () {
                                setState(() {
                                  _needsScroll = true;
                                });
                                _scrollToEnd();
                              },
                              onTapOutside: (value) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              controller: msgController,
                              decoration: InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintText: "Type....",
                                hintStyle: GoogleFonts.lato(
                                  color: Helper.isDark(context)
                                      ? HexColor('252B30')
                                      : HexColor('AAABAB'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (screenType == 'user')
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () =>
                                    Helper.selectSource(_takePicture, context),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Helper.isDark(context)
                                        ? HexColor('FFFFFF')
                                        : HexColor('E4ECF5'),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Helper.isDark(context)
                                        ? HexColor('252B30')
                                        : HexColor('AAABAB'),
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () =>
                                    sendMessage(msgController.text, 'message'),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 3,
                                    bottom: 3,
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    size: 38,
                                    color: HexColor('007FFF'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (screenType == 'tasker')
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!isMessageEmpty)
                                InkWell(
                                  onTap: () => sendMessage(
                                      msgController.text, 'message'),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 3,
                                      bottom: 3,
                                    ),
                                    child: Icon(
                                      Icons.send,
                                      size: 38,
                                      color: HexColor('007FFF'),
                                    ),
                                  ),
                                ),
                              if (isMessageEmpty)
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Helper.selectSource(
                                          _takePicture, context),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Helper.isDark(context)
                                              ? HexColor('FFFFFF')
                                              : HexColor('E4ECF5'),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Helper.isDark(context)
                                              ? HexColor('252B30')
                                              : HexColor('AAABAB'),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    PopupMenuButton(
                                      padding: const EdgeInsets.all(0),
                                      // color:
                                      //     Helper.isDark(context) ? Colors.black : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Helper.isDark(context)
                                              ? HexColor('FFFFFF')
                                              : HexColor('E4ECF5'),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        margin: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: Icon(
                                          Icons.more_horiz,
                                          size: 30,
                                          color: Helper.isDark(context)
                                              ? HexColor('252B30')
                                              : HexColor('AAABAB'),
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem<int>(
                                          onTap: () => sendMessage(
                                            'wants you to confirm the order?',
                                            'prompt',
                                          ),
                                          child: Text(
                                            'Request confirmation',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            if (showPrompt())
              Row(
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
                      onPressed: cancelTaskRequest,
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
                      onPressed: confirmTask,
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HexColor('FFFFFF'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            if (taskStatus == 3 && screenType == 'user')
              Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                  top: 15,
                ),
                width: MediaQuery.of(context).size.width * 90 / 100,
                height: 43,
                child: ElevatedButton(
                  onPressed: () =>
                      Helper.showAddReviewModal(context, currentTasker['id']),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Give Feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (taskStatus == 2 && screenType == 'tasker')
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                width: MediaQuery.of(context).size.width * 90 / 100,
                height: 43,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          final res = await Provider.of<Tasker>(
                            context,
                            listen: false,
                          ).completeTask(taskId);
                          if (res.statusCode == 200) {
                            setState(() {
                              isLoading = false;
                            });
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: (context),
                                builder: (context) {
                                  return BottomSheet(
                                      onClosing: () {},
                                      builder: (context) {
                                        String otp = '';
                                        var errorMessage = '';
                                        bool isVerifying = false;
                                        bool isTimerEnded = false;
                                        return StatefulBuilder(
                                          builder: (context, setState) =>
                                              Container(
                                            color: Helper.isDark(context)
                                                ? Colors.black
                                                : Colors.white,
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 40,
                                                horizontal: 20,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Enter Task Confirmation OTP',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'OTP has been sent to the user\'s registered email, please enter it to complete the task',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                    ),
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          otp = value;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Enter Valid OTP';
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 28,
                                                        letterSpacing: 4,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(10),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: HexColor(
                                                              'AAABAB',
                                                            ),
                                                          ),
                                                        ),
                                                        hintText: "CODE",
                                                      ),
                                                    ),
                                                  ),
                                                  if (errorMessage != '')
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        ErrorMessage(
                                                          errorMessage,
                                                        )
                                                      ],
                                                    ),
                                                  if (isTimerEnded)
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          final res =
                                                              await Provider.of<
                                                                  Tasker>(
                                                            context,
                                                            listen: false,
                                                          ).completeTask(
                                                            taskId,
                                                          );
                                                          if (res.statusCode ==
                                                              200) {
                                                            setState(() {
                                                              isTimerEnded =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          'Resend OTP',
                                                          style: TextStyle(
                                                            color: HexColor(
                                                              '007FFF',
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (!isTimerEnded)
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Resend Code:',
                                                              style: GoogleFonts
                                                                  .lato(
                                                                color: HexColor(
                                                                    '#AAABAB'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            CountdownTimer(
                                                              endTime: DateTime
                                                                          .now()
                                                                      .millisecondsSinceEpoch +
                                                                  1000 * 60,
                                                              onEnd: () {
                                                                setState(() {
                                                                  isTimerEnded =
                                                                      true;
                                                                });
                                                              },
                                                              textStyle:
                                                                  GoogleFonts
                                                                      .lato(
                                                                color: HexColor(
                                                                    'FF033E'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            90 /
                                                            100,
                                                    height: 43,
                                                    child: ElevatedButton(
                                                      onPressed: isVerifying
                                                          ? null
                                                          : () async {
                                                              if (otp.isEmpty) {
                                                                setState(() {
                                                                  errorMessage =
                                                                      'Enter valid OTP';
                                                                });
                                                                return;
                                                              }
                                                              setState(() {
                                                                isVerifying =
                                                                    true;
                                                              });
                                                              final res =
                                                                  await Provider
                                                                      .of<Tasker>(
                                                                context,
                                                                listen: false,
                                                              ).verifyTaskOTP(
                                                                taskId,
                                                                otp,
                                                              );
                                                              if (res.statusCode ==
                                                                  200) {
                                                                completeTask();
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } else {
                                                                setState(() {
                                                                  errorMessage =
                                                                      res.data[
                                                                          'message'];
                                                                  isVerifying =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            HexColor('007FFF'),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                        ),
                                                      ),
                                                      child: isVerifying
                                                          ? const LoadingSpinner()
                                                          : Text(
                                                              'Verify',
                                                              style:
                                                                  PairTaskerTheme
                                                                      .buttonText,
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        Helper.isDark(context) ? Colors.black : Colors.white,
                  ),
                  child: isLoading
                      ? const LoadingSpinner()
                      : Text(
                          'Verify user to complete the task',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: HexColor('007FFF'),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
