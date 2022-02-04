import 'dart:async';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeList extends DataCollection<Notice>{
  static const _updateTimeoutSeconds = 30;
  final List<Notice> _list = [];
  bool _readDone = false;
  bool _readInProgress = false;
  DateTime _updated = DateTime.now();
  final _noticeStreamController = StreamController<Notice>.broadcast();
  NoticeList({
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    remote: remote,
    dataMaper: dataMaper,
  );
  Future<List<Notice>> _read() {
    final List<Notice> _list = [];
    _readDone = false;
    _readInProgress = true;
    return fetch()
      .then((noticeList) {
        for (final _notice in noticeList) {
          _noticeStreamController.sink.add(_notice);
          _list.add(_notice);
        }
        _updated = DateTime.now();
        _readDone = true;
        _readInProgress = false;
        log('[$NoticeList.NoticeList] _readDone: ', _readDone);
        return _list;
      })
      .onError((error, stackTrace) {
        _readInProgress = false;
        throw Failure.dataCollection(
          message: 'Ошибка в методе fetchWith класса $NoticeList:\n$error',
          stackTrace: stackTrace,
        );
      });
  }
  Stream<Notice> get noticeStream {
    _noticeStreamController.onListen = refresh;
    return  _noticeStreamController.stream;
  }
  Stream<Notice> noticeStreamFiltered({
    required String fieldName,
    required String value,
  }) {
    _noticeStreamController.onListen = refresh;
    return  _noticeStreamController.stream.where((_notice) {
      return '${_notice[fieldName]}' == value;
    });
  }
  Future<Notice> last({
    required String fieldName,
    required String value,
  }) {
    return Future<Notice>(() async {
      log('[$NoticeList.last] start');
      if (_readInProgress) {
        log('[$NoticeList.last] read in progress');
        int _count = 0;
        while (_readInProgress) {
          _count++;
          await Future.delayed(const Duration(milliseconds: 100));
          log('[$NoticeList.last] \tread in progress await 100 ms count: $_count');
        }
      }
      if (!_readDone || (_secondsBetween(_updated, DateTime.now()) > _updateTimeoutSeconds)) {
        log('[$NoticeList.last] first read');
        await _read().then((_noticeList) {
          _list.clear();
          _list.addAll(_noticeList);
          log('[$NoticeList.last] first read done');
        });
      }
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
      orElse: () {
        final _notice = Notice.empty();
        _notice['message'] = ValueString('');
        return _notice;
      },
    );

  }
  int _secondsBetween(DateTime from, DateTime to) {
   return to.difference(from).inSeconds;
  }
}
