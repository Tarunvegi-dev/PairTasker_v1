import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pairtasker/providers/auth.dart';
import 'package:pairtasker/providers/chat.dart';
import 'package:pairtasker/screens/chat_screen/message_widget.dart';
import 'package:provider/provider.dart';
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
  final screenType;
  final taskId;

  const ChatScreen({this.screenType, this.taskId, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController msgController = TextEditingController();
  String userId = '';
  String reqId = '';
  List<dynamic> pendingTaskers = [];
  List<dynamic> terminatedTaskers = [];
  String reqMessage = '';
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
  bool viewStatus = false;

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    socket.emit('iam-offline', widget.taskId);
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

  @override
  void initState() {
    msgController.addListener(() {
      updateIsMessageEmpty();
    });
    if (_isInit) {
      if (widget.screenType == 'user') {
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
    socket = IO.io(
      BaseURL.socketURL,
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
    );
    socket.connect();
    socket.on('connect', (data) {
      socket.emit(
        'join-room',
        widget.taskId,
      );
    });
    socket.on('reconnect', (data) => socket.emit('join-room', widget.taskId));
    socket.on(
      'recieved-message',
      (data) => recieveMessage(data),
    );
    socket.on('online', (data) {
      if (local && !remote) {
        socket.emit('iam-online', widget.taskId);
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
      if (pendingData[widget.taskId] != null &&
          pendingData[widget.taskId] > 0) {
        socket.emit('message-seen', widget.taskId);
        pendingData[widget.taskId] = 0;
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
      widget.taskId,
      message,
      isRecieve: true,
    );
    setState(() {
      _needsScroll = true;
    });
    socket.emit('message-seen', widget.taskId);
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      userId = userdata['id'];
    });
    // ignore: use_build_context_synchronously
    Provider.of<Chat>(context, listen: false).fetchMessages(
      widget.taskId,
      widget.screenType,
    );
  }

  void fetchRequestDetails() async {
    final response = await Provider.of<Chat>(context, listen: false)
        .getRequestDetails(widget.taskId);
    final responsedata = response.data['data']['request'];
    if (response.statusCode == 200) {
      setState(() {
        reqId = responsedata['reqId'];
        pendingTaskers = responsedata['pending'];
        terminatedTaskers = responsedata['terminated'];
        reqMessage = responsedata['message'];
        currentTasker = responsedata['currentTasker'] ?? {};
        taskStatus = int.parse(responsedata['status']);
      });
    }
  }

  void fetchTaskDetails() async {
    final response = await Provider.of<Chat>(context, listen: false)
        .getTaskDetails(widget.taskId);
    final responsedata = response.data['data']['request'];
    if (response.statusCode == 200) {
      setState(() {
        reqId = responsedata['reqId'];
        reqMessage = responsedata['message'];
        currentUser = responsedata['user'];
        taskStatus = int.parse(responsedata['status']);
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
      "reciever":
          widget.screenType == 'user' ? currentTasker['id'] : currentUser['id'],
      "timestamp": '${DateTime.now()}',
      "image": imageURL,
      "sentBy": {"username": userdata['username']}.toString(),
      "taskId": widget.taskId,
    };
    if (type == 'prompt') {
      data = {...data, "text": '${userdata['username']} ${data['text']}'};
    }

    final notification = {
      "title": userdata['displayName'],
      "body": imageURL.isNotEmpty ? 'Photo' : message,
    };
    socket.emit('send-message', {
      "data": data,
      "room": widget.taskId,
      "fcmId": widget.screenType == 'user'
          ? currentTasker['deviceId']
          : currentUser['deviceId'],
      "notification": notification,
    });
    // ignore: use_build_context_synchronously
    Provider.of<Chat>(context, listen: false).updateMessages(
      widget.taskId,
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
      final res = await Provider.of<User>(context, listen: false)
          .confirmTask(widget.taskId);
      if (res.statusCode == 200) {
        sendMessage('Task confirmed', 'task-confirmation');
        socket.emit('task-confirmed', widget.taskId);
      }
    }
    setState(() {
      taskStatus = 2;
    });
  }

  void cancelTaskRequest({bool ack = false}) async {
    if (!ack) {
      sendMessage('Task request cancelled', 'info');
    }
  }

  void completeTask({bool ack = false}) async {
    if (!ack) {
      sendMessage('Task Completed', 'task-completion');
      socket.emit('task-completed', widget.taskId);
      Provider.of<Tasker>(context, listen: false).getMyTasks();
    }
    setState(() {
      taskStatus = 3;
    });
  }

  void terminateTasker({bool ack = false}) async {
    if (!ack) {
      final res = await Provider.of<Tasker>(context, listen: false)
          .terminateTask(widget.taskId);
      if (res.statusCode == 200) {
        sendMessage('Tasker terminated', 'info');
        // ignore: use_build_context_synchronously
        Provider.of<Tasker>(context, listen: false).getMyTasks();
        socket.emit('tasker-terminated', widget.taskId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }
    setState(() {
      taskStatus = 0;
      currentTasker = {};
    });
  }

  void withdrawRequest({bool ack = false}) async {
    if (!ack) {
      final res = await Provider.of<User>(context, listen: false)
          .withdrawRequest(widget.taskId);
      if (res.statusCode == 200) {
        sendMessage('Task has been withdrawn', 'task-cancellation');
        // ignore: use_build_context_synchronously
        Provider.of<User>(context, listen: false).getMyRequests();
        socket.emit('task-withdraw', widget.taskId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }
    setState(() {
      taskStatus = -1;
    });
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
        if (loadedMessages.last['type'] == 'prompt' &&
            widget.screenType == 'user') {
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
                      if (widget.screenType == 'user')
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
                      if (widget.screenType == 'tasker')
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
                      itemBuilder: (_) => [
                            if (widget.screenType == 'tasker' && taskStatus < 2)
                              PopupMenuItem(
                                onTap: terminateTasker,
                                child: const Text('Terminate'),
                              ),
                            if (widget.screenType == 'user' && taskStatus < 2)
                              PopupMenuItem(
                                onTap: withdrawRequest,
                                child: const Text('Withdraw request'),
                              ),
                            PopupMenuItem(
                              onTap: () {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => Helper.showReportModal(
                                    context,
                                    widget.screenType == 'user'
                                        ? currentTasker['id']
                                        : currentUser['id'],
                                    userId,
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.report),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Report')
                                ],
                              ),
                            ),
                          ])
                ],
              ),
            ),
            if (widget.screenType == 'user' &&
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
                      mainAxisAlignment: viewStatus
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (!viewStatus)
                          SizedBox(
                            width: 80,
                            child: Row(
                              children:
                                  [...pendingTaskers, ...terminatedTaskers]
                                      .map(
                                        (tasker) => CircleAvatar(
                                          radius: 13,
                                          backgroundImage:
                                              tasker['profilePicture'] != null
                                                  ? NetworkImage(
                                                      tasker['profilePicture'])
                                                  : const AssetImage(
                                                      'assets/images/default_user.png',
                                                    ) as ImageProvider,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              viewStatus = !viewStatus;
                            });
                          },
                          child: Icon(
                            viewStatus
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            // style: GoogleFonts.poppins(
                            //   color: HexColor('007FFF'),
                            //   fontSize: 12,
                            //   fontWeight: FontWeight.w500,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (viewStatus && widget.screenType == 'user')
              AnimatedContainer(
                duration: const Duration(
                  seconds: 3,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      color:
                          Helper.isDark(context) ? Colors.black : Colors.white,
                      child: ListView.builder(
                        itemCount: pendingTaskers.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, i) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: pendingTaskers[i]
                                              ['profilePicture'] !=
                                          null
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
                            )),
                      ),
                    ),
                    Container(
                      color: Helper.isDark(context)
                          ? HexColor('252B30')
                          : HexColor('E4ECF5'),
                      child: ListView.builder(
                        itemCount: terminatedTaskers.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, i) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: terminatedTaskers[i]
                                              ['profilePicture'] !=
                                          null
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
                                  style: GoogleFonts.lato(
                                    color: HexColor('AAABAB'),
                                  ),
                                ),
                                Text(
                                  'terminated',
                                  style: GoogleFonts.lato(
                                    color: HexColor('FF033E'),
                                  ),
                                )
                              ],
                            )),
                      ),
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
                  Text(
                    reqMessage,
                    style: GoogleFonts.lato(
                      color: HexColor('6F7273'),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
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
                            'info' ||
                        loadedMessages[i]['type'] == 'task-completion' ||
                        loadedMessages[i]['type'] == 'task-confirmation' ||
                        loadedMessages[i]['type'] == 'task-cancellation'
                    ? InfoMessage(
                        message: '${loadedMessages[i]['text']}',
                      )
                    : loadedMessages[i]['sender'] == userId
                        ? OutgoingMessage(
                            message: loadedMessages[i]['text'],
                            timestamp: loadedMessages[i]['timestamp'],
                            msgStatus: messageStatus,
                            showMsgStatus: messageStatus.isNotEmpty &&
                                loadedMessages.last['sender'] == userId &&
                                loadedMessages.last['type'] == 'message' &&
                                i == loadedMessages.length - 1,
                            image:
                                loadedMessages[i]['image'].toString().isNotEmpty
                                    ? loadedMessages[i]['image']
                                    : '',
                          )
                        : IncomingMessage(
                            message: loadedMessages[i]['text'],
                            screenType: widget.screenType,
                            timestamp: loadedMessages[i]['timestamp'],
                            sender: loadedMessages[i]['sentBy']
                                .toString()
                                .substring(10)
                                .replaceAll(
                                  '}',
                                  '',
                                ),
                            image:
                                loadedMessages[i]['image'].toString().isNotEmpty
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: widget.screenType == 'user'
                            ? MediaQuery.of(context).size.width * 68 / 100
                            : isMessageEmpty
                                ? MediaQuery.of(context).size.width * 64 / 100
                                : MediaQuery.of(context).size.width * 74 / 100,
                        height: MediaQuery.of(context).size.height * 5 / 100,
                        decoration: BoxDecoration(
                          color: Helper.isDark(context)
                              ? HexColor('FFFFFF')
                              : HexColor('E4ECF5'),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: TextField(
                          maxLines: 8,
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
                      const SizedBox(
                        width: 8,
                      ),
                      if (widget.screenType == 'user')
                        Expanded(
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
                                    color: HexColor('AAABAB'),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: HexColor('000000'),
                                    size: 28,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    sendMessage(msgController.text, 'message'),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 4,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: HexColor('007FFF'),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 3),
                                    child: const Icon(
                                      Icons.send,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (widget.screenType == 'tasker')
                        Expanded(
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
                                      left: 4,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: HexColor('007FFF'),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 3),
                                      child: const Icon(
                                        Icons.send,
                                        size: 28,
                                      ),
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
                                          color: HexColor('AAABAB'),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: HexColor('000000'),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: HexColor('AAABAB'),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        margin: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: const Icon(
                                          Icons.more_horiz,
                                          size: 28,
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem<int>(
                                          onTap: () => sendMessage(
                                            'wants you to confirm the order?',
                                            'prompt',
                                          ),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.add),
                                              Text(
                                                'Request confirmation',
                                              ),
                                            ],
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
            if (taskStatus == 3 && widget.screenType == 'user')
              Container(
                margin: const EdgeInsets.only(bottom: 10),
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
            if (taskStatus == 2 && widget.screenType == 'tasker')
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
                          ).completeTask(widget.taskId);
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
                                                            widget.taskId,
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
                                                                widget.taskId,
                                                                otp,
                                                              );
                                                              if (res.statusCode ==
                                                                  200) {
                                                                completeTask();
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
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
                    backgroundColor: HexColor('#32DE84'),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  child: isLoading
                      ? const LoadingSpinner()
                      : Text(
                          'Task Done',
                          style: PairTaskerTheme.buttonText,
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
