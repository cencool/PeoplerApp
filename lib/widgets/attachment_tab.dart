import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_attachment.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

enum AttachmentTabMode { view, edit, add }

class AttachmentTab extends StatefulWidget {
  const AttachmentTab({super.key});

  @override
  State<AttachmentTab> createState() => _AttachmentTabState();
}

class _AttachmentTabState extends State<AttachmentTab> {
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late Future<List<PersonAttachment>> attachmentList =
      activePerson.getAttachmentList(id: activePerson.id, messengerKey: messengerKey);
  late Person activePerson = context.read<AppState>().activePerson;
  int activeAttachmentId = -1;
  dynamic imageFromFile;
  String imageFilePath = '';

  AttachmentTabMode attachmentTabMode = AttachmentTabMode.view;

  void switchMode(AttachmentTabMode newMode, int itemId) {
    setState(() {
      activeAttachmentId = itemId;
      attachmentTabMode = newMode;
      attachmentList =
          activePerson.getAttachmentList(id: activePerson.id, messengerKey: messengerKey);
    });
  }

  void showImageFromfile(Image uploadedImage) {
    setState(() {
      imageFromFile = uploadedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (attachmentTabMode) {
      case (AttachmentTabMode.view):
        return FutureBuilder(
            future: attachmentList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String authString = context.read<AppState>().authString;
                List<Widget> attachmentFiles = [];
                for (final item in snapshot.data!) {
                  attachmentFiles.add(

                      //TODO change to caption only
                      Text('${item.id},${item.personId},${item.fileCaption},${item.fileName}'));
                  attachmentFiles.add(
                    Stack(
                      children: [
                        InstaImageViewer(
                          imageUrl:
                              '${Api.attachmentUrl}/send-file?fileId=${item.id}&${DateTime.now().millisecondsSinceEpoch}',
                          headers: {'Authorization': 'Basic $authString'},
                          // child: Text('CHILD'),
                          child: Image(
                            key: ValueKey(
                                '${Api.attachmentUrl}/send-thumbnail?fileId=${item.id}&${DateTime.now().millisecondsSinceEpoch}'),
                            image: NetworkImage(
                              '${Api.attachmentUrl}/send-thumbnail?fileId=${item.id}&${DateTime.now().millisecondsSinceEpoch}',
                              headers: {'Authorization': 'Basic $authString'},
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              switchMode(AttachmentTabMode.edit, item.id);
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),
                  );
                }
                if (attachmentFiles.isNotEmpty) {
                  return Stack(children: [
                    ListView(children: attachmentFiles),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          onPressed: () {
                            switchMode(AttachmentTabMode.add, -1);
                          },
                          child: Icon(Icons.add)),
                    )
                  ]);
                } else {
                  return ListView(children: [
                    Stack(
                      children: [
                        SizedBox(height: 40.0),
                        (imageFromFile != null)
                            ? ElevatedButton(
                                onPressed: () {
                                  Person activePerson = context.read<AppState>().activePerson;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AttachmentSaveDialog(
                                            imageFilePath: imageFilePath,
                                            activePerson: activePerson,
                                            onModeSwitch: switchMode,
                                            activeAttachmentId: activeAttachmentId,
                                            actionName: 'add',
                                            key: ValueKey('add'),
                                          ),
                                      barrierDismissible: false);
                                },
                                child: Icon(Icons.add))
                            : SizedBox(),
                        Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? pickerResult =
                                      await FilePicker.platform.pickFiles(type: FileType.any);
                                  if (pickerResult != null) {
                                    debugPrint(pickerResult.files.first.path);
                                    var imageFile = File(pickerResult.files.first.path!);
                                    imageFilePath = imageFile.path;
                                    showImageFromfile(Image.file(imageFile));
                                  }
                                },
                                child: Icon(Icons.upload))),
                      ],
                    ),
                    ...(imageFromFile != null)
                        ? [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Loaded File',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: imageFromFile,
                                )),
                          ]
                        : [],
                  ]);
                }
              } else {
                return const SpinKitPouringHourGlass(color: Colors.blue);
              }
            });
      case (AttachmentTabMode.edit):
        String authString = context.read<AppState>().authString;
        return ListView(children: [
          Stack(children: [
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  if (imageFromFile != null) {
                    Person activePerson = context.read<AppState>().activePerson;
                    showDialog(
                        context: context,
                        builder: (context) => AttachmentSaveDialog(
                              imageFilePath: imageFilePath,
                              activePerson: activePerson,
                              onModeSwitch: switchMode,
                              activeAttachmentId: activeAttachmentId,
                              actionName: 'replace',
                              key: ValueKey('replace'),
                            ),
                        barrierDismissible: false);
                  } else {
                    switchMode(AttachmentTabMode.view, -1);
                  }
                },
                child: (imageFromFile != null) ? Icon(Icons.check) : Icon(Icons.arrow_back)),
            Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? pickerResult =
                          await FilePicker.platform.pickFiles(type: FileType.any);
                      if (pickerResult != null) {
                        debugPrint(pickerResult.files.first.path);
                        var imageFile = File(pickerResult.files.first.path!);
                        imageFilePath = imageFile.path;
                        showImageFromfile(Image.file(imageFile));
                      }
                    },
                    child: Icon(Icons.upload))),
            Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    onPressed: () {
                      Person activePerson = context.read<AppState>().activePerson;
                      showDialog(
                          context: context,
                          builder: (context) => AttachmentSaveDialog(
                                imageFilePath: imageFilePath,
                                activePerson: activePerson,
                                onModeSwitch: switchMode,
                                activeAttachmentId: activeAttachmentId,
                                actionName: 'delete',
                                key: ValueKey('delete'),
                              ),
                          barrierDismissible: false);
                    },
                    child: Icon(Icons.delete))),
          ]),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Original File',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Image(
                  image: NetworkImage(
                      '${Api.attachmentUrl}/send-file?fileId=$activeAttachmentId&${DateTime.now().millisecondsSinceEpoch}',
                      headers: {'Authorization': 'Basic $authString'}),
                ),
              )),
          ...(imageFromFile != null)
              ? [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loaded File',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: imageFromFile,
                      )),
                ]
              : [],
        ]);
      case (AttachmentTabMode.add):
        return ListView(children: [
          Stack(
            children: [
              SizedBox(height: 40.0),
              (imageFromFile != null)
                  ? ElevatedButton(
                      onPressed: () {
                        Person activePerson = context.read<AppState>().activePerson;
                        showDialog(
                            context: context,
                            builder: (context) => AttachmentSaveDialog(
                                  imageFilePath: imageFilePath,
                                  activePerson: activePerson,
                                  onModeSwitch: switchMode,
                                  activeAttachmentId: activeAttachmentId,
                                  actionName: 'add',
                                  key: ValueKey('add'),
                                ),
                            barrierDismissible: false);
                      },
                      child: Icon(Icons.add))
                  : SizedBox(),
              Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? pickerResult =
                            await FilePicker.platform.pickFiles(type: FileType.any);
                        if (pickerResult != null) {
                          debugPrint(pickerResult.files.first.path);
                          var imageFile = File(pickerResult.files.first.path!);
                          imageFilePath = imageFile.path;
                          showImageFromfile(Image.file(imageFile));
                        }
                      },
                      child: Icon(Icons.upload))),
            ],
          ),
          ...imageFromFile != null
              ? [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loaded File',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: imageFromFile,
                      )),
                ]
              : [],
        ]);
    }
  }
}

