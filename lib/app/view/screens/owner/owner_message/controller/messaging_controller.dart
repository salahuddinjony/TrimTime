// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
// class MessagingController extends GetxController {
//   /// ✅ Observable list for chat messages
//   var messages = <types.Message>[].obs;
//
//   final types.User currentUser = const types.User(id: 'user_1', firstName: "Me");
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadMessages();
//   }
//
//   /// ✅ Add a new message to chat
//   void addMessage(types.Message message) {
//     messages.insert(0, message);
//   }
//
//   /// ✅ Handle sending text messages
//   void handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: currentUser,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );
//
//     addMessage(textMessage);
//   }
//
//   /// ✅ Load sample messages from assets
//   Future<void> loadMessages() async {
//     final response = await rootBundle.loadString('assets/messages.json');
//     final decodedMessages = (jsonDecode(response) as List)
//         .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//         .toList();
//     messages.assignAll(decodedMessages);
//   }
//
//   /// ✅ Show Attachment Options (Image & File)
//   void showAttachmentOptions() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         height: 180,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo, color: Colors.blue),
//               title: const Text('Send Image'),
//               onTap: () {
//                 Get.back();
//                 handleImageSelection();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.attach_file, color: Colors.green),
//               title: const Text('Send File'),
//               onTap: () {
//                 Get.back();
//                 handleFileSelection();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.close, color: Colors.red),
//               title: const Text('Cancel'),
//               onTap: () => Get.back(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ✅ Select & Send Image
//   Future<void> handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//
//       final message = types.ImageMessage(
//         author: currentUser,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );
//
//       addMessage(message);
//     }
//   }
//
//   /// ✅ Select & Send File
//   Future<void> handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.any);
//
//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: currentUser,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(result.files.single.path!),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );
//
//       addMessage(message);
//     }
//   }
//
//   /// ✅ Open File on Click
//   Future<void> handleMessageTap(types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final request = await http.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             await File(localPath).writeAsBytes(bytes);
//           }
//         } catch (_) {}
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   @override
//   void onClose() {
//     messages.clear();
//     super.onClose();
//   }
// }
