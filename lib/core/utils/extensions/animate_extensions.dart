// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//
// import '../../../../core/core.dart';
//
// extension AnimateExtensions on Widget {
//   /// Use if want to animate with scrolling
//   /// Must add above of [ListView], [GridView], [Column] or [Row]
//   Widget animationLimiter() => AnimationLimiter(child: this);
//
//   /// Use for each widget in List
//   Widget animateListSlideFadeIn(
//     final int index, {
//     final Axis direction = Axis.horizontal,
//     final double? offset,
//     final Curve curve = Curves.ease,
//   }) =>
//       AnimationConfiguration.staggeredList(
//         position: index,
//         duration: const Duration(milliseconds: 375),
//         child: SlideAnimation(
//           verticalOffset: direction == Axis.vertical ? offset ?? 50 : null,
//           horizontalOffset: direction == Axis.horizontal ? offset ?? (isPersianLang ? -50 : 50) : null,
//           curve: curve,
//           child: FadeInAnimation(
//             child: this,
//           ),
//         ),
//       );
//
//   /// Use for each widget in List
//   Widget animateGridSlideFadeIn(
//     final int index, {
//     required final int columnCount,
//     final Curve curve = Curves.ease,
//   }) =>
//       AnimationConfiguration.staggeredGrid(
//         position: index,
//         duration: const Duration(milliseconds: 375),
//         columnCount: columnCount,
//         child: ScaleAnimation(
//           curve: curve,
//           child: FadeInAnimation(
//             child: this,
//           ),
//         ),
//       );
// }
//
// extension AnimateChildrenExtensions on List<Widget> {
//   /// Use for [children] of [Column] Or [Row]
//   List<Widget> animateListSlideFadeIn(
//       final int index, {
//         final Axis direction = Axis.horizontal,
//         final double? offset,
//         final Curve curve = Curves.ease,
//       }) =>
//       AnimationConfiguration.toStaggeredList(
//         duration: const Duration(milliseconds: 375),
//         childAnimationBuilder: (final widget) => SlideAnimation(
//           verticalOffset: direction == Axis.vertical ? offset ?? 50 : null,
//           horizontalOffset: direction == Axis.horizontal ? offset ?? (isPersianLang ? -50 : 50) : null,
//           curve: curve,
//           child: FadeInAnimation(
//             child: widget,
//           ),
//         ),
//         children: this,
//       );
// }
