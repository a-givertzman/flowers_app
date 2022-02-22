import 'dart:async';
import 'dart:convert';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';

/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeListViewed {
  static const _debug = false;
  static const _updateTimeoutSeconds = 30;
  final Map<String, List<String>> _map = {};
  final String _clientId;
  final bool _isEmpty;
  bool _readDone = false;
  bool _readInProgress = false;
  DateTime _updated = DateTime.now();
  NoticeListViewed({
    required String clientId,
  }): 
    _isEmpty = false,
    _clientId = clientId
  {
    log(_debug, '[NoticeListViewed] created with client Id: ', _clientId);
  }
  NoticeListViewed.empty() :
    _isEmpty = false,
    _clientId = '';
  bool isEmpty() => _isEmpty;
  /// Очищает все хранилиже если не указан ключ
  Future<bool> removeAll() {
    final _localStore = LocalStore();
    return _localStore.clear();    
  }
  /// Метод сохраняет noticeId в список просмотренных в localStorage
  ///   noticeId - идентификатор, хранящийся в localStorage
  ///   purchaseContentId - идентификатор группы, в которую попадет noticeId
  Future<bool> setViewed({
    required String noticeId,
    required String purchaseContentId,
  }) {
    log(_debug, '[$NoticeListViewed.setViewed] trying to find Notice (id: $noticeId)');
    return _awaitReading()
      .then((_) {
        if (!_containsInGroup(map: _map, groupId: purchaseContentId, id: noticeId)) {
          _map.update(purchaseContentId,
            (listOfId) {
              listOfId.add(noticeId);
              return listOfId;
            },
            ifAbsent: () {
              return [noticeId];
            },
          );
          log(_debug, '[$NoticeListViewed.setViewed] new viewed map: ', _map);
          final _viewedJasonMap = const JsonCodec().encode(_map);
          final _localStore = LocalStore();
          return _localStore.writeString(
            localStorageViewedNoticePath(_clientId), 
            _viewedJasonMap,
          );
        }
        return true;
      });
  }
  /// метод возвращает Future(true), если процесс чтения завершится успешно
  Future<bool> _awaitReading() {
    return Future<bool>(() async {
      log(_debug, '[$NoticeListViewed._awaitReading] start');
      if (_readInProgress) {
        log(_debug, '[$NoticeListViewed._awaitReading] read in progress');
        int count = 0;
        while (_readInProgress) {
          count++;
          await Future.delayed(const Duration(milliseconds: 100));
          log(_debug, '[$NoticeListViewed._awaitReading] \tread in progress await 100 ms count: $count');
          if (count > 100) {
            final message = '[$NoticeListViewed._awaitReading] \tread in progress over 10 sec - too long, error reding';
            log(_debug, message);
            throw Failure.dataCollection(
              message: message, 
              stackTrace: StackTrace.current,
            );
          }
        }
      }
      if (!_readDone || _outdated()) {
        log(_debug, '[$NoticeListViewed._awaitReading] first read');
        await _read()
          .then((_viewedMap) {
            _map.clear();
            _map.addAll(_viewedMap);
            log(_debug, '[$NoticeListViewed._awaitReading] first read done');
          });
      }
      return true;
    });
  }
  /// возвращает список id всех просмотренных notice
  /// для текущего пути localStorageNoticePath
  Future<Map<String, List<String>>> _read() {
    final _localStore = LocalStore();
    // _localStore.remove(localStorageViewedNoticePath(_clientId));   // для очистки _localStore
    _readDone = false;
    _readInProgress = true;
    return _localStore
      .readString(
        localStorageViewedNoticePath(_clientId),
      )
      .then((_json) {
        try {
          if (_json.isNotEmpty) {
            final _parsed = const JsonCodec().decode(_json) as Map;
            final Map<String, List<String>> _map = _parsed.map((key, value) {
              final _list = value as List;
              return MapEntry(
                '$key', 
                _list.map((e) => '$e').toList(),
              );
            });
            log(_debug, '[$NoticeListViewed._read] parsed map:', _map);
            return _map;
          } else {
            return <String, List<String>>{};
          }
        } catch (error) {
          log(_debug, 'Ошибка в методе $NoticeListViewed._read класса $runtimeType:\n\t$error\n\t${StackTrace.current}');
          _readInProgress = false;
          return <String, List<String>>{};
        }
      })
      .onError((error, stackTrace) {
        throw Failure.dataCollection(
          message: 'Ошибка в методе $NoticeListViewed._read класса $runtimeType:\n\t$error', 
          stackTrace: stackTrace,
        );
      })
      .whenComplete(() {
        _updated = DateTime.now();
        _readDone = true;
        _readInProgress = false;
      });
  }
  /// Вернет true если Notice с указанным
  ///   noticeId 
  ///   purchaseContentId
  /// имеется в списке просмотренных
  Future<bool> contains({
    required String noticeId,
  }) {
    log(_debug, '[$NoticeListViewed.contains] trying to find Notice (id: $noticeId)');
    return _awaitReading()
      .then((_) {
        return _containsInMap(_map, noticeId);
      });
  }
  bool _containsInMap(Map<String, List<String>> map, String value) {
    for (final entry in map.entries) {
      if (entry.value.contains(value)) {
        return true;
      }
    }
    return false;
  }
  /// Вернет true если Notice с указанными 
  ///   noticeId 
  ///   purchaseContentId
  /// имеется в списке просмотренных
  Future<bool> containsInGroup({
    required String noticeId,
    required String purchaseContentId,
  }) {
    log(_debug, '[$NoticeListViewed.containsInGroup] trying to find Notice (id: $noticeId, purchaseContentId: $purchaseContentId)');
    return _awaitReading()
      .then((_) {
        return _containsInGroup(map: _map, groupId: purchaseContentId, id: noticeId);
      });
  }
  /// Вернет true если указанный id иеется в группе groupId
  bool _containsInGroup({
    required Map<String, List<String>> map, 
    required String groupId, 
    required String id,
  }) {
    if (_map.containsKey(groupId)) {
      final listOfId = _map[groupId];
      if (listOfId != null) {
        return listOfId.contains(id);
      }
    }
    return false;
  }
  /// Если вышел таймаут _updateTimeoutSeconds то закэшированные данные считаются устаревшими
  bool _outdated() {
    return _secondsBetween(_updated, DateTime.now()) > _updateTimeoutSeconds;
  }
  int _secondsBetween(DateTime from, DateTime to) {
   return to.difference(from).inSeconds;
  }
  /// вернет путь в localStorage для просмотренного notice
  /// или пустую строку '' если пуст хотя бы один из 
  /// параметров 'client/id' или 'purchase_content/id'
  String localStorageViewedNoticePath(String clientId) {
    return 'viewedNotice:user:$clientId';
  }
}
