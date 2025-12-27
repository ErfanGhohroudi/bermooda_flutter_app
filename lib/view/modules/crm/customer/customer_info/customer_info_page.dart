import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/expansion_tile_group/expantion_tile_group.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../create_update/customer_create_update_page.dart';
import '../../widgets/customer_steps/customer_steps.dart';
import '../../../../../core/widgets/follow_up_card/follow_up_card.dart';
import 'customer_info_controller.dart';

class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({
    required this.customerId,
    required this.onEdit,
    required this.onDelete,
    this.canEdit = true,
    super.key,
  });

  final int? customerId;
  final Function(CustomerReadDto customer) onEdit;
  final Function(CustomerReadDto customer) onDelete;
  final bool canEdit;

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  late final CustomerInfoController ctrl;

  bool get canEdit => widget.canEdit;

  @override
  void initState() {
    ctrl = Get.put(CustomerInfoController(customerId: widget.customerId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (ctrl.pageState.isError()) {
          return Center(child: WErrorWidget(onTapButton: ctrl.getCustomer));
        }

        return ctrl.pageState.isLoaded()
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    _header(),
                    if (canEdit) ...[
                      const Divider(),
                      _followUpList(),
                    ],
                    const Divider(),
                    _info(),
                  ],
                ),
              )
            : const Center(child: WCircularLoading());
      },
    );
  }

  Widget _header() => Obx(
        () => WCard(
          showBorder: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              Row(
                spacing: 10,
                children: [
                  WCircleAvatar(
                    user: UserReadDto(
                      id: '',
                      fullName: ctrl.customer.value.fullNameOrCompanyName,
                      avatarUrl: ctrl.customer.value.avatar?.url,
                    ),
                    showFullName: true,
                    size: 60,
                    subTitle: ctrl.customer.value.phoneNumber != null
                        ? WTextButton2(
                            text: ctrl.customer.value.phoneNumber!,
                            onPressed: () => ULaunch.call(ctrl.customer.value.phoneNumber!),
                          )
                        : null,
                  ).expanded(),
                  if (canEdit)
                    Icon(Icons.more_vert_rounded, color: context.theme.hintColor).showMenus([
                      WPopupMenuItem(
                        title: s.editCustomer,
                        icon: AppIcons.editOutline,
                        iconColor: AppColors.green,
                        titleColor: AppColors.green,
                        onTap: () {
                          UNavigator.push(CustomerCreateUpdatePage(
                            customer: ctrl.customer.value,
                            categoryId: ctrl.customer.value.crmCategoryId ?? '',
                            onResponse: (final model) {
                              if (mounted) {
                                ctrl.customer(model);
                                widget.onEdit(ctrl.customer.value);
                              }
                            },
                          ));
                        },
                      ),
                      WPopupMenuItem(
                        title: s.remove,
                        icon: AppIcons.delete,
                        iconColor: AppColors.red,
                        titleColor: AppColors.red,
                        onTap: () {
                          ctrl.delete(
                            customer: ctrl.customer.value,
                            action: () {
                              UNavigator.back();
                              widget.onDelete(ctrl.customer.value);
                            },
                          );
                        },
                      ),
                    ]),
                ],
              ),
              CustomerSteps(
                customer: ctrl.customer.value,
                canEdit: canEdit,
                onStepChanged: (final model) {
                  ctrl.customer(model);
                  widget.onEdit(ctrl.customer.value);
                },
              ),
            ],
          ),
        ),
      );

  Widget _followUpList() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ctrl.customer.value.isDeleted == false && ctrl.haveAccess)
            UElevatedButton(
              width: context.width,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              borderColor: context.theme.primaryColor,
              borderWidth: 2,
              title: s.newFollowUp,
              titleColor: context.theme.primaryColor,
              icon: Icon(Icons.add_rounded, color: context.theme.primaryColor),
              onTap: () => ctrl.createFollowUp(action: widget.onEdit),
            ),
          Obx(
            () {
              if (ctrl.customer.value.followUps.isNullOrEmpty()) return const SizedBox.shrink();
              return ListView.separated(
                itemCount: ctrl.customer.value.followUps.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (final _, final _) => const SizedBox(height: 6),
                itemBuilder: (final context, final index) => WFollowUpCard(
                  followUp: ctrl.customer.value.followUps[index],
                  showSourceData: false,
                  onChanged: (final model) {
                    ctrl.customer.value.followUps[index] = model;
                    ctrl.sortFollowUpList();
                    widget.onEdit(ctrl.customer.value);
                  },
                  onDelete: () {
                    ctrl.customer.value.followUps.removeAt(index);
                    // final isThereAnyAssigneeFollowup = customer.value.followUps.any((final e) => e.assignedUser?.id == Core.userReadDto.value.id);
                    // if (!isThereAnyAssigneeFollowup) {
                    //   customer.value.followUpsOwners.removeWhere((final user) => user.id == Core.userReadDto.value.id);
                    // }
                    ctrl.customer.refresh();
                    widget.onEdit(ctrl.customer.value);
                  },
                ),
              ).marginOnly(top: 12);
            },
          )
        ],
      );

  Widget _info() {
    Widget item({
      required final String title,
      final String? icon,
      final String? value,
      final Widget? child,
      final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    }) =>
        Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if ((icon ?? '') != '') UImage(icon!, color: context.theme.primaryColorDark, size: 30),
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '$title : ',
                      style: context.textTheme.bodyMedium!.copyWith(color: context.theme.hintColor),
                    ),
                    if (value != null)
                      TextSpan(
                        text: value,
                        recognizer: TapGestureRecognizer(),
                      ),
                  ],
                ),
              ),
            ),
            if (child != null) child,
          ],
        );

    bool agentInfoNotEmpty() =>
        !ctrl.customer.value.agentName.isNullOrEmpty() ||
        !ctrl.customer.value.agentPhoneNumber.isNullOrEmpty() ||
        !ctrl.customer.value.agentLandline.isNullOrEmpty() ||
        !ctrl.customer.value.agentPosition.isNullOrEmpty() ||
        !ctrl.customer.value.agentLink.isNullOrEmpty() ||
        !ctrl.customer.value.agentEmail.isNullOrEmpty();

    bool locationInfoNotEmpty() =>
        ctrl.customer.value.state?.title != null ||
        ctrl.customer.value.city?.title != null ||
        !ctrl.customer.value.postalCode.isNullOrEmpty() ||
        !ctrl.customer.value.address.isNullOrEmpty();

    bool additionalInfoNotEmpty() =>
        (ctrl.customer.value.personalType == AuthenticationType.person &&
            (!ctrl.customer.value.nationalCode.isNullOrEmpty() ||
                !ctrl.customer.value.birthday.isNullOrEmpty() ||
                !ctrl.customer.value.certificateNumber.isNullOrEmpty())) ||
        (ctrl.customer.value.personalType == AuthenticationType.legal &&
            (!ctrl.customer.value.companyNationalCode.isNullOrEmpty() || !ctrl.customer.value.economicCode.isNullOrEmpty())) ||
        !ctrl.customer.value.shebaNumber.isNullOrEmpty();

    return Obx(
      () => ExpansionTileGroup(
        items: [
          ExpansionTileItemModel(
            title: s.customerInfo,
            icon: AppIcons.userOutline,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                item(
                  title: s.section,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  child: WLabel(
                    text: ctrl.customer.value.section?.title,
                    color: ctrl.customer.value.section?.colorCode.toColor(),
                  ),
                ),
                if (ctrl.customer.value.personalType != null)
                  item(
                    title: s.type,
                    value: ctrl.customer.value.personalType?.title,
                  ),
                item(
                  title: ctrl.customer.value.personalType == AuthenticationType.legal ? s.companyName : s.fullName,
                  value: ctrl.customer.value.fullNameOrCompanyName?.trim(),
                ),
                if (ctrl.customer.value.personalType == AuthenticationType.person && ctrl.customer.value.gender != null)
                  item(
                    title: s.gender,
                    value: ctrl.customer.value.gender?.getTitle(),
                  ),
                if (!ctrl.customer.value.amount.isNullOrEmpty())
                  item(
                    title: s.salesForecast,
                    child: Text(ctrl.customer.value.amount.toString().toTomanMoney()).bodyMedium(),
                  ),
                if ((ctrl.customer.value.salesProbability ?? 0) > 0)
                  item(
                    title: s.salesProbability,
                    child: WLabelProgressBar(value: ctrl.customer.value.salesProbability ?? 0).expanded(),
                  ),
                if (ctrl.customer.value.connectionType != null)
                  item(
                    title: s.contactPreference,
                    value: ctrl.customer.value.connectionType?.getTitle(),
                  ),
                if (!ctrl.customer.value.phoneNumber.isNullOrEmpty())
                  item(
                    title: s.phoneNumber,
                    child: WTextButton2(
                      text: ctrl.customer.value.phoneNumber!,
                      onPressed: () => ULaunch.call(ctrl.customer.value.phoneNumber!.trim()),
                      onLongPress: () => UClipboard.set(ctrl.customer.value.phoneNumber!.trim()),
                    ),
                  ),
                if (!ctrl.customer.value.email.isNullOrEmpty())
                  item(
                    title: s.email,
                    value: ctrl.customer.value.email,
                  ),
                if (!ctrl.customer.value.socialMediaLink.isNullOrEmpty())
                  item(
                    title: s.socialMediaLink,
                    value: (ctrl.customer.value.socialMediaLink?.isURL ?? false) ? null : ctrl.customer.value.socialMediaLink ?? '- -',
                    child: (ctrl.customer.value.socialMediaLink?.isURL ?? false)
                        ? Flexible(
                            child: WTextButton2(
                              text: ctrl.customer.value.socialMediaLink ?? '',
                              onPressed: () {
                                (ctrl.customer.value.socialMediaLink ?? '').launchMyUrl();
                              },
                            ),
                          )
                        : null,
                  ),
                if (!ctrl.customer.value.landline.isNullOrEmpty())
                  item(
                    title: s.landline,
                    child: WTextButton2(
                      text: "${ctrl.customer.value.landline?.trim()}"
                          "${ctrl.customer.value.extension.isNullOrEmpty() ? '' : "(${s.extension}: ${ctrl.customer.value.extension?.trim()})"}",
                      onPressed: () => ULaunch.call(ctrl.customer.value.landline!.trim()),
                      onLongPress: () => UClipboard.set(ctrl.customer.value.landline!.trim()),
                    ),
                  ),
                if (!ctrl.customer.value.fax.isNullOrEmpty())
                  item(
                    title: s.fax,
                    value: ctrl.customer.value.fax,
                  ),
                if (!ctrl.customer.value.website.isNullOrEmpty())
                  item(
                    title: s.website,
                    value: (ctrl.customer.value.website?.isURL ?? false) ? null : ctrl.customer.value.website,
                    child: (ctrl.customer.value.website?.isURL ?? false)
                        ? Flexible(
                            child: WTextButton2(
                              text: ctrl.customer.value.website ?? '',
                              onPressed: () {
                                (ctrl.customer.value.website ?? '').launchMyUrl();
                              },
                            ),
                          )
                        : null,
                  ),
                if (ctrl.customer.value.labels.isNotEmpty)
                  item(
                    title: s.label,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: ctrl.customer.value.labels
                          .map(
                            (final label) => WLabel(
                              text: label.title,
                              color: label.colorCode.toColor(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                if (ctrl.customer.value.industrialActivity != null)
                  item(
                    title: s.industry,
                    value: ctrl.customer.value.industrialActivity?.title,
                  ),
                if (ctrl.customer.value.industrySubcategory != null)
                  item(
                    title: s.category,
                    value: ctrl.customer.value.industrySubcategory?.title,
                  ),
              ],
            ),
          ),
          ExpansionTileItemModel(
            title: s.representativeInfo,
            icon: AppIcons.userOctagonOutline,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                if (agentInfoNotEmpty()) ...[
                  if (!ctrl.customer.value.agentName.isNullOrEmpty())
                    item(
                      title: s.representativeName,
                      value: ctrl.customer.value.agentName,
                    ),
                  if (!ctrl.customer.value.agentPhoneNumber.isNullOrEmpty())
                    item(
                      title: s.phoneNumber,
                      child: WTextButton2(
                        text: ctrl.customer.value.agentPhoneNumber!,
                        onPressed: () => ULaunch.call(ctrl.customer.value.agentPhoneNumber!.trim()),
                        onLongPress: () => UClipboard.set(ctrl.customer.value.agentPhoneNumber!.trim()),
                      ),
                    ),
                  if (!ctrl.customer.value.agentLandline.isNullOrEmpty())
                    item(
                      title: s.landline,
                      child: WTextButton2(
                        text: "${ctrl.customer.value.agentLandline?.trim()}"
                            "${ctrl.customer.value.agentLandlineExt.isNullOrEmpty() ? '' : "(${s.extension}: ${ctrl.customer.value.agentLandlineExt?.trim()})"}",
                        onPressed: () => ULaunch.call(ctrl.customer.value.agentLandline!.trim()),
                        onLongPress: () => UClipboard.set(ctrl.customer.value.agentLandline!.trim()),
                      ),
                    ),
                  if (!ctrl.customer.value.agentPosition.isNullOrEmpty())
                    item(
                      title: s.role,
                      value: ctrl.customer.value.agentPosition,
                    ),
                  if (!ctrl.customer.value.agentLink.isNullOrEmpty())
                    item(
                      title: s.link,
                      value: ctrl.customer.value.agentLink?.isURL ?? false ? null : ctrl.customer.value.agentLink,
                      child: (ctrl.customer.value.agentLink?.isURL ?? false)
                          ? Flexible(
                              child: WTextButton2(
                                text: ctrl.customer.value.agentLink ?? '',
                                onPressed: () {
                                  (ctrl.customer.value.agentLink ?? '').launchMyUrl();
                                },
                              ),
                            )
                          : null,
                    ),
                  if (!ctrl.customer.value.agentEmail.isNullOrEmpty())
                    item(
                      title: s.email,
                      value: ctrl.customer.value.agentEmail?.isEmail ?? false ? null : ctrl.customer.value.agentEmail,
                      child: (ctrl.customer.value.agentEmail?.isEmail ?? false)
                          ? Flexible(
                              child: WTextButton2(
                                text: ctrl.customer.value.agentEmail ?? '',
                                onPressed: () {
                                  ULaunch.email(ctrl.customer.value.agentEmail ?? '', '');
                                },
                              ),
                            )
                          : null,
                    ),
                ] else
                  SizedBox(height: 70, child: Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor))),
              ],
            ),
          ),
          ExpansionTileItemModel(
            title: s.location,
            icon: AppIcons.locationOutline,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                if (locationInfoNotEmpty()) ...[
                  if (ctrl.customer.value.state?.title != null)
                    item(
                      title: s.state,
                      value: ctrl.customer.value.state?.title,
                    ),
                  if (ctrl.customer.value.city?.title != null)
                    item(
                      title: s.city,
                      value: ctrl.customer.value.city?.title,
                    ),
                  if (!ctrl.customer.value.postalCode.isNullOrEmpty())
                    item(
                      title: s.postalCode,
                      value: ctrl.customer.value.postalCode,
                    ),
                  if (!ctrl.customer.value.address.isNullOrEmpty())
                    item(
                      title: s.address,
                      value: ctrl.customer.value.address,
                    ),
                ] else
                  SizedBox(height: 70, child: Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor))),
              ],
            ),
          ),
          ExpansionTileItemModel(
            title: s.additionalInfo,
            icon: AppIcons.info,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                if (additionalInfoNotEmpty()) ...[
                  if (ctrl.customer.value.personalType == AuthenticationType.person && !ctrl.customer.value.nationalCode.isNullOrEmpty())
                    item(
                      title: s.nationalID,
                      value: ctrl.customer.value.nationalCode,
                    ),
                  if (ctrl.customer.value.personalType == AuthenticationType.person && !ctrl.customer.value.birthday.isNullOrEmpty())
                    item(
                      title: s.dateOfBirth,
                      value: ctrl.customer.value.birthday,
                    ),
                  if (ctrl.customer.value.personalType == AuthenticationType.person && !ctrl.customer.value.certificateNumber.isNullOrEmpty())
                    item(
                      title: s.birthCertificateNumber,
                      value: ctrl.customer.value.certificateNumber,
                    ),
                  if (ctrl.customer.value.personalType == AuthenticationType.legal && !ctrl.customer.value.companyNationalCode.isNullOrEmpty())
                    item(
                      title: s.companyNationalID,
                      value: ctrl.customer.value.companyNationalCode,
                    ),
                  if (ctrl.customer.value.personalType == AuthenticationType.legal && !ctrl.customer.value.economicCode.isNullOrEmpty())
                    item(
                      title: s.economicCode,
                      value: ctrl.customer.value.economicCode,
                    ),
                  if (!ctrl.customer.value.shebaNumber.isNullOrEmpty())
                    item(
                      title: s.iban,
                      child: WTextButton2(
                        text: ctrl.customer.value.shebaNumber?.ibanFormat() ?? '',
                        onPressed: () => UClipboard.set(ctrl.customer.value.shebaNumber?.ibanFormat() ?? ''),
                      ),
                    ),
                ] else
                  SizedBox(height: 70, child: Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
