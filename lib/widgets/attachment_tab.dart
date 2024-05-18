import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_attachment.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: attachmentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String authString = context.read<AppState>().authString;
            List<Widget> attachmentFiles = [];
            for (final item in snapshot.data!) {
              attachmentFiles
                  .add(Text('${item.id},${item.personId},${item.fileCaption},${item.fileName}'));
              attachmentFiles.add(FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${Api.attachmentUrl}/send-thumbnail?fileId=${item.id}&${DateTime.now().millisecondsSinceEpoch}',
                  headers: {'Authorization': 'Basic $authString'},
                ),
              ));
            }
            return ListView(children: attachmentFiles);
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
