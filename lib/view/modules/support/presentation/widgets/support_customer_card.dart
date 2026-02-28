import 'package:u/utilities.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_customer_entity.dart';
import '../../domain/entities/support_room_entity.dart';

class SupportCustomerCard extends StatelessWidget {
  const SupportCustomerCard({
    required this.customer,
    this.onTap,
    super.key,
  });

  final SupportCustomer customer;
  final Function(SupportRoomEntity)? onTap;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              const UImage(AppIcons.userOctagonOutline, size: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      customer.fullName ?? customer.phoneNumber ?? 'Unknown Customer',
                      maxLines: 1,
                    ).bodyMedium(overflow: .ellipsis),
                    if (customer.phoneNumber != null)
                      Text(
                        customer.phoneNumber!,
                        maxLines: 1,
                      ).bodySmall(overflow: .ellipsis),
                  ],
                ),
              ),
            ],
          ),
          if (customer.rooms.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...List<Widget>.generate(
              customer.rooms.length,
              (final index) {
                final room = customer.rooms[index];
                return _buildRoomCard(context, room);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoomCard(final BuildContext context, final SupportRoomEntity room) {
    return WCard(
      margin: .zero,
      elevation: 0,
      showBorder: true,
      horPadding: 12,
      verPadding: 6,
      color: context.theme.hintColor.withValues(alpha: 0.1),
      borderWidth: 1,
      onTap: onTap != null ? () => onTap?.call(room) : null,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 4,
        children: [
          Row(
            children: [
              UImage(AppIcons.chatOutline, size: 2, color: context.theme.primaryColorDark),
              const SizedBox(width: 10),
              Text(
                room.lastMessage?.type.title ?? room.lastMessage?.body ?? '',
                maxLines: 1,
              ).bodySmall(overflow: .ellipsis).expanded(),
              const SizedBox(width: 5),
              WLabel(
                text: room.status.title,
                color: room.status.color,
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              WCircleAvatar(user: room.assignedOperator, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
