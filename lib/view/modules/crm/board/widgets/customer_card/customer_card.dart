import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../../customer/customer_page.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../widgets/customer_steps/customer_steps.dart';
import '../../../../../../core/widgets/follow_up_card/follow_up_card.dart';
import 'customer_card_controller.dart';

class WCustomerCard extends StatefulWidget {
  const WCustomerCard({
    required this.customer,
    required this.onChangedCheckBox,
    required this.onStepChanged,
    required this.onEdit,
    required this.onDelete,
    required this.outerScrollController,
    this.moreButtonBuilder,
    this.canEdit = true,
    super.key,
  });

  final CustomerReadDto customer;
  final Function(CustomerReadDto customer) onChangedCheckBox;
  final Function(CustomerReadDto customer) onStepChanged;
  final Function(CustomerReadDto customer) onEdit;
  final Function(CustomerReadDto customer) onDelete;
  final WidgetBuilder? moreButtonBuilder;
  final ScrollController outerScrollController;
  final bool canEdit;

  @override
  State<WCustomerCard> createState() => _WCustomerCardState();
}

class _WCustomerCardState extends State<WCustomerCard> with CustomerCardController {
  bool get canEdit => widget.canEdit;

  @override
  void initState() {
    customer(widget.customer);
    super.initState();
  }

  @override
  void dispose() {
    customer.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WCustomerCard oldWidget) {
    if (oldWidget.customer.id != widget.customer.id) {
      customer(widget.customer);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (final notification) {
        if (notification.depth != 0) return false;

        // ---- حالت اول: کاربر در حال کشیدن در لبه‌ها است ----
        if (notification is OverscrollNotification) {
          final double newOffset = widget.outerScrollController.position.pixels + notification.overscroll;
          final double clampedOffset = newOffset.clamp(
            widget.outerScrollController.position.minScrollExtent,
            widget.outerScrollController.position.maxScrollExtent,
          );
          if (clampedOffset != widget.outerScrollController.position.pixels) {
            widget.outerScrollController.jumpTo(clampedOffset);
          }
          return true;
        }

        return false;
      },
      child: Obx(
        () => WCard(
          showBorder: true,
          onTap: () {
            delay(200, () {
              UNavigator.push(CustomerPage(
                customer: customer.value,
                canEdit: canEdit,
                onEdit: (final model) {
                  if (customer.subject.isClosed) return;
                  customer(model);
                  widget.onEdit(customer.value);
                },
                onDelete: widget.onDelete,
              ));
            });
          },
          child: Container(
            constraints: const BoxConstraints(minWidth: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    if (canEdit)
                      WCheckBox(
                        isChecked: customer.value.isFollowed, // Current checked state
                        onChanged: (final value) => onTapCheckBox(onSubmitted: widget.onChangedCheckBox),
                      ),
                    WCircleAvatar(
                      user: UserReadDto(id: '', avatarUrl: customer.value.avatar?.url, fullName: customer.value.fullNameOrCompanyName),
                      size: 35,
                      showFullName: true,
                    ).expanded(),
                    if (canEdit == false && widget.moreButtonBuilder != null)
                      Builder(
                        builder: widget.moreButtonBuilder!,
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    /// Call Info
                    if (!customer.value.phoneNumber.isNullOrEmpty() ||
                        !customer.value.landline.isNullOrEmpty() ||
                        !customer.value.agentPhoneNumber.isNullOrEmpty() ||
                        !customer.value.agentLandline.isNullOrEmpty())
                      _item(
                        icon: AppIcons.callOutline,
                        child: !customer.value.agentPhoneNumber.isNullOrEmpty() || !customer.value.agentLandline.isNullOrEmpty()

                            /// Agent contact info
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if ((customer.value.agentName ?? '') != '')
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          "${customer.value.agentName ?? ''} ${(customer.value.agentPosition ?? '') != '' ? "(${customer.value.agentPosition})" : ''}",
                                        ).bodyMedium().expanded(),
                                        Text(s.representative).bodyMedium(),
                                      ],
                                    ),
                                  if ((customer.value.agentPhoneNumber?.trim() ?? '') != '')
                                    WTextButton2(
                                      text: customer.value.agentPhoneNumber!.trim(),
                                      onPressed: () => ULaunch.call(customer.value.agentPhoneNumber!.trim()),
                                      onLongPress: () => UClipboard.set(customer.value.phoneNumber!.trim()),
                                    ),
                                  if ((customer.value.agentLandline?.trim() ?? '') != '')
                                    WTextButton2(
                                      text: "${customer.value.agentLandline?.trim()}"
                                          "${customer.value.agentLandlineExt.isNullOrEmpty() ? '' : "(${s.extension}: ${customer.value.agentLandlineExt?.trim()})"}",
                                      onPressed: () => ULaunch.call(customer.value.agentLandline!.trim()),
                                      onLongPress: () => UClipboard.set(customer.value.agentLandline!.trim()),
                                    ),
                                ],
                              ).expanded()

                            /// Customer contact info
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if ((customer.value.phoneNumber?.trim() ?? '') != '')
                                    WTextButton2(
                                      text: customer.value.phoneNumber!.trim(),
                                      onPressed: () {
                                        ULaunch.call(customer.value.phoneNumber!.trim());
                                      },
                                      onLongPress: () {
                                        UClipboard.set(customer.value.phoneNumber!.trim());
                                      },
                                    ),
                                  if ((customer.value.landline?.trim() ?? '') != '')
                                    WTextButton2(
                                      text: customer.value.landline!.trim(),
                                      onPressed: () {
                                        ULaunch.call(customer.value.landline!.trim());
                                      },
                                      onLongPress: () {
                                        UClipboard.set(customer.value.landline!.trim());
                                      },
                                    ),
                                ],
                              ),
                      ),
                    if ((customer.value.email?.trim() ?? '') != '')
                      _item(
                          icon: AppIcons.mailOutline,
                          child: WTextButton2(
                            text: customer.value.email!.trim(),
                            onPressed: () {
                              ULaunch.email(customer.value.email!.trim(), '');
                            },
                            onLongPress: () {
                              UClipboard.set(customer.value.email!.trim());
                            },
                          )),

