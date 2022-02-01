import 'dart:async';

import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов Notice для OrderOverviewBody
/// Список оповещений для отображения в личном кабинете 
class NoticeList extends DataCollection<Notice>{
  final _noticeStreamController = StreamController<Notice>.broadcast();
  NoticeList({
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    remote: remote,
    dataMaper: dataMaper,
  ) {
    dataStream.listen((noticeList) {
      for (final _notice in noticeList) {
        _noticeStreamController.add(_notice);
      }
    });
  }
  Stream<Notice> get noticeStream {
    _noticeStreamController.onListen = refresh;
    return  _noticeStreamController.stream;
  }

    // .map(
    //   (event) {
    //     return event.firstWhere(
    //       (element) => '${element['purchase_content/id']}' == '${order['purchase_content/id']}',
    //     );
    //   }
    // );
}
