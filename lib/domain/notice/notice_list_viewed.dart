import 'dart:async';
import 'dart:convert';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/core/local_store/local_store.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeListViewed {
  static const _log = Log('NoticeListViewed');
  static const _updateTimeoutSeconds = 30;
  final Map<String, List<String>> _map = {};
  final String _customerId;
  final bool _isEmpty;
  bool _readDone = false;
  bool _readInProgress = false;
  DateTime _updated = DateTime.now();
  ///
  ///
  NoticeListViewed({
    required String customerId,
  }): 
    _isEmpty = false,
    _customerId = customerId
  {
    _log.debug('[NoticeListViewed] created with customer Id: ', _customerId);
  }
  ///
  ///
  NoticeListViewed.empty() :
    _isEmpty = false,
    _customerId = '';
  bool isEmpty() => _isEmpty;
  ///
  /// Очищает все хранилиже если не указан ключ
  Future<bool> removeAll() {
    final localStore = LocalStore();
    return localStore.clear();    
  }
  ///
  /// Метод сохраняет noticeId в список просмотренных в localStorage
  ///   noticeId - идентификатор, хранящийся в localStorage
  ///   purchaseContentId - идентификатор группы, в которую попадет noticeId
  Future<bool> setViewed({
    required String noticeId,
    required String purchaseContentId,
  }) {
    _log.debug('.setViewed | trying to find Notice (id: $noticeId)');
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
          _log.debug('.setViewed | new viewed map: ', _map);
          final viewedJasonMap = const JsonCodec().encode(_map);
          final localStore = LocalStore();
          return localStore.writeString(
            localStorageViewedNoticePath(_customerId), 
            viewedJasonMap,
          );
        }
        return true;
      });
  }
  /// метод возвращает Future(true), если процесс чтения завершится успешно
  Future<bool> _awaitReading() {
    return Future<bool>(() async {
      _log.debug('._awaitReading | start');
      if (_readInProgress) {
        _log.debug('._awaitReading | read in progress');
        int count = 0;
        while (_readInProgress) {
          count++;
          await Future.delayed(const Duration(milliseconds: 100));
          _log.debug('._awaitReading | \tread in progress await 100 ms count: $count');
          if (count > 100) {
            const message = '._awaitReading | \tread in progress over 10 sec - too long, error reding';
            _log.debug(message);
            throw Failure.dataCollection(
              message: message, 
              stackTrace: StackTrace.current,
            );
          }
        }
      }
      if (!_readDone || _outdated()) {
        _log.debug('._awaitReading | first read');
        await _read()
          .then((viewedMap) {
            _map.clear();
            _map.addAll(viewedMap);
            _log.debug('._awaitReading | first read done');
          });
      }
      return true;
    });
  }
  /// возвращает список id всех просмотренных notice
  /// для текущего пути localStorageNoticePath
  Future<Map<String, List<String>>> _read() {
    final localStore = LocalStore();
    // _localStore.remove(localStorageViewedNoticePath(_customerId));   // для очистки _localStore
    _readDone = false;
    _readInProgress = true;
    return localStore
      .readString(
        localStorageViewedNoticePath(_customerId),
      )
      .then((json) {
        try {
          if (json.isNotEmpty) {
            final parsed = const JsonCodec().decode(json) as Map;
            final Map<String, List<String>> map = parsed.map((key, value) {
              final list = value as List;
              return MapEntry(
                '$key', 
                list.map((e) => '$e').toList(),
              );
            });
            _log.debug('._read | parsed map:', map);
            return map;
          } else {
            return <String, List<String>>{};
          }
        } catch (error) {
          _log.warning('._read класса $runtimeType:\n\t$error\n\t${StackTrace.current}');
          _readInProgress = false;
          return <String, List<String>>{};
        }
      })
      .onError((error, stackTrace) {
        throw Failure(
          message: '$NoticeListViewed._read | Error $error', 
          stackTrace: stackTrace,
        );
      })
      .whenComplete(() {
        _updated = DateTime.now();
        _readDone = true;
        _readInProgress = false;
      });
  }
  ///
  /// Вернет true если Notice с указанным
  ///   noticeId 
  ///   purchaseContentId
  /// имеется в списке просмотренных
  Future<bool> contains({
    required String noticeId,
  }) {
    _log.debug('.contains | trying to find Notice (id: $noticeId)');
    return _awaitReading()
      .then((_) {
        return _containsInMap(_map, noticeId);
      });
  }
  ///
  /// 
  bool _containsInMap(Map<String, List<String>> map, String value) {
    for (final entry in map.entries) {
      if (entry.value.contains(value)) {
        return true;
      }
    }
    return false;
  }
  ///
  /// Вернет true если Notice с указанными 
  ///   noticeId 
  ///   purchaseContentId
  /// имеется в списке просмотренных
  Future<bool> containsInGroup({
    required String noticeId,
    required String purchaseContentId,
  }) {
    _log.debug('.containsInGroup | trying to find Notice (id: $noticeId, purchaseContentId: $purchaseContentId)');
    return _awaitReading()
      .then((_) {
        return _containsInGroup(map: _map, groupId: purchaseContentId, id: noticeId);
      });
  }
  ///
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
  ///
  /// Если вышел таймаут _updateTimeoutSeconds то закэшированные данные считаются устаревшими
  bool _outdated() {
    return _secondsBetween(_updated, DateTime.now()) > _updateTimeoutSeconds;
  }
  ///
  ///
  int _secondsBetween(DateTime from, DateTime to) {
   return to.difference(from).inSeconds;
  }
  ///
  /// вернет путь в localStorage для просмотренного notice
  /// или пустую строку '' если пуст хотя бы один из 
  /// параметров 'customer_id' или 'purchase_content_id'
  String localStorageViewedNoticePath(String customerId) {
    return 'viewedNotice:user:$customerId';
  }
}