                    // Follow-up list
                    if (canEdit)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: customer.value.followUps.length,
                            physics: customer.value.followUps.length <= 3 ? const NeverScrollableScrollPhysics() : null,
                            shrinkWrap: customer.value.followUps.length <= 3,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, customer.value.followUps.length <= 3 ? 0 : 16, 0),
                            itemBuilder: (final context, final index) => WFollowUpCard(
                              followUp: customer.value.followUps[index],
                              shape: FollowUpCardShape.compact,
                              onChanged: (final model) {
                                customer.value.followUps[index] = model;
                                customer.refresh();
                                widget.onEdit(customer.value);
                              },
                              onDelete: () {
                                customer.value.followUps.removeAt(index);
                                // final isThereAnyAssigneeFollowup = customer.value.followUps.any((final e) => e.assignedUser?.id == Core.userReadDto.value.id);
                                // if (!isThereAnyAssigneeFollowup) {
                                //   customer.value.followUpsOwners.removeWhere((final user) => user.id == Core.userReadDto.value.id);
                                // }
                                customer.refresh();
                                widget.onEdit(customer.value);
                              },
                            ),
                          ),
                        ),
                      ),
                    // Steps
                    CustomerSteps(
                      customer: customer.value,
                      canEdit: canEdit,
                      onStepChanged: (final model) {
                        customer(model);
                        widget.onStepChanged(customer.value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item({required final String icon, required final Widget child}) => Row(
        spacing: 10,
        children: [
          UImage(icon, size: 25, color: context.theme.primaryColorDark),
          child,
        ],
      );
}
