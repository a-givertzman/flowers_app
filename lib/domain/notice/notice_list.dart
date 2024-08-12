import 'dart:async';

import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef NoticeListSqlAccess = SqlAccess<Map<String, dynamic>, void>;
///
/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeList {
  static const _log = Log('NoticeList');
  final NoticeListSqlAccess? _remote;
  static const _updateTimeoutSeconds = 30;
  final NoticeListViewed _noticeListViewed;
  final List<Notice> _notices = [];
  final bool _isEmpty;
  bool _readDone = false;
  bool _readInProgress = false;
  DateTime _updated = DateTime.now();
  // final _noticeStreamController = StreamController<Notice>.broadcast();
  ///
  /// List of Notice's to be displayed in the user's profile
  NoticeList({
    NoticeListSqlAccess? remote,
    required NoticeListViewed noticeListViewed,
  }): 
    _isEmpty = false,
    _noticeListViewed = noticeListViewed,
          // _dataSource.dataSet('notice_list').withParams(params: {
          //   'client_id': _user.id,
          // },) as DataSet<Map<String, dynamic>>,
          // dataMaper: (row) {
          //   final noticeId = '${row['id']}';
          //   final purchaseContentId = '${row['purchase_content/id']}';
          //   return Notice(
          //     remote: _dataSource.dataSet('notice_list'),
          //     viewed: _noticeListViewed.containsInGroup(
          //       noticeId: noticeId, 
          //       purchaseContentId: purchaseContentId,
          //     ),
          //   ).fromRow(row);
          // }, 
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, userPhone) {
        return Sql(sql: "select * from notice;");
      },
      entryBuilder: (row) => row,
    );
  ///
  ///
  NoticeList.empty() :
    _isEmpty = true,
    _noticeListViewed = NoticeListViewed.empty(),
    _remote = null;
  ///
  ///
  bool isEmpty() => _isEmpty;
  ///
  ///
  Future<List<Notice>> refresh() => _fetch();
  ///
  ///
  Future<List<Notice>> _fetch() {
    final List<Notice> _list = [];
    _readDone = false;
    _readInProgress = true;
    final remote = _remote;
    if (remote != null) {
      return remote.fetch()
        .then((result) {
          switch (result) {
            case Ok(value : final noticeList):
              for (final row in noticeList) {
                // _noticeStreamController.sink.add(_notice);
                _list.add(Notice.fromRow(row));
              }
            case Err(:final error):
              _log.warning('$NoticeList._fetch | Error: $error');
          }
          return _list;
        })
        .onError((error, stackTrace) {
          _readInProgress = false;
          throw Failure.dataCollection(
            message: 'Ошибка в методе $NoticeList._fetch: \n$error',
            stackTrace: StackTrace.current,
          );
        })
        .whenComplete(() {
          _updated = DateTime.now();
          _readDone = true;
          _readInProgress = false;
          _log.debug('$NoticeList._fetch | _readDone: $_readDone');
        });
    } else {
      return Future.value([]);
    }
  }
  // Stream<Notice> get noticeStream {
  //   _noticeStreamController.onListen = refresh;
  //   return  _noticeStreamController.stream;
  // }
  // Stream<Notice> noticeStreamFiltered({
  //   required String fieldName,
  //   required String value,
  // }) {
  //   _noticeStreamController.onListen = refresh;
  //   return  _noticeStreamController.stream.where((_notice) {
  //     return '${_notice[fieldName]}' == value;
  //   });
  // }
  ///
  ///
  Future<bool> _awaitReading() {
    return Future<bool>(() async {
      _log.debug('$NoticeList._awaitReading | start');
      if (_readInProgress) {
        _log.debug('$NoticeList._awaitReading | read in progress');
        int count = 0;
        while (_readInProgress) {
          count++;
          await Future.delayed(const Duration(milliseconds: 100));
          _log.debug('$NoticeList._awaitReading | \tread in progress await 100 ms count: $count');
        }
      }
      if (!_readDone || (_secondsBetween(_updated, DateTime.now()) > _updateTimeoutSeconds)) {
        _log.debug('$NoticeList._awaitReading | first read');
        await _fetch()
          .then((noticeList) {
            _notices.clear();
            _notices.addAll(noticeList);
            _log.debug('$NoticeList._awaitReading | first read done');
          });
      }
      return true;
    });
  }
  ///
  /// Returns true if current filtered (by fieldName = value) 
  /// list of notices has at least one new Notice 
  /// for current path 'localStorageNoticePath'
  Future<bool> hasNew({
    required String fieldName,
    required String value,
  }) {
    _log.debug('$NoticeList.hasNotRead | try to find new Notice in the list filterd by field: $fieldName = $value');
    return _awaitReading()
      .then((_) {
        return _findNewNotice(
          noticeList: _notices.where((notice) => _validateByFieldName(notice: notice, fieldName: fieldName, value: value)).toList(),
          noticeListViewed: _noticeListViewed, 
        );
      });
  }
  ///
  /// Returns true if [notice] has [fieldName] and it's value equals provided [value]
  bool _validateByFieldName({
    required Notice notice,
    required String fieldName,
    required String value,
  }) {
    if (fieldName == 'id') {
      return notice.id == value;
    } else if (fieldName == 'purchase_id') {
      return notice.purchaseId == value;
    } else if (fieldName == 'purchase_content_id') {
      return notice.purchaseContentId == value;
    } else {
      _log.error("$NoticeList._validateByFieldName | Notice list can't be filterd by field: $fieldName, not implemented");
      return false;
    }
  }
  ///
  ///
  Future<bool> _findNewNotice({
    required List<Notice> noticeList,
    required NoticeListViewed noticeListViewed,
  }) async {
    for (final notice in noticeList) {
      final viewed = await noticeListViewed.contains(noticeId: notice.id);
      if (!viewed) {
        _log.debug('$NoticeList._findNewNotice | Found NEW Notices');
        return true;
      }
    }
    return false;
  }
  ///
  ///
  Future<Notice> last({
    required String fieldName,
    required String value,
  }) {
    return _awaitReading()
      .then((_) {
        _log.debug('$NoticeList.last | try to find Notice (field: $fieldName\tvalue: $value)');
        return _findLast(
          fieldName: fieldName, 
          value: value,
        );
      });
  }
  ///
  ///
  Notice _findLast({
    required String fieldName,
    required String value,
  }) {
    return _notices.lastWhere(
      (notice) => _validateByFieldName(notice: notice, fieldName: fieldName, value: value),
      orElse: () => Notice.empty(),
    );
  }
  ///
  ///
  int _secondsBetween(DateTime from, DateTime to) {
   return to.difference(from).inSeconds;
  }
  ///
  /// Returns true if Notice sent by the current user
  bool isSent(String userId) {
    return false;
  }
}
