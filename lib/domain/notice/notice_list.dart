import 'dart:async';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeList extends DataCollection<Notice>{
  static const _updateTimeoutSeconds = 30;
  final NoticeListViewed _noticeListViewed;
  final List<Notice> _list = [];
  final bool _isEmpty;
  bool _readDone = false;
  bool _readInProgress = false;
  DateTime _updated = DateTime.now();
  // final _noticeStreamController = StreamController<Notice>.broadcast();
  NoticeList({
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
    required NoticeListViewed noticeListViewed,
  }): 
    _isEmpty = false,
    _noticeListViewed = noticeListViewed,
    super(
      remote: remote,
      dataMaper: dataMaper,
    );
  NoticeList.empty() :
    _isEmpty = true,
    _noticeListViewed = NoticeListViewed.empty(),
    super(
      remote: DataSet.empty(),
      dataMaper: (_) => DataObject.empty(),
    );
  bool isEmpty() => _isEmpty;
  Future<List<Notice>> _read() {
    final List<Notice> _list = [];
    _readDone = false;
    _readInProgress = true;
    return fetch()
      .then((noticeList) {
        for (final _notice in noticeList) {
          // _noticeStreamController.sink.add(_notice);
          _list.add(_notice);
        }
        return _list;
      })
      .onError((error, stackTrace) {
        _readInProgress = false;
        throw Failure.dataCollection(
          message: 'Ошибка в методе fetchWith класса $NoticeList:\n$error',
          stackTrace: stackTrace,
        );
      })
      .whenComplete(() {
        _updated = DateTime.now();
        _readDone = true;
        _readInProgress = false;
        log('[$NoticeList.NoticeList] _readDone: ', _readDone);
      });
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
  Future<bool> _awaitReading() {
    return Future<bool>(() async {
      log('[$NoticeList._awaitReading] start');
      if (_readInProgress) {
        log('[$NoticeList._awaitReading] read in progress');
        int _count = 0;
        while (_readInProgress) {
          _count++;
          await Future.delayed(const Duration(milliseconds: 100));
          log('[$NoticeList._awaitReading] \tread in progress await 100 ms count: $_count');
        }
      }
      if (!_readDone || (_secondsBetween(_updated, DateTime.now()) > _updateTimeoutSeconds)) {
        log('[$NoticeList._awaitReading] first read');
        await _read()
          .then((_noticeList) {
            _list.clear();
            _list.addAll(_noticeList);
            log('[$NoticeList._awaitReading] first read done');
          });
      }
      return true;
    });
  }
  /// возвращает true если в текущем списке уведомлений 
  /// отфильтрованном по fieldName = value есть хотя бы одно новое
  /// для текущего пути localStorageNoticePath
  Future<bool> hasNotRead({
    required String fieldName,
    required String value,
  }) {
    log('[$NoticeList.hasNotRead] try to find new Notice in the list filterd by field: $fieldName = $value');
    return _awaitReading()
      .then((_) {
        return _findNewNotice(
          noticeList: _list.where((notice) => '${notice[fieldName]}' == value).toList(),
          noticeListViewed: _noticeListViewed, 
        );
      });
  }
  Future<bool> _findNewNotice({
    required List<Notice> noticeList,
    required NoticeListViewed noticeListViewed,
  }) async {
    for (final notice in noticeList) {
      final viewed = await noticeListViewed.contains(noticeId: '${notice['id']}');
      if (!viewed) {
        log('[$NoticeList._findNewNotice] Found NEW Notices');
        return true;
      }
    }
    return false;
  }
  Future<Notice> last({
    required String fieldName,
    required String value,
  }) {
    return _awaitReading()
      .then((_) {
        log('[$NoticeList.last] try to find Notice (field: $fieldName\tvalue: $value)');
        return _findLast(
          fieldName: fieldName, 
          value: value,
        );
      });
  }
  Notice _findLast({
    required String fieldName,
    required String value,
  }) {
    return _list.lastWhere(
      (_notice) => '${_notice[fieldName]}' == value,
      orElse: () => Notice.empty(),
    );
  }
  int _secondsBetween(DateTime from, DateTime to) {
   return to.difference(from).inSeconds;
  }
  /// вернет true - если сообщение отправлено текущим пользователем
  bool isSent() {
    return false;
  }

}
