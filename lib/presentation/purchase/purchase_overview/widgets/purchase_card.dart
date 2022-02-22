import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/purchase_content_page.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_image_widget.dart';
import 'package:flutter/material.dart';

class PurchaseCard extends StatefulWidget {
  final AppUser user;
  final Purchase purchase;
  final NoticeListViewed noticeListViewed;
  const PurchaseCard({
    Key? key,
    required this.user,
    required this.purchase,
    required this.noticeListViewed,
  }) : super(key: key);
  @override
  State<PurchaseCard> createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard> {
  static const _debug = false;
  bool _expanded = false;
  late NoticeListViewed _noticeListViewed;
  @override
  void initState() {
    _noticeListViewed = widget.noticeListViewed;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // log(_debug, '[PurchaseCard.build] purchase: ', purchase);
    return Card(
      // color: appThemeData.colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  PurchaseContentPage(
                user: widget.user,
                purchase: widget.purchase,
                dataSource: dataSource, 
                noticeListViewed: _noticeListViewed,
              ),
              settings: const RouteSettings(name: "/purchaseContentPage"),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PurchaseImageWidget(url: '${widget.purchase['picture']}'),
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
                        // vertical: BorderSide(width: 6.0, color: appThemeData.colorScheme.primaryContainer,),
                      ),
                      // color: appThemeData.colorScheme.secondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4,),
                      child: Text(
                        '${widget.purchase['description']}',
                        style: appThemeData.textTheme.bodyText2,
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

  Widget _buildCardHeader(BuildContext context, bool isExpanded, Purchase purchase) {
    return SizedBox(
      width: double.infinity,
      // color: appThemeData.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${purchase['name']}',
              textAlign: TextAlign.left,
              style: appThemeData.textTheme.subtitle2,
            ),
            const SizedBox(height: 8,),
            Text(
              '${purchase['details']}',
              textAlign: TextAlign.left,
              style: appThemeData.textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
