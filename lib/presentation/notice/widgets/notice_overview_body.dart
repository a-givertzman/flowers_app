import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/notice/widgets/notice_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flutter/material.dart';

class NoticeOverviewBody extends StatelessWidget {
  final bool enableUserMessage;
  // String _userMessage = '';
  final NoticeList noticeList;
  final String purchaseContentId;
  final NoticeListViewed _noticeListViewed;
  const NoticeOverviewBody({
    Key? key,
    required this.purchaseContentId,
    required this.noticeList,
    required this.enableUserMessage,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeListViewed = noticeListViewed,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notice>>(
      future: noticeList.fetchWith(params: {
        'purchase_content_id': purchaseContentId,
        'order': 'DESC'
      },),
      builder:(context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: noticeList.fetch,
          child: _buildListViewWidget(context, snapshot),
        );
      },); 
  }

  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<List<Notice>> snapshot,
  ) {
    log('[$NoticeOverviewBody._buildListView]');
    if (snapshot.hasError) {
      log('[$NoticeOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: noticeList.refresh,
      );
    } else if (snapshot.hasData) {
      log('[$NoticeOverviewBody._buildListView] snapshot hasData');
      log('[$NoticeOverviewBody._buildListView] data: ', snapshot.data);
      final List<Notice> notices = snapshot.requireData;
      if (notices.isEmpty) {
        return const Text(
          'Cообщений нет',
        );
      } else {
        return Scrollbar(
          child: Column(
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  if (notice.valid()) {
                    return NoticeCard(
                      key: ValueKey('${notice['id']}'),
                      notice: notice,
                      noticeListViewed: _noticeListViewed,
                    );
                  } else {
                    return const ErrorPurchaseCard(message: 'Ошибка чтения списка сообщений');
                  }
                },
              ),
              if (enableUserMessage)
              Container(
                decoration: BoxDecoration(
                  color: appThemeData.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: TextFormField(
                  style: appThemeData.textTheme.bodyText2,
                  minLines: 1,
                  maxLines: 12,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.attach_file,
                    ),
                    labelText: 'Сообщение...',
                    labelStyle: appThemeData.textTheme.bodyText2,
                    errorMaxLines: 3,
                  ),
                  autocorrect: false,
                  initialValue: '',
                  onChanged: (value) {
                    // _userMessage = value;
                  },
                ),
              ),
            ],
          ),
        );
      }
    } else {
      log('[$NoticeOverviewBody._buildListView] is loading');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    }
  }
}
