part of 'widgets.dart';

class WCircleAvatar extends StatelessWidget {
  const WCircleAvatar({
    required final UserReadDto? user,
    this.size = 60,
    this.showFullName = false,
    this.onTapImage,
    this.expand = true,
    this.bodySmall = false,
    this.nameColor,
    this.maxLines = 1,
    this.subTitle,
    this.backgroundColor = const Color(0xff517b94),
    this.imageFontSize,
    this.showImageFullScreen = true,
    super.key,
  }) : user = user ?? const UserReadDto(id: ''),
       _userIsNull = user == null;

  final UserReadDto user;
  final double size;
  final bool showFullName;
  final VoidCallback? onTapImage;
  final bool expand;
  final bool bodySmall;
  final Color? nameColor;
  final int maxLines;
  final Widget? subTitle;
  final Color backgroundColor;
  final double? imageFontSize;
  final bool showImageFullScreen;
  final bool _userIsNull;

  @override
  Widget build(final BuildContext context) {
    final showFullScreen = showImageFullScreen && (user.avatarUrl != null || user.avatar?.url != null);

    final List<String> fullName = user.fullName.isNullOrEmpty() ? ['_', '_'] : user.fullName!.split(' ');
    final String compactFullName = fullName.length < 2
        ? (fullName.first.isNotEmpty ? fullName.first[0] : '-')
        : [
            (fullName.first.isNotEmpty ? fullName.first[0] : '-'),
            (fullName[1].isNotEmpty ? fullName[1][0] : '-'),
          ].join('\u200C');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    onTapImage ??
                    (showFullScreen
                        ? () {
                            UNavigator.push(
                              ImagesViewPage(
                                medias: [
                                  MediaReadDto(
                                    url: user.avatarUrl ?? user.avatar?.url ?? '',
                                    id: user.avatar?.fileId?.toString() ?? '',
                                  ),
                                ],
                              ),
                            );
                          }
                        : onTapImage),
                child: CircleAvatar(
                  key: ValueKey('circle_avatar_${user.id}_${size}_$compactFullName'),
                  radius: size / 2,
                  backgroundColor: backgroundColor,
                  foregroundImage: _userIsNull
                      ? const AssetImage(AppImages.defaultProfile)
                      : (!(user.avatarUrl?.startsWith("http") ?? false) == true)
                      ? AssetImage(user.avatarUrl ?? '')
                      : ((user.avatarUrl ?? user.avatar?.url) == null
                            ? null
                            : CachedNetworkImageProvider((user.avatarUrl ?? user.avatar?.url) ?? '')),
                  child: Text(
                    compactFullName,
                  ).bodyMedium(fontSize: imageFontSize, color: Colors.white),
                ),
              ),
              // Material(
              //   color: Colors.transparent,
              //   shape: const CircleBorder(),
              //   clipBehavior: Clip.antiAlias,
              //   child: InkWell(
              //     onTap: onTapImage != null || user.id != ''
              //         ? () {
              //             if (onTapImage != null) {
              //               onTapImage?.call();
              //               return;
              //             }
              //             if (user.id != '') {}
              //           }
              //         : null,
              //   ),
              // ),
            ],
          ).withTooltip(user.fullName ?? ''),
        ),
        if (showFullName && expand && !bodySmall)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullName ?? '',
                maxLines: maxLines,
              ).bodyMedium(overflow: TextOverflow.ellipsis, color: nameColor).marginSymmetric(horizontal: 6),
              if (subTitle != null) subTitle!.marginSymmetric(horizontal: 6),
            ],
          ).expanded(),
        if (showFullName && !expand && !bodySmall)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullName ?? '',
                maxLines: maxLines,
              ).bodyMedium(overflow: TextOverflow.ellipsis, color: nameColor).marginSymmetric(horizontal: 6),
              if (subTitle != null) subTitle!.marginSymmetric(horizontal: 6),
            ],
          ),
        if (showFullName && expand && bodySmall)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullName ?? '',
                maxLines: maxLines,
              ).bodySmall(overflow: TextOverflow.ellipsis, color: nameColor).marginSymmetric(horizontal: 6),
              if (subTitle != null) subTitle!.marginSymmetric(horizontal: 6),
            ],
          ).expanded(),
        if (showFullName && !expand && bodySmall)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullName ?? '',
                maxLines: maxLines,
              ).bodySmall(overflow: TextOverflow.ellipsis, color: nameColor).marginSymmetric(horizontal: 6),
              if (subTitle != null) subTitle!.marginSymmetric(horizontal: 6),
            ],
          ),
      ],
    );
  }
}
