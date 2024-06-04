import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
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

///TODO namiesto stringu enum v akciach
enum AttachmnetSaveDialogAction { add, update, delete, caption }

class AttachmentTab extends StatefulWidget {
  const AttachmentTab({super.key});

  @override
  State<AttachmentTab> createState() => _AttachmentTabState();
}

class _AttachmentTabState extends State<AttachmentTab> {
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late Future<List<PersonAttachment>> attachmentList;
  late Person activePerson = context.read<AppState>().activePerson;
  int activeAttachmentId = -1;
  PersonAttachment? activeAttachment;
  dynamic imageFromFile;
  String imageFilePath = '';
  List<int> imageData = [];
  final int maxImageSize = 2000000;

  AttachmentTabMode attachmentTabMode = AttachmentTabMode.view;

  @override
  void initState() {
    super.initState();
    attachmentList =
        activePerson.getAttachmentList(id: activePerson.id, messengerKey: messengerKey);
  }

  void switchMode(AttachmentTabMode newMode, int itemId) {
    setState(() {
      activeAttachmentId = itemId;
      attachmentTabMode = newMode;
      if (newMode == AttachmentTabMode.view) {
        imageFromFile = null;
      }
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
        return attachmentListView();
      case (AttachmentTabMode.edit):
        return attachmentEdit();
      case (AttachmentTabMode.add):
        return attachmentAdd();
    }
  }

  Future<void> pickImage() async {
    XFile? imagePick = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePick != null) {
      debugPrint('xfile:${imagePick.path}');
      int? originalSize = await imagePick.length();
      debugPrint('original size:$originalSize');
      if (originalSize > maxImageSize) {
        var decodedImage =
            await imagePick.readAsBytes().then((imgBytes) => img.decodeImage(imgBytes));
        int? decodedSize = decodedImage?.length;
        int? decodedHeight = decodedImage?.height;
        int? decodedWidth = decodedImage?.width;
        double sideRatio =
            (decodedHeight != null && decodedWidth != null) ? decodedHeight / decodedWidth : 1;
        double compressRatio = (decodedSize != null) ? originalSize / decodedSize : 1;
        int sizeDiff = (originalSize - maxImageSize) > 0 ? (originalSize - maxImageSize) : 0;
        int newHeight = (sqrt(sideRatio * maxImageSize / (3 * compressRatio))).round();
        debugPrint('side ratio: $sideRatio');
        debugPrint('decoded size: $decodedSize');
        debugPrint('decoded height: $decodedHeight');
        debugPrint('decoded width: $decodedWidth');
        debugPrint('compress ratio : $compressRatio');
        debugPrint('sizeDiff : $sizeDiff');
        debugPrint('newHeight : $newHeight');
        var thumbnail = img.copyResize(decodedImage!, height: newHeight);
        imageData = img.encodeJpg(thumbnail);
        int quality = 100;
        while (imageData.length > maxImageSize) {
          quality = quality - 1;
          imageData = img.encodeJpg(thumbnail, quality: quality);
        }
        debugPrint('Reduced size is:${imageData.length}');
        debugPrint('With quality:$quality');
        imageFilePath = imagePick.path;
        showImageFromfile(Image.memory(imageData as Uint8List));
      } else {
        imageFilePath = imagePick.path;
        imageData = await imagePick.readAsBytes();
        showImageFromfile(Image.memory(imageData as Uint8List));
      }
    }
  }

