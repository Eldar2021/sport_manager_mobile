// import 'package:flutter/material.dart';
// import 'package:sport_manager_mobile/features/tables/tables.dart';
// import 'package:sport_manager_mobile/l10n/l10n.dart';
// import 'package:sport_manager_mobile/ui/ui.dart';

// class TableStatsCard extends StatelessWidget {
//   const TableStatsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         borderRadius: AppRadius.cardBorderRadius,
//         boxShadow: context.appColors.shadowSm,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.x4,
//           vertical: AppSpacing.x3,
//         ),
//         child: Column(
//           children: [
//             TableInfoRow(
//               label: l10n.tableDetailLastSession,
//               value: '1 ч 15 мин · 250 сом',
//             ),
//             const SizedBox(height: AppSpacing.x2),
//             TableInfoRow(
//               label: l10n.tableDetailTodaySessions,
//               value: '4',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
