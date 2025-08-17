import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  State<EmergencyAlertsScreen> createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Sample data with like status
  final List<Map<String, dynamic>> _myReports = [
    {
      'id': '1',
      'title': 'Car Accident',
      'description': 'Major collision on Main Street',
      'imageUrl': 'https://example.com/accident.jpg',
      'timestamp': '2 hours ago',
      'location': 'Downtown',
      'category': 'Accident',
      'isMine': true,
      'likes': 12,
      'isLiked': false,
      'comments': 3,
    },
    {
      'id': '2',
      'title': 'Fire Outbreak',
      'description': 'Building fire near the park',
      'imageUrl': 'https://example.com/fire.jpg',
      'timestamp': '5 hours ago',
      'location': 'Central Park',
      'category': 'Fire',
      'isMine': true,
      'likes': 24,
      'isLiked': true,
      'comments': 7,
    },
  ];

  final List<Map<String, dynamic>> _otherReports = [
    {
      'id': '3',
      'title': 'Power Outage',
      'description': 'Whole block without electricity',
      'imageUrl': 'https://example.com/power.jpg',
      'timestamp': '1 day ago',
      'location': 'North District',
      'category': 'Utility',
      'isMine': false,
      'likes': 42,
      'isLiked': false,
      'comments': 5,
    },
    {
      'id': '4',
      'title': 'Flood Warning',
      'description': 'River overflowing its banks',
      'imageUrl': 'https://example.com/flood.jpg',
      'timestamp': '2 days ago',
      'location': 'Riverside',
      'category': 'Natural Disaster',
      'isMine': false,
      'likes': 89,
      'isLiked': false,
      'comments': 14,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike(Map<String, dynamic> report) {
    setState(() {
      report['isLiked'] = !report['isLiked'];
      report['likes'] += report['isLiked'] ? 1 : -1;
    });
  }

  void _showComments(BuildContext context, String reportId) {
    final userNames = ['Alex Johnson', 'Sam Wilson', 'Taylor Smith', 'Jordan Lee', 'Casey Kim'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(userNames[index]),
                  subtitle: const Text('This is a sample comment...'),
                  trailing: TextButton(
                    child: const Text('Reply'),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareReport(Map<String, dynamic> report) async {
    final String shareText =
        'Emergency Alert: ${report['title']}\n${report['description']}\nLocation: ${report['location']}';

    try {
      final Uri shareUri = Uri(
        scheme: 'https',
        host: 'smartcivicwatch.com',
        path: '/alerts/${report['id']}',
        queryParameters: {'utm_source': 'app_share'},
      );

      if (await canLaunchUrl(shareUri)) {
        await launchUrl(shareUri);
      } else {
        throw 'Could not launch share URL';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, Color? color) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: report['imageUrl'],
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                height: 200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                height: 200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      report['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(report['category']),
                      backgroundColor: report['isMine']
                          ? Colors.blue[100]
                          : Colors.green[100],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  report['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(report['location']),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(report['timestamp']),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      report['isLiked'] ? Icons.favorite : Icons.favorite_border,
                      '${report['likes']}',
                          () => _toggleLike(report),
                      report['isLiked'] ? Colors.red : null,
                    ),
                    _buildActionButton(
                      Icons.comment,
                      '${report['comments']}',
                          () => _showComments(context, report['id']),
                      null,
                    ),
                    _buildActionButton(
                      Icons.share,
                      'Share',
                          () => _shareReport(report),
                      null,
                    ),
                    if (report['isMine'])
                      _buildActionButton(
                        Icons.delete,
                        'Delete',
                            () {}, // Add delete functionality
                        Colors.red,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alerts'),
        backgroundColor: const Color(0xFF283593),
        elevation: 10,
        shadowColor: Colors.indigoAccent.withOpacity(0.6),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('My Reports', 0),
                _buildCategoryButton('Community', 1),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildReportsList(_myReports),
          _buildReportsList(_otherReports),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, int index) {
    return TextButton(
      onPressed: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: _currentIndex == index ? Colors.white : Colors.white70,
        backgroundColor: _currentIndex == index
            ? Colors.indigoAccent
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReportsList(List<Map<String, dynamic>> reports) {
    return reports.isEmpty
        ? const Center(child: Text('No reports available'))
        : ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return _buildReportCard(reports[index], context);
      },
    );
  }
}