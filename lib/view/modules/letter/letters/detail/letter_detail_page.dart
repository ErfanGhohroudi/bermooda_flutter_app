import 'package:flutter_html/flutter_html.dart';
import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'letter_detail_controller.dart';

class LetterDetailPage extends StatefulWidget {
  const LetterDetailPage({
    required this.mail,
    required this.onUpdated,
    this.mailId,
    super.key,
  });

  final LetterReadDto mail;
  final String? mailId;
  final Function(LetterReadDto mail) onUpdated;

  @override
  State<LetterDetailPage> createState() => _LetterDetailPageState();
}

class _LetterDetailPageState extends State<LetterDetailPage> with LetterDetailController {
  @override
  void initState() {
    if ((widget.mailId ?? '') != '') {
      getMail(widget.mailId ?? '');
    } else {
      mail(widget.mail);
    }
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.letter),
      ),
      bottomNavigationBar: Obx(
        () => UElevatedButton(
          title: 'نغییر وضعیت نامه',
          isLoading: buttonState.isLoading(),
          onTap: () => getCurrentStatus(
            action: (final statusList, final userList) {
              showAppDialog(
                barrierDismissible: false,
                AlertDialog(
                  content: _changeMailStatusWidget(statusList, userList),
                ),
              );
            },
          ),
        ).pOnly(left: 16, right: 16, bottom: 24),
      ),
      body: Obx(
        () => pageState.isLoaded()
            ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: padding,
                  children: [
                    _header(),
                    _content(),
                    _signatures(),
                    _attachments(),
                  ],
                ),
              )
            : const Center(child: WCircularLoading()),
      ),
    );
  }

  Widget _header() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                SizedBox(
                  height: 60,
                  child: UImage(mail.value.mailImage?.url ?? '', size: 60),
                ).marginOnly(bottom: padding),
                _headerItem(
                  title: s.sender,
                  value: mail.value.senderFullname ?? '- -',
                ),
                _headerItem(
                  title: s.title,
                  value: mail.value.title ?? '- -',
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                _headerItem(
                  title: s.letterNumber,
                  value: mail.value.id.toString(),
                ),
                _headerItem(
                  title: s.date,
                  value: mail.value.jtime ?? '- -',
                ),
                _headerItem(
                  title: s.attachment,
                  value: mail.value.files.isNullOrEmpty() ? s.noAttachment : s.hasAttachment,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _headerItem({
    required final String title,
    required final String value,
  }) =>
      RichText(
        text: TextSpan(
          style: context.textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$title : ',
              style: context.textTheme.bodyMedium!.copyWith(color: context.theme.hintColor),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
        textAlign: TextAlign.justify,
      );

  Widget _content() => Directionality(
        textDirection: TextDirection.rtl,
        child: Html(
          data: mail.value.mailText,
          onLinkTap: (final url, final attributes, final element) {
            if (url?.isURL ?? false) ULaunch.launchURL(url!);
          },
          style: {
            "body": Style(
              fontSize: FontSize.medium,
              fontFamily: context.textTheme.bodyMedium!.fontFamily,
              color: context.textTheme.bodyMedium!.color,
            ),
            "ol": Style(
              // لیست عددی
              padding: HtmlPaddings.only(right: 24), // لیست فاصله بگیره
              // direction: TextDirection.rtl,
              // textAlign: TextAlign.right,
            ),
            "ul": Style(
              // لیست نقطه ای
              padding: HtmlPaddings.only(right: 24), // لیست فاصله بگیره
              // direction: TextDirection.rtl,
              // textAlign: TextAlign.right,
            ),
            "li": Style(
              color: context.textTheme.bodyMedium!.color,
              fontSize: FontSize.medium,
              // direction: TextDirection.rtl,
              // textAlign: TextAlign.right,
            ),
            "span": Style(
                // color: context.textTheme.bodyMedium!.color,
                ),
          },
        ),
      );

  Widget _signatures() {
    final List<Recipient> signatures = mail.value.recipients.where((final element) => element.recipientType == RecipientType.sign).toList();

    return signatures.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${s.signatures} :').bodyMedium(color: context.theme.hintColor).bold(),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: signatures
                    .map(
                      (final e) => Container(
                        color: Colors.transparent,
                        constraints: BoxConstraints(
                          maxWidth: context.width / 3.5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if ((e.signatureImage?.url ?? '') != '')
                              Container(
                                constraints: BoxConstraints(minHeight: context.width / 5.5),
                                child: UImage(e.signatureImage?.url ?? ''),
                              )
                            else
                              Container(
                                width: context.width / 3.5,
                                height: context.width / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: e.user?.id == core.userReadDto.value.id ? context.theme.primaryColor : context.theme.dividerColor),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 30,
                                  color: e.user?.id == core.userReadDto.value.id ? context.theme.primaryColor : context.theme.dividerColor,
                                ),
                              ).onTap(
                                () {
                                  if (e.user?.id == core.userReadDto.value.id) {
                                    showUploadSignatureDialog(
                                      file: mySignature,
                                      onFileUpdated: (final file) {
                                        mySignature = file;
                                      },
                                      onSaved: () => addSignature(
                                        recipient: e,
                                        action: () {
                                          widget.onUpdated(mail.value);
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            const SizedBox(height: 10),
                            Flexible(
                              child: Text(e.user?.fullName ?? '- -', maxLines: 2).bodyMedium(overflow: TextOverflow.ellipsis).withTooltip(e.user?.fullName ?? '- -'),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _attachments() => (!mail.value.files.isNullOrEmpty())
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text('${s.attachments} :').bodyMedium(color: context.theme.hintColor).bold(),
            WImageFiles(
              files: mail.value.files ?? [],
              showUploadWidget: false,
              removable: false,
              onFilesUpdated: (final list) {},
              uploadingFileStatus: (final value) {},
            ),
          ],
        )
      : const SizedBox();

  Widget _changeMailStatusWidget(
    final List<MailStatus> statusList,
    final List<UserReadDto> userList,
  ) =>
      StatefulBuilder(
        builder: (final context, final setState) => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            if (mail.value.creator?.id == core.userReadDto.value.id)
              WDropDownFormField<String>(
                value: selectedStatus?.title,
                labelText: s.status,
                items: getDropDownMenuItemsFromString(menuItems: statusList.map((final e) => e.title!).toList()),
                onChanged: (final value) {
                  selectedStatus = statusList.firstWhereOrNull((final e) => e.title == value);
                },
              ),
            WMembersPickerFormField(
              labelText: 'ارجاع',
              members: userList,
              selectedMembers: selectedUsersList,
              onConfirm: (final list) {
                selectedUsersList = list;
              },
            ),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: UNavigator.back,
                ).expanded(),
                UElevatedButton(
                  title: s.save,
                  onTap: () {
                    if (selectedStatus != null || selectedUsersList.isNotEmpty) {
                      UNavigator.back();
                      changeStatus();
                    }
                  },
                ).expanded(),
              ],
            ),
          ],
        ),
      );
}
