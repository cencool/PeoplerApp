import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_globals.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/services/api_config.dart';
import 'package:peopler/app/data/services/api_service.dart';
import 'package:peopler/app/domain/models/common/paginated_list.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/paginated_person_list.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';

class PersonRepository {
  final Ref ref;
  final SnackMessage snackMessage;
  PersonRepository(this.ref) : snackMessage = ref.read(snackMessageProvider);
  Future<Result<PaginatedList<Person>, String>> getPaginatedPersonList(
      {Map<String, String>? query}) async {
    var credentials = ref.read(appStateProvider).credentials;
    if (credentials == null) {
      return const Failure('Credentials not found');
    }
    Uri uri = Uri.parse(ApiConfig.personUrl);
    if (query != null) {
      uri = uri.replace(queryParameters: query);
    }
    ApiService apiService = ref.read(appGlobalsProvider).apiService;
    var responseResult = await apiService
        .getRequest(uri, headers: {'Authorization': 'Basic ${credentials.getAuthString()}'});
    switch (responseResult) {
      case Success(value: final serverResponse):
        final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '1');
        final int total = int.parse(serverResponse.headers['x-pagination-total-count'] ?? '0');
        final int perPage = int.parse(serverResponse.headers['x-pagination-per-page'] ?? '1');
        final int page = int.parse(serverResponse.headers['x-pagination-current-page'] ?? '1');

        /// TODO: check if the response is a valid JSON
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final List<Person> personList =
            List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
        return Success(PaginatedPersonList(
            pageCount: pageCount,
            currentPage: page,
            pageSize: perPage,
            totalCount: total,
            items: personList));
      case Failure(error: final errorResult):
        snackMessage.showMessage(
            message: 'Error fetching person list: $errorResult', messageType: MessageType.error);
        return Failure(errorResult);
    }
  }

  Future<Result<Person, String>> getPerson({required int id}) async {
    var credentials = ref.read(appStateProvider).credentials;
    if (credentials == null) {
      return const Failure('Credentials not found');
    }
    Uri uri = Uri.parse('${ApiConfig.personUrl}/$id');
    ApiService apiService = ref.read(appGlobalsProvider).apiService;
    var responseResult = await apiService
        .getRequest(uri, headers: {'Authorization': 'Basic ${credentials.getAuthString()}'});
    switch (responseResult) {
      case Success(value: final serverResponse):
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final Person person = Person.fromJson(jsonObject);
        return Success(person);
      case Failure(error: final errorResult):
        snackMessage.showMessage(
            message: 'Error fetching person: $errorResult', messageType: MessageType.error);
        return Failure(errorResult);
    }
  }

  Future<Result<PersonDetail, String>> getPersonDetail({required int personId}) async {
    var credentials = ref.read(appStateProvider).credentials;
    if (credentials == null) {
      return const Failure('Credentials not found');
    }
    Uri uri = Uri.parse('${ApiConfig.personDetailUrl}/$personId');
    ApiService apiService = ref.read(appGlobalsProvider).apiService;
    var responseResult = await apiService
        .getRequest(uri, headers: {'Authorization': 'Basic ${credentials.getAuthString()}'});
    switch (responseResult) {
      case Success(value: final serverResponse):
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final PersonDetail personDetail = PersonDetail.fromJson(jsonObject);
        return Success(personDetail);
      case Failure(error: final errorResult):
        snackMessage.showMessage(
            message: 'Error fetching person detail: $errorResult', messageType: MessageType.error);
        return Failure(errorResult);
    }
  }
}
