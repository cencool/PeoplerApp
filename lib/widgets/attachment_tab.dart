import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_attachment.dart';

class AttachmentTab extends StatefulWidget {
  const AttachmentTab({required this.activePerson, required this.messengerKey, super.key});
  final Person activePerson;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  State<AttachmentTab> createState() => _AttachmentTabState();
}

class _AttachmentTabState extends State<AttachmentTab> {
  late Future<List<PersonAttachment>> attachmentList = widget.activePerson
      .getAttachmentList(id: widget.activePerson.id, messengerKey: widget.messengerKey);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: attachmentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Text> attachmentFiles = [];
            for (final item in snapshot.data!) {
              attachmentFiles
                  .add(Text('${item.id},${item.personId},${item.fileCaption},${item.fileName}'));
            }
            return ListView(children: attachmentFiles);
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
