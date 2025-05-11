import 'package:flower_app/domain/notice/notice.dart';
import 'package:flower_app/domain/notice/notice_list.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_json.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_text_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  const findLastNoticeByFieldName = 'purchase_item_id';
  const findLastNoticeByFieldNameValue = '2';
  const lastNoticeId = '4';
  const customerId = '916';
  late NoticeListViewed noticeListViewed;
  late NoticeList noticeList;
  setUpAll(() async {
    Log.initialize(level: LogLevel.all);
    WidgetsFlutterBinding.ensureInitialized();
    await AppSettings.initialize(
      jsonMap: JsonMap.fromTextFile(
        const TextFile.asset(
          'assets/settings/app-settings.json',
        ),
      ),
    );
    noticeListViewed = NoticeListViewed(customerId: customerId);
    noticeList = NoticeList(
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
      purchaseItemId: findLastNoticeByFieldNameValue,
    );
    expect(contains, equals(false));
  });

  test('NoticeListViewed.setViewed() test', () async {
    final result = await noticeListViewed.setViewed(
      noticeId: lastNoticeId.toString(),
      purchaseItemId: findLastNoticeByFieldNameValue,
    );
    expect(result, equals(true));
    final contains = await noticeListViewed.containsInGroup(
      noticeId: lastNoticeId.toString(), 
      purchaseItemId: findLastNoticeByFieldNameValue,
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
    expect(last.purchaseItemId.isNotEmpty, true, reason: "error reading last['purchase_item_id']");
    expect(!last.isEmpty, true, reason: "error reading last['message']");
    expect(last.created.isNotEmpty, true, reason: "error reading last['created']");
    expect(last.updated.isNotEmpty, true, reason: "error reading last['updated']");
    expect(last.deleted.runtimeType, String, reason: "error reading last['deleted']");
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
