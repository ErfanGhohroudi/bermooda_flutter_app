import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../profile_controller.dart';

class PerformanceTab extends StatelessWidget {
  const PerformanceTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    return Obx(() {
      if (controller.pageState.isLoading()) {
        return const Center(child: WCircularLoading());
      }

      if (controller.hrModuleIsActive == false) {
        return Center(
          child: WErrorWidget(
            iconString: AppIcons.info,
            iconColor: context.theme.hintColor,
            errorTitle: s.hRModuleIsRequired,
            size: 50,
            onTapButton: () {},
          ),
        );
      }

      return Center(
        child: WErrorWidget(
          iconString: AppIcons.info,
          iconColor: context.theme.hintColor,
          errorTitle: s.soon,
          size: 50,
          onTapButton: () {},
        ),
      );

      return SingleChildScrollView(
        child: Column(
          children: [
            // Header with actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "s.performanceEvaluation",
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: controller.addPerformanceEvaluation,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text("s.addEvaluation"),
                  ),
                ],
              ),
            ),

            // Performance Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "s.performanceOverview",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPerformanceMetric(
                            "s.averageRating",
                            '${_getAverageRating()}',
                            Icons.star_outline,
                            Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPerformanceMetric(
                            "s.totalEvaluations",
                            '${controller.performanceEvaluations.length}',
                            Icons.assessment_outlined,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPerformanceMetric(
                            "s.lastEvaluation",
                            _getLastEvaluationDate(),
                            Icons.calendar_today_outlined,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance Chart (Placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "s.performanceTrend",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.theme.dividerColor),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up_outlined,
                              size: 48,
                              color: context.theme.hintColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "s.performanceChartPlaceholder",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance Evaluations List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "s.evaluations",
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.addPerformanceEvaluation,
                          child: Text("s.addEvaluation"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    controller.performanceEvaluations.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assessment_outlined,
                                    size: 48,
                                    color: context.theme.hintColor,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "s.noEvaluations",
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.performanceEvaluations.length,
                            itemBuilder: (context, index) {
                              final evaluation =
                                  controller.performanceEvaluations[index];
                              return _buildEvaluationItem(evaluation, context);
                            },
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Goals and Objectives
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "s.goalsAndObjectives",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGoalsList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildPerformanceMetric(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: Get.theme.hintColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEvaluationItem(
      Map<String, dynamic> evaluation, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                evaluation['period'] ?? "s.unknown",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildRatingStars(evaluation['rating'] ?? 0.0),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildEvaluationDetail(
                  "s.reviewer",
                  evaluation['reviewer'] ?? "s.unknown",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEvaluationDetail(
                  "s.goals",
                  evaluation['goals'] ?? "s.unknown",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.assessment_outlined,
                size: 16,
                color: context.theme.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                "s.overallRating",
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${evaluation['rating'] ?? 0.0}/5.0',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              WMoreButtonIcon<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      _viewEvaluation(evaluation);
                      break;
                    case 'edit':
                      _editEvaluation(evaluation);
                      break;
                    case 'delete':
                      _deleteEvaluation(evaluation);
                      break;
                  }
                },
                items: [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text("s.view"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(s.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outlined,
                            size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(s.delete,
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  Widget _buildEvaluationDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: Get.theme.hintColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList() {
    final goals = [
      {'title': "s.increaseProductivity", 'status': s.inProgress, 'progress': 75},
      {'title': "s.improveCommunication", 'status': s.completed, 'progress': 100},
      {'title': "s.learnNewSkills", 'status': "s.pending", 'progress': 0},
    ];

    return Column(
      children: goals.map((goal) => _buildGoalItem(goal)).toList(),
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Get.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal['title'],
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildGoalStatusChip(goal['status']),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: goal['progress'] / 100,
            backgroundColor: Get.theme.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              goal['status'] == s.completed ? Colors.green : Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${goal['progress']}%',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _getAverageRating() {
    if (controller.performanceEvaluations.isEmpty) return 0.0;

    final total = controller.performanceEvaluations
        .fold(0.0, (sum, eval) => sum + (eval['rating'] ?? 0.0));
    return total / controller.performanceEvaluations.length;
  }

  String _getLastEvaluationDate() {
    if (controller.performanceEvaluations.isEmpty) return "s.unknown";

    // In real app, you'd parse and sort dates properly
    return controller.performanceEvaluations.last['period'] ?? "s.unknown";
  }

  void _viewEvaluation(Map<String, dynamic> evaluation) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("s.evaluationDetails"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow("s.period", evaluation['period']),
              _buildDetailRow("s.rating", '${evaluation['rating']}/5.0'),
              _buildDetailRow("s.reviewer", evaluation['reviewer']),
              _buildDetailRow("s.goals", evaluation['goals']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("s.close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? "s.unknown"),
          ),
        ],
      ),
    );
  }

  void _editEvaluation(Map<String, dynamic> evaluation) {
    // Navigate to edit evaluation page
    controller.showSuccess("s.evaluationEdited");
  }

  void _deleteEvaluation(Map<String, dynamic> evaluation) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("s.deleteEvaluation"),
        content: Text("s.deleteEvaluationConfirmation"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.performanceEvaluations.remove(evaluation);
              controller.showSuccess("s.evaluationDeleted");
            },
            child: Text(s.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
