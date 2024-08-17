import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  const findLastNoticeByFieldName = 'purchase_content_id';
  const findLastNoticeByFieldNameValue = '10';
  final lastNoticeId = ValueString('2.6.10');
  const customerId = '916';
  late NoticeListViewed noticeListViewed;
  late NoticeList noticeList;
  setUpAll(() async {
    Log.initialize(level: LogLevel.all);
    noticeListViewed = NoticeListViewed(customerId: customerId);
    noticeList = NoticeList(
      // dataMaper: (row) {
      //   final noticeId = '${row['id']}';
      //   final purchaseContentId = '${row['purchase_content/id']}';
      //   return Notice(
      //     remote: dataSet,
      //     viewed: noticeListViewed.containsInGroup(
      //       noticeId: noticeId, 
      //       purchaseContentId: purchaseContentId,
      //     ),
      //   ).fromRow(row);
      // },
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
    const log = Log('NoticeList.last()');
    final Notice last = await noticeList.last(
      fieldName: findLastNoticeByFieldName, 
      value: findLastNoticeByFieldNameValue,
    );
    log.debug('last: $last');
    expect(last.isValid, equals(true), reason: 'last notice is empty');
    expect(last.id.isNotEmpty, true, reason: "error reading last['id']");
    expect(last.purchaseId.isNotEmpty, true, reason: "error reading last['purchase_id']");
    expect(last.purchaseContentId.isNotEmpty, true, reason: "error reading last['purchase_content_id']");
    expect(last.message.isNotEmpty, true, reason: "error reading last['message']");
    expect(last.created.isNotEmpty, true, reason: "error reading last['created']");
    expect(last.updated.isNotEmpty, true, reason: "error reading last['updated']");
    expect(last.deleted.runtimeType, ValueString, reason: "error reading last['deleted']");
    expect(last.id, lastNoticeId);
  });
  // test('NoticeList.hasNotRead() test', () async {
  //   final bool hasNotRead = await noticeList.hasNotRead(
  //     fieldName: findLastNoticeByFieldName, 
  //     value: findLastNoticeByFieldNameValue,
  //   );
  //   log(_debug, 'NoticeList hasNotRead: ', hasNotRead);
  //   expect(hasNotRead, equals(false), reason: 'last notice is empty');
  // });
}
