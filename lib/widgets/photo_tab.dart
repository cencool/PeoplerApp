import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

enum PhotoTabMode { view, load, zoom }

class PhotoTab extends StatefulWidget {
  const PhotoTab({required this.onModeSwitch, super.key});
  final void Function(PersonTabMode newMode) onModeSwitch;

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  Future<String> authString = Credentials.getAuthString();
  PhotoTabMode mode = PhotoTabMode.view;
  dynamic fromFile;

  void switchPhotoTabMode(PhotoTabMode newMode) {
    setState(() {
      mode = newMode;
    });
  }

  void showImageFromFile(Image loadedFromFile) {
    setState(() {
      fromFile = loadedFromFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authString,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int personId = context.read<AppState>().activePerson.id;
          return Stack(children: [
            ListView(children: [
              PhotoView(personId: personId, snapshot: snapshot, mode: mode),
              ...(fromFile != null) ? [fromFile] : [],
            ]),
            Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: () {
                  widget.onModeSwitch(PersonTabMode.view);
                },
                heroTag: null,
                mini: true,
                child: Icon(Icons.check),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: () {
                  if (mode == PhotoTabMode.view) {
                    switchPhotoTabMode(PhotoTabMode.zoom);
                  } else if (mode == PhotoTabMode.zoom) {
                    switchPhotoTabMode(PhotoTabMode.view);
                  }
                },
                heroTag: null,
                mini: true,
                child: (mode == PhotoTabMode.view) ? Icon(Icons.zoom_in) : Icon(Icons.zoom_out),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: FloatingActionButton(
                onPressed: () async {
                  FilePickerResult? pickerResult = await FilePicker.platform
                      .pickFiles(type: FileType.any); // widget.onModeSwitch(PersonTabMode.view);
                  if (pickerResult != null) {
                    print(pickerResult.files.first.path);
                    var imageFile = File(pickerResult.files.first.path!);
                    var fileBytes = imageFile.readAsBytes();
                    showImageFromFile(Image.file(imageFile));
                    String authString = await Credentials.getAuthString();
                    var uri = Uri.parse('${Api.personPhotoSendUrl}');
                    var request = http.MultipartRequest('POST', uri)
                      ..fields['id'] = personId.toString()
                      ..files.add(await http.MultipartFile.fromPath('personPhoto', imageFile.path))
                      ..headers['Authorization'] = 'Basic $authString';
                    var response = await request.send();
                    if (response.statusCode == 200) {
                      print('Photo Uploaded!');
                    } else {
                      debugPrint('Response code: ${response.statusCode}');
                    }
                  }
                },
                heroTag: null,
                mini: true,
                child: Icon(Icons.upload),
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

class PhotoView extends StatelessWidget {
  const PhotoView({required this.personId, required this.snapshot, required this.mode, super.key});
  final PhotoTabMode mode;
  final AsyncSnapshot snapshot;
  final int personId;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case (PhotoTabMode.view):
        return Image(
          image: NetworkImage(
            '${Api.personPhotoReceiveUrl}?id=$personId&${DateTime.now().millisecondsSinceEpoch}',
            headers: {'Authorization': 'Basic ${snapshot.data}'},
          ),
        );
      case (PhotoTabMode.zoom):
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
