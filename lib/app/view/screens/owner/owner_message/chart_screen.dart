import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user_1', firstName: "Me");

  @override
  void initState() {
    super.initState();
    // _loadMessages();
  }

  /// ✅ Add new text message to chat
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  /// ✅ Handle sending text messages only
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  /// ✅ Load sample messages from assets
  // void _loadMessages() async {
  //   final response = await rootBundle.loadString('assets/messages.json');
  //   final messages = (jsonDecode(response) as List)
  //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //       .toList();
  //
  //   setState(() {
  //     _messages = messages;
  //   });
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.normalHover,
    appBar: const CustomAppBar(
      appBarContent: AppStrings.messaging,
      iconData: Icons.arrow_back,
    ),
    body: Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      showUserAvatars: true,
      showUserNames: true,
      user: _user,
      theme: DefaultChatTheme(
        inputBackgroundColor: AppColors.orange700,
        inputTextColor: Colors.white,
        primaryColor: AppColors.secondary,
        secondaryColor: Colors.grey[300]!,
      ),
    ),
  );
}
