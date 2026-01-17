import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/project_style.dart';
// import 'package:google_fonts/google_fonts.dart';

class ProjectCards extends StatelessWidget {
  const ProjectCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.70, // Increased to make cards shorter
      ),
      itemBuilder: (context, index) {
        return ProjectCardItem(index: index);
      },
    );
  }
}

class ProjectCardItem extends StatelessWidget {
  final int index;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? projectId;

  const ProjectCardItem({
    super.key,
    required this.index,
    this.startDate,
    this.endDate,
    this.projectId,
  });

  double _calculateFontSize(String countText) {
    if (countText.length > 3) {
      return 24;
    } else if (countText.length > 2) {
      return 28;
    }
    return 32;
  }

  String _getProjectName(String projectId) {
    final AuthService authService = Get.find<AuthService>();
    final project = authService.projects.firstWhere(
      (p) => p['id'] == projectId,
      orElse: () => {'name': ''},
    );
    return project['name'] ?? '';
  }

  Future<int> _fetchRobustCount({
    required String collectionName,
    required String dateField,
    required String idField,
    required String nameField,
    required String projectId,
    List<String>? statusList,
    String? statusField,
  }) async {
    final projectName = _getProjectName(projectId);

    // Base Query Builder
    Query buildQuery(String field, String value) {
      Query query = FirebaseFirestore.instance.collection(collectionName);

      if (startDate != null && endDate != null) {
        int startMillis = startDate!.millisecondsSinceEpoch;
        int endMillis = endDate!.millisecondsSinceEpoch;
        query = query
            .where(dateField, isGreaterThanOrEqualTo: startMillis)
            .where(dateField, isLessThan: endMillis);
      }

      query = query.where(field, isEqualTo: value);

      if (statusList != null && statusList.isNotEmpty && statusField != null) {
        query = query.where(statusField, whereIn: statusList);
      }
      return query;
    }

    // Run ID Query
    try {
      final idQuery = buildQuery(idField, projectId);
      final idSnapshot = await idQuery.count().get();
      final idCount = idSnapshot.count ?? 0;
      if (idCount > 0) return idCount;
    } catch (e) {
      debugPrint(
        "⚠️ ID Query failed (likely missing index), attempting Fallback: $e",
      );
    }

    // Run Name Query (Fallback)
    if (projectName.isNotEmpty) {
      final nameQuery = buildQuery(nameField, projectName);
      final nameSnapshot = await nameQuery.count().get();
      return nameSnapshot.count ?? 0;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        // Leads Card
        final AuthService authService = Get.find<AuthService>();

        return Obx(() {
          final String collectionName = authService.leadsCollectionName.value;

          if (collectionName.isEmpty) {
            return _projectCard(
              context: context,
              title: "...",
              subtitle: "Leads",
              icon: Icons.people_outline_rounded,
              iconColor: const Color(0xFF2C9F6E),
            );
          }

          if (projectId == null) {
            // "All Projects" logic (No filtering by project)
            Query collection = FirebaseFirestore.instance.collection(
              collectionName,
            );
            if (startDate != null && endDate != null) {
              int startMillis = startDate!.millisecondsSinceEpoch;
              int endMillis = endDate!.millisecondsSinceEpoch;
              collection = collection
                  .where('Date', isGreaterThanOrEqualTo: startMillis)
                  .where('Date', isLessThan: endMillis);
            }
            return FutureBuilder<AggregateQuerySnapshot>(
              future: collection.count().get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("❌ Error in Leads Card: ${snapshot.error}");
                  return _projectCard(
                    context: context,
                    title: "0",
                    subtitle: "Leads",
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF2C9F6E),
                  );
                }
                String countText = "10";
                if (snapshot.hasData) {
                  countText = ProjectStyle.formatCurrency(snapshot.data!.count);
                }
                return _projectCard(
                  context: context,
                  title: countText,
                  titleFontSize: _calculateFontSize(countText),
                  subtitle: "Leads",
                  icon: Icons.people_outline_rounded,
                  iconColor: const Color(0xFF2C9F6E),
                );
              },
            );
          }

          // Specific Project Logic
          return FutureBuilder<int>(
            future: _fetchRobustCount(
              collectionName: collectionName,
              dateField: 'Date',
              idField: 'ProjectId',
              nameField: 'Project',
              projectId: projectId!,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("❌ Error in Leads Card: ${snapshot.error}");
                return _projectCard(
                  context: context,
                  title: "0",
                  subtitle: "Leads",
                  icon: Icons.people_outline_rounded,
                  iconColor: const Color(0xFF2C9F6E),
                );
              }

              String countText = "10"; // Default/Loading
              if (snapshot.hasData) {
                countText = ProjectStyle.formatCurrency(snapshot.data!);
              }

              return _projectCard(
                context: context,
                title: countText,
                titleFontSize: _calculateFontSize(countText),
                subtitle: "Leads",
                icon: Icons.people_outline_rounded,
                iconColor: const Color(0xFF2C9F6E),
              );
            },
          );
        });
      case 1:
        // Bookings Card
        final AuthService authService = Get.find<AuthService>();

        return Obx(() {
          final String collectionName = authService.leadsCollectionName.value;

          if (collectionName.isEmpty) {
            return _projectCard(
              context: context,
              title: "...",
              subtitle: "Bookings",
              icon: Icons.bookmark_outline_rounded,
              iconColor: const Color(0xFF6B9EB8),
            );
          }

          if (projectId == null) {
            Query collection = FirebaseFirestore.instance.collection(
              collectionName,
            );
            if (startDate != null && endDate != null) {
              int startMillis = startDate!.millisecondsSinceEpoch;
              int endMillis = endDate!.millisecondsSinceEpoch;
              collection = collection
                  .where('Date', isGreaterThanOrEqualTo: startMillis)
                  .where('Date', isLessThan: endMillis);
            }
            collection = collection.where('Status', isEqualTo: 'booked');

            return FutureBuilder<AggregateQuerySnapshot>(
              future: collection.count().get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("❌ Error in Bookings Card: ${snapshot.error}");
                  return _projectCard(
                    context: context,
                    title: "0",
                    subtitle: "Bookings",
                    icon: Icons.bookmark_outline_rounded,
                    iconColor: const Color(0xFF6B9EB8),
                  );
                }
                String countText = "10";
                if (snapshot.hasData) {
                  countText = ProjectStyle.formatCurrency(snapshot.data!.count);
                }
                return _projectCard(
                  context: context,
                  title: countText,
                  titleFontSize: _calculateFontSize(countText),
                  subtitle: "Bookings",
                  icon: Icons.bookmark_outline_rounded,
                  iconColor: const Color(0xFF6B9EB8),
                );
              },
            );
          }

          // Specific Project Logic
          return FutureBuilder<int>(
            future: _fetchRobustCount(
              collectionName: collectionName,
              dateField: 'Date',
              idField: 'ProjectId',
              nameField: 'Project',
              projectId: projectId!,
              statusField: 'Status',
              statusList: ['booked'],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("❌ Error in Bookings Card: ${snapshot.error}");
                return _projectCard(
                  context: context,
                  title: "0",
                  subtitle: "Bookings",
                  icon: Icons.bookmark_outline_rounded,
                  iconColor: const Color(0xFF6B9EB8),
                );
              }
              String countText = "10";
              if (snapshot.hasData) {
                countText = ProjectStyle.formatCurrency(snapshot.data!);
              }
              return _projectCard(
                context: context,
                title: countText,
                titleFontSize: _calculateFontSize(countText),
                subtitle: "Bookings",
                icon: Icons.bookmark_outline_rounded,
                iconColor: const Color(0xFF6B9EB8),
              );
            },
          );
        });
      case 2:
        // Qualified Card
        final AuthService authService = Get.find<AuthService>();

        return Obx(() {
          final String collectionName = authService.leadsCollectionName.value;

          if (collectionName.isEmpty) {
            return _projectCard(
              context: context,
              title: "...",
              subtitle: "Qualified",
              icon: Icons.verified_outlined,
              iconColor: const Color(0xFFB8866B),
            );
          }

          if (projectId == null) {
            Query baseCollection = FirebaseFirestore.instance.collection(
              collectionName,
            );
            if (startDate != null && endDate != null) {
              int startMillis = startDate!.millisecondsSinceEpoch;
              int endMillis = endDate!.millisecondsSinceEpoch;
              baseCollection = baseCollection
                  .where('Date', isGreaterThanOrEqualTo: startMillis)
                  .where('Date', isLessThan: endMillis);
            }
            // Status Filter for Qualified
            baseCollection = baseCollection.where(
              'Status',
              whereIn: [
                'new',
                'followup',
                'visitfixed',
                'visitdone',
                'negotiation',
                'prospect',
              ],
            );
            return FutureBuilder<AggregateQuerySnapshot>(
              future: baseCollection.count().get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("❌ Error in Qualified Card: ${snapshot.error}");
                  return _projectCard(
                    context: context,
                    title: "0",
                    subtitle: "Qualified",
                    icon: Icons.verified_outlined,
                    iconColor: const Color(0xFFB8866B),
                  );
                }
                String countText = "10";
                if (snapshot.hasData) {
                  countText = ProjectStyle.formatCurrency(snapshot.data!.count);
                }
                return _projectCard(
                  context: context,
                  title: countText,
                  titleFontSize: _calculateFontSize(countText),
                  subtitle: "Qualified",
                  icon: Icons.verified_outlined,
                  iconColor: const Color(0xFFB8866B),
                );
              },
            );
          }

          // Specific Project Logic
          return FutureBuilder<int>(
            future: _fetchRobustCount(
              collectionName: collectionName,
              dateField: 'Date',
              idField: 'ProjectId',
              nameField: 'Project',
              projectId: projectId!,
              statusField: 'Status',
              statusList: [
                'new',
                'followup',
                'visitfixed',
                'visitdone',
                'negotiation',
                'prospect',
              ],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("❌ Error in Qualified Card: ${snapshot.error}");
                return _projectCard(
                  context: context,
                  title: "0",
                  subtitle: "Qualified",
                  icon: Icons.verified_outlined,
                  iconColor: const Color(0xFFB8866B),
                );
              }

              String countText = "10"; // Default/Loading
              if (snapshot.hasData) {
                countText = ProjectStyle.formatCurrency(snapshot.data!);
              }

              return _projectCard(
                context: context,
                title: countText,
                titleFontSize: _calculateFontSize(countText),
                subtitle: "Qualified",
                icon: Icons.verified_outlined,
                iconColor: const Color(0xFFB8866B),
              );
            },
          );
        });
      default:
        // Unqualified Card (Total - Qualified)
        final AuthService authService = Get.find<AuthService>();

        return Obx(() {
          final String collectionName = authService.leadsCollectionName.value;

          if (collectionName.isEmpty) {
            return _projectCard(
              context: context,
              title: "...",
              subtitle: "Unqualified",
              // icon: Icons.thumb_down_off_alt_outlined,
              icon: Icons.cancel_outlined,
              iconColor: const Color(0xFFE57373), // Red/Salmon
            );
          }

          Future<int> fetchUnqualifiedCount() async {
            Query baseQ = FirebaseFirestore.instance.collection(collectionName);
            if (startDate != null && endDate != null) {
              int startMillis = startDate!.millisecondsSinceEpoch;
              int endMillis = endDate!.millisecondsSinceEpoch;
              baseQ = baseQ
                  .where('Date', isGreaterThanOrEqualTo: startMillis)
                  .where('Date', isLessThan: endMillis);
            }

            if (projectId != null) {
              // Robust Fetch for Project Specific
              // We need Total first.
              // Re-using _fetchRobustCount logic internally or simplifying for direct call if easy.
              // Since calculating Total - Qualified requires two queries, we'll do it here.

              int total = await _fetchRobustCount(
                collectionName: collectionName,
                dateField: 'Date',
                idField: 'ProjectId',
                nameField: 'Project',
                projectId: projectId!,
              );

              int qualified = await _fetchRobustCount(
                collectionName: collectionName,
                dateField: 'Date',
                idField: 'ProjectId',
                nameField: 'Project',
                projectId: projectId!,
                statusField: 'Status',
                statusList: [
                  'new',
                  'followup',
                  'visitfixed',
                  'visitdone',
                  'negotiation',
                  'prospect',
                ],
              );
              return total - qualified;
            } else {
              // All Projects
              AggregateQuerySnapshot totalSnap = await baseQ.count().get();
              int total = totalSnap.count ?? 0;

              AggregateQuerySnapshot qualifiedSnap =
                  await baseQ
                      .where(
                        'Status',
                        whereIn: [
                          'new',
                          'followup',
                          'visitfixed',
                          'visitdone',
                          'negotiation',
                          'prospect',
                        ],
                      )
                      .count()
                      .get();
              int qualified = qualifiedSnap.count ?? 0;

              return total - qualified;
            }
          }

          return FutureBuilder<int>(
            future: fetchUnqualifiedCount(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("❌ Error in Unqualified Card: ${snapshot.error}");
                return _projectCard(
                  context: context,
                  title: "0",
                  subtitle: "Unqualified",
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFE57373),
                );
              }
              String countText = "10";
              if (snapshot.hasData) {
                countText = ProjectStyle.formatCurrency(snapshot.data!);
              }
              return _projectCard(
                context: context,
                title: countText,
                titleFontSize: _calculateFontSize(countText),
                subtitle: "Unqualified",
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFFE57373),
              );
            },
          );
        });
    }
  }

  // ---------- CARD ----------
  Widget _projectCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    double titleFontSize = 32,
  }) {
    return Builder(
      builder:
          (context) => GestureDetector(
            onTap: () {
              Get.toNamed(
                '/project_sample',
                arguments: {
                  'projectId': projectId,
                  'startDate': startDate?.millisecondsSinceEpoch,
                  'endDate': endDate?.millisecondsSinceEpoch,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // SUBTLE WAVE BACKGROUND
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePatternPainter(color: iconColor),
                      ),
                    ),

                    // TITLE (Number) - With tight opaque background
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 1,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white, // Opaque white background
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                      ),
                    ),

                    // ICON
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 24, color: iconColor),
                      ),
                    ),

                    // SUBTITLE
                    Positioned(
                      left:
                          2, // Moved 2px from left to prevent going under border
                      bottom: 0,
                      right: 36,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B6B6B),
                        ),
                      ),
                    ),

                    // ARROW
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: Color(0xFF2C9F6E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

// Custom Painter for Flowing Lines Pattern
class _WavePatternPainter extends CustomPainter {
  final Color color;

  _WavePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Starting point near top-left (where the "10" would be)
    final startX = size.width * 0.15;
    final startY = size.height * 0.25;

    // Create multiple flowing horizontal lines
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final yOffset = startY + (i * 6); // Stack lines vertically
      final lineLength = size.width * (0.5 + (i * 0.1)); // Varying lengths

      path.moveTo(startX, yOffset);

      // Create gentle wave flowing to the right
      path.quadraticBezierTo(
        startX + (lineLength * 0.3),
        yOffset - 3, // Slight upward curve
        startX + (lineLength * 0.5),
        yOffset,
      );

      path.quadraticBezierTo(
        startX + (lineLength * 0.7),
        yOffset + 2, // Slight downward curve
        startX + lineLength,
        yOffset - 1,
      );

      // Fade out effect by adjusting opacity for each line
      final linePaint =
          Paint()
            ..color = color.withOpacity(
              0.15 - (i * 0.010),
            ) // Increased from 0.08
            ..style = PaintingStyle.stroke
            ..strokeWidth =
                1.8 -
                (i * 0.2) // Increased from 1.2
            ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
