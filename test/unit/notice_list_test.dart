import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  const findLastNoticeByFieldName = 'purchase_content/id';
  const findLastNoticeByFieldNameValue = '10';
  final lastNoticeId = ValueString('2.6.10');
  const clientId = '916';
  final dataSet = dataSource.dataSet<Map<String, dynamic>>('notice_list');
  late NoticeListViewed noticeListViewed;
  late NoticeList noticeList;
  setUpAll(() async {
    noticeListViewed = NoticeListViewed(clientId: clientId);
    noticeList = NoticeList(
      remote: dataSet,
      dataMaper: (row) {
        final noticeId = '${row['id']}';
        final purchaseContentId = '${row['purchase_content/id']}';
        return Notice(
          remote: dataSet,
          viewed: noticeListViewed.containsInGroup(
            noticeId: noticeId, 
            purchaseContentId: purchaseContentId,
          ),
        ).fromRow(row);
      },
      noticeListViewed: noticeListViewed,
    );
  });

  test('NoticeList() test', () {
    expect(noticeList.isEmpty(), equals(false));
  });

  test('NoticeList.empty() test', () {
    final noticeListEmpty = NoticeList.empty();
    expect(noticeListEmpty.isEmpty(), equals(true));
  });

  test('NoticeListViewed.removeAll() test', () async {
    final result = await noticeListViewed.removeAll();
    expect(result, equals(true));
    final contains = await noticeListViewed.containsInGroup(
      noticeId: lastNoticeId.toString(), 
      purchaseContentId: findLastNoticeByFieldNameValue,
    );
    expect(contains, equals(false));
  });

  test('NoticeListViewed.setViewed() test', () async {
    final result = await noticeListViewed.setViewed(
      noticeId: lastNoticeId.toString(),
      purchaseContentId: findLastNoticeByFieldNameValue,
    );
    expect(result, equals(true));
    final contains = await noticeListViewed.containsInGroup(
      noticeId: lastNoticeId.toString(), 
      purchaseContentId: findLastNoticeByFieldNameValue,
    );
    expect(contains, equals(true));
});

  test('NoticeList.last() test', () async {
    final Notice last = await noticeList.last(
      fieldName: findLastNoticeByFieldName, 
      value: findLastNoticeByFieldNameValue,
    );
    log('last: ', last);
    expect(last.isEmpty, equals(false), reason: 'last notice is empty');
    expect(last['id'].toString().isNotEmpty, true, reason: "error reading last['id']");
    expect(last['purchase/id'].toString().isNotEmpty, true, reason: "error reading last['purchase/id']");
    expect(last['purchase_content/id'].toString().isNotEmpty, true, reason: "error reading last['purchase_content/id']");
    expect(last['message'].toString().isNotEmpty, true, reason: "error reading last['message']");
    expect(last['created'].toString().isNotEmpty, true, reason: "error reading last['created']");
    expect(last['updated'].toString().isNotEmpty, true, reason: "error reading last['updated']");
    expect(last['deleted'].runtimeType, ValueString, reason: "error reading last['deleted']");
    expect(last['id'], lastNoticeId);
  });

  // test('NoticeList.hasNotRead() test', () async {
  //   final bool hasNotRead = await noticeList.hasNotRead(
  //     fieldName: findLastNoticeByFieldName, 
  //     value: findLastNoticeByFieldNameValue,
  //   );
  //   log('NoticeList hasNotRead: ', hasNotRead);
  //   expect(hasNotRead, equals(false), reason: 'last notice is empty');
  // });
}