  Widget attachmentListView() {
    return FutureBuilder(
        future: attachmentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String authString = context.read<AppState>().authString;
            List<Widget> attachmentFiles = [];
            for (final item in snapshot.data!) {
              attachmentFiles.add(
                Text(
                  (item.fileCaption != null) ? '${item.fileCaption}' : '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              );
              attachmentFiles.add(
                Stack(
                  children: [
                    InstaImageViewer(
                      key: ValueKey(DateTime.now().microsecondsSinceEpoch),
                      imageUrl:
                          '${Api.attachmentUrl}/send-file?fileId=${item.id}&${DateTime.now().millisecondsSinceEpoch}',
                      headers: {'Authorization': 'Basic $authString'},
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
                          activeAttachment = item;
                          switchMode(AttachmentTabMode.edit, item.id);
                        },
                        child: Icon(Icons.edit)),
                  ],
                ),
              );
            }
            if (attachmentFiles.isNotEmpty) {
              return Stack(children: [
                ListView(key: ValueKey(activePerson.id), children: attachmentFiles),
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
                                        imageData: imageData,
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
                              await pickImage();
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
  }

  Widget attachmentEdit() {
    String authString = context.read<AppState>().authString;
    TextEditingController captionController =
        TextEditingController(text: activeAttachment?.fileCaption);
    String? captionControllerInit = captionController.text;
    return ListView(children: [
      Stack(children: [
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
            onPressed: () {
              Person activePerson = context.read<AppState>().activePerson;
              activeAttachment?.fileCaption = captionController.text;
              if (imageFromFile != null) {
                showDialog(
                    context: context,
                    builder: (context) => AttachmentSaveDialog(
                          imageData: imageData,
                          activePerson: activePerson,
                          onModeSwitch: switchMode,
                          activeAttachmentId: activeAttachmentId,
                          activeAttachment: activeAttachment,
                          actionName: 'replace',
                          key: ValueKey('replace'),
                        ),
                    barrierDismissible: false);
              } else if (captionControllerInit != captionController.text) {
                showDialog(
                    context: context,
                    builder: (context) => AttachmentSaveDialog(
                          imageData: imageData,
                          activePerson: activePerson,
                          onModeSwitch: switchMode,
                          activeAttachmentId: activeAttachmentId,
                          activeAttachment: activeAttachment,
                          actionName: 'caption',
                          key: ValueKey('caption'),
                        ),
                    barrierDismissible: false);
              } else {
                switchMode(AttachmentTabMode.view, -1);
              }
            },
            child: Icon(Icons.check)),
        Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
                onPressed: () async {
                  pickImage();
                  /*
                  FilePickerResult? pickerResult =
                      await FilePicker.platform.pickFiles(type: FileType.any);
                  if (pickerResult != null) {
                    debugPrint(pickerResult.files.first.path);
                    var imageFile = File(pickerResult.files.first.path!);
                    imageFilePath = imageFile.path;
                    showImageFromfile(Image.file(imageFile));
                  }
                  */
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
                            imageData: imageData,
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
      TextField(
          controller: captionController,
          decoration: const InputDecoration(
            label: Text(
              'Caption:',
            ),
          )),
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
  }

  Widget attachmentAdd() {
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
                              imageData: imageData,
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
                    pickImage();
                    /*
                    FilePickerResult? pickerResult =
                        await FilePicker.platform.pickFiles(type: FileType.any);
                    if (pickerResult != null) {
                      debugPrint(pickerResult.files.first.path);
                      var imageFile = File(pickerResult.files.first.path!);
                      imageFilePath = imageFile.path;
                      showImageFromfile(Image.file(imageFile));
                    }
                    */
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

class AttachmentSaveDialog extends StatelessWidget {
  AttachmentSaveDialog(
      {required this.activePerson,
      required this.imageData,
      required this.onModeSwitch,
      required this.actionName,
      required this.activeAttachmentId,
      this.activeAttachment,
      super.key});
  // final String imageFilePath;
  final List<int> imageData;
  final Person activePerson;
  final void Function(AttachmentTabMode newMode, int activeAttachmentId) onModeSwitch;
  final String actionName;
  final int activeAttachmentId;
  late final PersonAttachment? activeAttachment;
  Future<http.MultipartRequest> createRequest(String actionName) async {
    switch (actionName) {
      case ('add'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/add?id=${activePerson.id}';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..fields['id'] = activePerson.id.toString()
          ..files.add(
              http.MultipartFile.fromBytes('attachmentFile', imageData, filename: 'attachment.jpg'))
          ..headers['Authorization'] = 'Basic $authString';
        return request;
      case ('replace'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/replace?id=$activeAttachmentId';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..fields['caption'] = activeAttachment?.fileCaption ?? ''
          ..files.add(
              http.MultipartFile.fromBytes('attachmentFile', imageData, filename: 'attachment.jpg'))
          ..headers['Authorization'] = 'Basic $authString';
        return request;
      case ('delete'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/delete?id=$activeAttachmentId';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Basic $authString';
        return request;
      case ('caption'):
        String authString = await Credentials.getAuthString();
        String url = Api.attachmentUrl;
        url += '/update-caption?id=$activeAttachmentId';
        Uri uri = Uri.parse(url);
        var request = http.MultipartRequest('POST', uri)
          ..fields['id'] = activeAttachmentId.toString()
          ..fields['caption'] = activeAttachment?.fileCaption ?? ''
          ..headers['Authorization'] = 'Basic $authString';
        return request;

      default:
        // just default
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
                  const Text('Do you want to save file?'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          debugPrint('Yes save pressed');
                          var request = await createRequest(actionName);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            debugPrint('File save action successfull');
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
                  const Text('Do you want to delete this attachment?'),
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
      case ('caption'):
        return Dialog(
          child: SizedBox(
            width: 300.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Do you want to update caption?'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          debugPrint('Yes save pressed');
                          var request = await createRequest(actionName);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            debugPrint('Caption save action successfull');
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
      default:
        return Placeholder();
    }
  }
}
