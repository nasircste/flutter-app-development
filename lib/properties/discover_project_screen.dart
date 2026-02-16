import 'package:flutter/material.dart';
import '../../models/project_discover_model.dart';

class DiscoverProjectsScreen extends StatefulWidget {
  const DiscoverProjectsScreen({super.key});

  @override
  State<DiscoverProjectsScreen> createState() =>
      _DiscoverProjectsScreenState();
}

class _DiscoverProjectsScreenState extends State<DiscoverProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProjectDiscoverModel> _getCurrentTabProjects() {
    switch (_tabController.index) {
      case 0:
        return ongoingProjects;
      case 1:
        return completedProjects;
      case 2:
        return upcomingProjects;
      default:
        return ongoingProjects;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF3F3F3F),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 3),
                    const Text(
                      'Discover Projects',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3F3F3F),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEEEEEE),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, top: 16.0, bottom: 17),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    onTap: (index) {
                      setState(() {});
                    },
                    labelColor: const Color(0xFF1F89B7),
                    unselectedLabelColor: const Color(0xFFA9A9A9),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    indicator: BoxDecoration(
                      color: const Color(0xFFE7F2F6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'On-going'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Upcoming'),
                    ],
                  ),
                ),
              ),
              _buildProjectsGrid(_getCurrentTabProjects()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(List<ProjectDiscoverModel> projects) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.85,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return _ProjectCard(project: projects[index]);
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectDiscoverModel project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x52000000),
            offset: Offset(0, 0),
            blurRadius: 7,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              project.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.apartment,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      project.location,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
