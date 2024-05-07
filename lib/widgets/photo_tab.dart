import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:provider/provider.dart';

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

  void switchPhotoTabMode(PhotoTabMode newMode) {
    setState(() {
      mode = newMode;
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
            PhotoView(personId: personId, snapshot: snapshot, mode: mode),
            // Image(
            //   image: NetworkImage(
            //     '${Api.personPhotoUrl}?id=$personId',
            //     headers: {'Authorization': 'Basic ${snapshot.data}'},
            //   ),
            // ),
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
            '${Api.personPhotoUrl}?id=$personId',
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
                '${Api.personPhotoUrl}?id=$personId',
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