class AttachmentSaveDialog extends StatelessWidget {
  const AttachmentSaveDialog(
      {required this.activePerson,
      required this.imageFilePath,
      required this.onModeSwitch,
      required this.actionName,
      required this.activeAttachmentId,
      super.key});
  final String imageFilePath;
  final Person activePerson;
  final void Function(AttachmentTabMode newMode, int activeAttachmentId) onModeSwitch;
  final String actionName;
  final int activeAttachmentId;
  Future<http.MultipartRequest> createRequest(String actionName) async {
    switch (actionName) {
      case ('add'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/add?id=${activePerson.id}';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..fields['id'] = activePerson.id.toString()
          ..files.add(await http.MultipartFile.fromPath('attachmentFile', imageFilePath))
          ..headers['Authorization'] = 'Basic $authString';
        return request;
      case ('replace'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/replace?id=$activeAttachmentId';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath('attachmentFile', imageFilePath))
          ..headers['Authorization'] = 'Basic $authString';
        return request;
      case ('delete'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/delete?id=$activeAttachmentId';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('GET', uri)
          ..headers['Authorization'] = 'Basic $authString';
        return request;

      default:
        return http.MultipartRequest('POST', Uri.parse('www.google.com'));
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (actionName) {
      case ('add'):
      case ('replace'):
        return Dialog(
          child: SizedBox(
            width: 300.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Do you want to save loaded photo?'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          debugPrint('Yes save pressed');
                          // String authString = await Credentials.getAuthString();
                          // var uri = Uri.parse(Api.attachmentUrl);
                          // var request = http.MultipartRequest('POST', uri)
                          //   ..fields['id'] = activePerson.id.toString()
                          //   ..files
                          //       .add(await http.MultipartFile.fromPath('attachmentFile', imageFilePath))
                          //   ..headers['Authorization'] = 'Basic $authString';
                          var request = await createRequest(actionName);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            debugPrint('Attachment Uploaded!');
                          } else {
                            debugPrint('Response code: ${response.statusCode}');
                          }

                          /// TODO check if can be done better ie .then()...
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          onModeSwitch(AttachmentTabMode.view, activeAttachmentId);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('No save pressed');
                          Navigator.pop(context);
                          onModeSwitch(AttachmentTabMode.view, activeAttachmentId);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      case ('delete'):
        return Dialog(
          child: SizedBox(
            width: 300.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Do you want to delete this photo?'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          debugPrint('Yes delete pressed');
                          var request = await createRequest(actionName);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            debugPrint('Attachment Deleted!');
                          } else {
                            debugPrint('Response code: ${response.statusCode}');
                          }

                          /// TODO check if can be done better ie .then()...
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          onModeSwitch(AttachmentTabMode.view, activeAttachmentId);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('No delete pressed');
                          Navigator.pop(context);
                          onModeSwitch(AttachmentTabMode.view, activeAttachmentId);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return Placeholder();
    }
  }
}
