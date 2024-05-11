import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:http/http.dart' as http;

enum PersonPhotoViewMode { view, loadFromFile, zoom }

class PersonPhotoView extends StatefulWidget {
  const PersonPhotoView({required this.activePerson, required this.onModeSwitch, super.key});
  final void Function(PersonTabMode newMode) onModeSwitch;
  final Person activePerson;

  @override
  State<PersonPhotoView> createState() => _PersonPhotoViewState();
}

class _PersonPhotoViewState extends State<PersonPhotoView> {
  Future<String> authString = Credentials.getAuthString();
  PersonPhotoViewMode mode = PersonPhotoViewMode.view;
  dynamic imageFromFile;
  String imageFilePath = '';

  void switchPhotoTabMode(PersonPhotoViewMode newMode) {
    setState(() {
      mode = newMode;
    });
  }

  void showImageFromFile(Image loadedFromFile) {
    setState(() {
      imageFromFile = loadedFromFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authString,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(children: [
            ListView(children: [
              const SizedBox(
                height: 40,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Original Photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ActivePhoto(personId: widget.activePerson.id, snapshot: snapshot, mode: mode),
              ...(imageFromFile != null)
                  ? [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Loaded Photo',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      imageFromFile
                    ]
                  : [],
            ]),
            Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: () {
                  if (imageFromFile != null) {
                    showDialog(
                        context: context,
                        builder: (context) => PhotoSaveDialog(
                              imageFilePath: imageFilePath,
                              activePerson: widget.activePerson,
                              onModeSwitch: widget.onModeSwitch,
                            ),
                        barrierDismissible: false);
                    // Navigator.pop(context);
                  } else {
                    widget.onModeSwitch(PersonTabMode.view);
                  }
                },
                heroTag: null,
                mini: true,
                child: const Icon(Icons.check),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: () {
                  if (mode == PersonPhotoViewMode.view) {
                    switchPhotoTabMode(PersonPhotoViewMode.zoom);
                  } else if (mode == PersonPhotoViewMode.zoom) {
                    switchPhotoTabMode(PersonPhotoViewMode.view);
                  }
                },
                heroTag: null,
                mini: true,
                child: (mode == PersonPhotoViewMode.view)
                    ? const Icon(Icons.zoom_in)
                    : const Icon(Icons.zoom_out),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: FloatingActionButton(
                onPressed: () async {
                  FilePickerResult? pickerResult =
                      await FilePicker.platform.pickFiles(type: FileType.any);
                  if (pickerResult != null) {
                    debugPrint(pickerResult.files.first.path);
                    var imageFile = File(pickerResult.files.first.path!);
                    imageFilePath = imageFile.path;
                    showImageFromFile(Image.file(imageFile));
                  }
                },
                heroTag: null,
                mini: true,
                child: const Icon(Icons.upload),
              ),
            ),
          ]);
        } else {
          return const SpinKitPouringHourGlass(color: Colors.blue);
        }
      },
    );
  }
}

class ActivePhoto extends StatelessWidget {
  const ActivePhoto(
      {required this.personId, required this.snapshot, required this.mode, super.key});
  final PersonPhotoViewMode mode;
  final AsyncSnapshot snapshot;
  final int personId;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case (PersonPhotoViewMode.view):
        return Image(
          image: NetworkImage(
            '${Api.personPhotoReceiveUrl}?id=$personId&${DateTime.now().millisecondsSinceEpoch}',
            headers: {'Authorization': 'Basic ${snapshot.data}'},
          ),
        );
      case (PersonPhotoViewMode.zoom):
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Image(
              image: NetworkImage(
                '${Api.personPhotoReceiveUrl}?id=$personId&${DateTime.now().millisecondsSinceEpoch}',
                headers: {'Authorization': 'Basic ${snapshot.data}'},
              ),
            ),
          ),
        );
      default:
        return const Placeholder();
    }
  }
}

class PhotoSaveDialog extends StatelessWidget {
  const PhotoSaveDialog(
      {required this.activePerson,
      required this.imageFilePath,
      required this.onModeSwitch,
      super.key});
  final String imageFilePath;
  final Person activePerson;
  final void Function(PersonTabMode newMode) onModeSwitch;
  // final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Do you want to replace photo?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      debugPrint('Yes save pressed');
                      String authString = await Credentials.getAuthString();
                      var uri = Uri.parse(Api.personPhotoSendUrl);
                      var request = http.MultipartRequest('POST', uri)
                        ..fields['id'] = activePerson.id.toString()
                        ..files.add(await http.MultipartFile.fromPath('personPhoto', imageFilePath))
                        ..headers['Authorization'] = 'Basic $authString';
                      var response = await request.send();
                      if (response.statusCode == 200) {
                        debugPrint('Photo Uploaded!');
                      } else {
                        debugPrint('Response code: ${response.statusCode}');
                      }

                      /// TODO check if can be done better ie .then()...
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      onModeSwitch(PersonTabMode.view);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No save pressed');
                      Navigator.pop(context);
                      onModeSwitch(PersonTabMode.view);
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
  }
}
