import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/notice/notice_list.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase.dart';
import 'package:flower_app/domain/purchase/purchase_status.dart';
import 'package:flower_app/presentation/core/app_theme.dart';
import 'package:flower_app/presentation/notice/build_notice_icon.dart';
import 'package:flower_app/presentation/purchase/purchase_item/purchase_items_page.dart';
import 'package:flower_app/presentation/purchase/purchase_overview/widgets/purchase_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class PurchaseCard extends StatefulWidget {
  final AppUser user;
  final Purchase purchase;
  final NoticeListViewed noticeListViewed;
  ///
  ///
  const PurchaseCard({
    super.key,
    required this.user,
    required this.purchase,
    required this.noticeListViewed,
  });
  //
  //
  @override
  State<PurchaseCard> createState() => _PurchaseCardState();
}
//
//
class _PurchaseCardState extends State<PurchaseCard> {
  static const _log = Log('_PurchaseCardState');
  bool _expanded = false;
  late final NoticeList _noticeList;
  late final NoticeListViewed _noticeListViewed;
  //
  //
  @override
  void initState() {
    _noticeListViewed = widget.noticeListViewed;
    _noticeList = NoticeList(noticeListViewed: _noticeListViewed);
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | purchase: ', widget.purchase);
    return Card(
      // color: appThemeData.colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  PurchaseItemsPage(
                user: widget.user,
                purchase: widget.purchase,
                noticeListViewed: _noticeListViewed,
              ),
              settings: const RouteSettings(name: "/purchaseContentPage"),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                PurchaseImageWidget(url: widget.purchase.picture),
                Positioned(
                  right: 16.0,
                  bottom: 64.0,
                  width: 42.0,
                  height: 42.0,
                  child: Center(
                    child: FutureBuilder(
                      future: Future.wait([
                        _noticeList.last(
                          fieldName: 'purchase_id', 
                          value: widget.purchase.id,
                        ),
                        _noticeList.hasNew(
                          fieldName: 'purchase_id', 
                          value: widget.purchase.id,
                        ),
                      ]),
                      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                        return buildNoticeIcon(
                          context: context, 
                          notice: snapshot.data?[0],
                          hasError: snapshot.hasError,
                          hasNotRead: snapshot.data?[1] ?? false,
                          size: 32.0,
                        );
                      }
                    ),
                  ),
                ),
              ]
            ),
            ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 1000),
              elevation: 0.0,
              expansionCallback: (panelIndex, isExpanded) => setState(() {
                _expanded = !_expanded;
              }),
              children: [
                ExpansionPanel(
                  isExpanded: _expanded,
                  // backgroundColor: appThemeData.colorScheme.primaryContainer,
                  headerBuilder: (context, isExpanded) => _buildCardHeader(
                    context, isExpanded, widget.purchase,
                  ),
                  body: Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4,),
                      child: Text(
                        widget.purchase.description,
                        style: appThemeData.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
  ///
  ///
  Widget _buildCardHeader(BuildContext context, bool isExpanded, Purchase purchase) {
    final statusText = PurchaseStatus(status: purchase.status).text();
    return SizedBox(
      width: double.infinity,
      // color: appThemeData.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              purchase.name,
              textAlign: TextAlign.left,
              style: appThemeData.textTheme.titleSmall,
            ),
            const SizedBox(height: 8,),
            Text(
              '${purchase.details} ($statusText)',
              textAlign: TextAlign.left,
              style: appThemeData.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
