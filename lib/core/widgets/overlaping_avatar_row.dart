part of 'widgets.dart';

class WOverlappingAvatarRow extends StatelessWidget {
  const WOverlappingAvatarRow({
    required this.users,
    this.maxVisibleAvatars = 4,
    this.avatarSize = 30.0,
    this.overlapFactor = 0.6, // ۶۰ درصد کنارتر قرار می‌گیرد
    super.key,
  });

  /// List of Users with [UserReadDto]
  final List<UserReadDto> users;

  /// Max Count of Avatar That Display and for More Than This will Display +n
  final int maxVisibleAvatars;

  /// Size of Each Avatar
  final double avatarSize;

  /// Between 0.0 and 1.0
  final double overlapFactor;

  /// Border of Each Avatar
  final double avatarBorderWidth = 2;

  @override
  Widget build(final BuildContext context) {
    final int visibleCount = users.length > maxVisibleAvatars ? maxVisibleAvatars : users.length;

    final double totalWidth = visibleCount > 0 ? avatarSize + (visibleCount - 1) * avatarSize * overlapFactor : 0;

    return SizedBox(
      width: totalWidth + (avatarBorderWidth * 2),
      height: avatarSize + (avatarBorderWidth * 2),
      child: Stack(
        children: List.generate(visibleCount, (final index) {
          if (index == maxVisibleAvatars - 1 && users.length > maxVisibleAvatars) {
            final int remainingCount = users.length - (maxVisibleAvatars - 1);
            return _buildMoreCountAvatar(context, index, remainingCount);
          }
          // در غیر این صورت، آواتار کاربر را نمایش بده
          return _buildAvatar(index, users[index]);
        }).toList(),
      ),
    );
  }

  // ویجت کمکی برای ساخت آواتار هر کاربر
  Widget _buildAvatar(final int index, final UserReadDto user) {
    bool isRtl = isPersianLang;

    return Positioned(
      right: isRtl ? index * avatarSize * overlapFactor : null,
      left: !isRtl ? index * avatarSize * overlapFactor : null,
      child: Container(
        // یک حاشیه سفید برای ایجاد فاصله بصری
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: avatarBorderWidth),
        ),
        child: WCircleAvatar(
          size: avatarSize,
          user: user,
          showImageFullScreen: false,
        ),
      ),
    );
  }

  // ویجت کمکی برای ساخت آواتار "+N"
  Widget _buildMoreCountAvatar(final BuildContext context, final int index, final int count) {
    bool isRtl = isPersianLang;

    return Positioned(
      right: isRtl ? index * avatarSize * overlapFactor : null,
      left: !isRtl ? index * avatarSize * overlapFactor : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: avatarBorderWidth),
        ),
        child: CircleAvatar(
          radius: avatarSize / 2,
          backgroundColor: context.theme.dividerColor,
          child: Text('+$count').bodyMedium(),
        ),
      ),
    );
  }
}
