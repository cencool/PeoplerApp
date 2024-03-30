import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/models/credentials.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:peopler/models/person_detail.dart';

class PersonView extends StatefulWidget {
  const PersonView(this.personId, {super.key});
  final int personId;

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  Future<List> fetchPersonData(int id, BuildContext context) async {
    final personFuture = Person.getPerson(id: id, context: context);
    final personDetailFuture = PersonDetail.getPersonDetail(id: id, context: context);
    return await Future.wait([personFuture, personDetailFuture]);
  }

  @override
  Widget build(BuildContext context) {
    // final Future<Person?> personFuture = Person.getPerson(id: widget.personId, context: context);
    // final Future<PersonDetail?> personDetailFuture =
    //     PersonDetail.getPersonDetail(id: widget.personId, context: context);
    return FutureBuilder(
        future: fetchPersonData(widget.personId, context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 200,
                  child: PersonPhoto(widget.personId),
                ),
                const SizedBox(height: 10.0),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Text('Surname:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child:
                        Text('${snapshot.data?[0].surname}', style: const TextStyle(fontSize: 20)),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Text('Name:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('${snapshot.data?[0].name}', style: const TextStyle(fontSize: 20)),
                  ),
                ]),
                Row(children: [
                  const Text('Place:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '${snapshot.data?[0].place}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ]),
                ...snapshot.data?[1] == null
                    ? []
                    : [
                        Row(children: [
                          const Text('Status:',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              '${snapshot.data?[1].maritalStatus}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ]),
                        snapshot.data?[0].gender == 'f'
                            ? Row(children: [
                                const Text('Maiden Name:',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    '${snapshot.data?[1].maidenName}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ])
                            : const SizedBox(),
                        const Text('Address:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${snapshot.data?[1].address}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const Text('Notes:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${snapshot.data?[1].note}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]
              ],
            );
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}

class PersonPhoto extends StatefulWidget {
  const PersonPhoto(this.personId, {super.key});
  final int personId;

  @override
  State<PersonPhoto> createState() => _PersonPhotoState();
}

class _PersonPhotoState extends State<PersonPhoto> {
  Future<String> authString = Credentials.getAuthString();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authString,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${Api.personPhotoUrl}?id=${widget.personId}',
                  headers: {'Authorization': 'Basic ${snapshot.data}'},
                ));
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
