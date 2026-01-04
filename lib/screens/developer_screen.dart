import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'bickymuduli289@gmail.com',
      query: 'subject=AttendEase App Inquiry',
    );
    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Info'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school, size: 32, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          'AttendEase',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A modern Flutter application for managing student attendance with ease and efficiency.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Version: 1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Developer Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 32, color: Colors.green),
                        const SizedBox(width: 12),
                        Text(
                          'Developer',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _InfoRow(
                      icon: Icons.code,
                      label: 'Developed by',
                      value: 'Bicky Muduli',
                    ),
                    _ClickableInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: 'bickymuduli289@gmail.com',
                      onTap: _launchEmail,
                    ),
                    const _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Development Year',
                      value: '2024',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Social Links Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link, size: 32, color: Colors.purple),
                        const SizedBox(width: 12),
                        Text(
                          'Connect with Developer',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SocialLinkTile(
                      icon: Icons.camera_alt,
                      title: 'Instagram',
                      subtitle: '@th3_sh4dow01',
                      url: 'https://www.instagram.com/th3_sh4dow01/',
                      color: Colors.pink,
                      onTap: () =>
                          _launchUrl('https://www.instagram.com/th3_sh4dow01/'),
                    ),
                    const SizedBox(height: 8),
                    _SocialLinkTile(
                      icon: Icons.code_rounded,
                      title: 'GitHub',
                      subtitle: 'th3-sh4dow',
                      url: 'https://github.com/th3-sh4dow',
                      color: Colors.black87,
                      onTap: () => _launchUrl('https://github.com/th3-sh4dow'),
                    ),
                    const SizedBox(height: 8),
                    _SocialLinkTile(
                      icon: Icons.work,
                      title: 'LinkedIn',
                      subtitle: 'Bicky Muduli',
                      url: 'https://linkedin.com/in/@bicky%20muduli',
                      color: Colors.blue,
                      onTap: () =>
                          _launchUrl('https://linkedin.com/in/@bicky%20muduli'),
                    ),
                    const SizedBox(height: 8),
                    _SocialLinkTile(
                      icon: Icons.email_rounded,
                      title: 'Email',
                      subtitle: 'bickymuduli289@gmail.com',
                      url: 'mailto:bickymuduli289@gmail.com',
                      color: Colors.red,
                      onTap: _launchEmail,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Features Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 32, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          'Features',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _FeatureItem(
                      icon: Icons.upload_file,
                      title: 'File Upload',
                      description: 'Import student data from text files',
                    ),
                    const _FeatureItem(
                      icon: Icons.add_circle,
                      title: 'Manual Entry',
                      description:
                          'Add students manually with roll number and name',
                    ),
                    const _FeatureItem(
                      icon: Icons.check_box,
                      title: 'Easy Marking',
                      description: 'Simple checkbox interface for attendance',
                    ),
                    const _FeatureItem(
                      icon: Icons.picture_as_pdf,
                      title: 'PDF Reports',
                      description: 'Generate detailed PDF attendance reports',
                    ),
                    const _FeatureItem(
                      icon: Icons.copy,
                      title: 'Text Export',
                      description: 'Copy attendance data as formatted text',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // // Technology Stack Card
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             const Icon(Icons.build, size: 32, color: Colors.purple),
            //             const SizedBox(width: 12),
            //             Text(
            //               'Technology Stack',
            //               style: Theme.of(context).textTheme.headlineSmall,
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 12),
            //         const _TechItem(
            //           name: 'Flutter',
            //           description: 'UI Framework',
            //           version: '3.9.2+',
            //         ),
            //         const _TechItem(
            //           name: 'Dart',
            //           description: 'Programming Language',
            //           version: '3.9.2+',
            //         ),
            //         const _TechItem(
            //           name: 'file_picker',
            //           description: 'File selection functionality',
            //           version: '8.0.0+1',
            //         ),
            //         const _TechItem(
            //           name: 'pdf',
            //           description: 'PDF generation',
            //           version: '3.10.7',
            //         ),
            //         const _TechItem(
            //           name: 'path_provider',
            //           description: 'File system access',
            //           version: '2.1.2',
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),

            // // Credits Card
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             const Icon(Icons.favorite, size: 32, color: Colors.red),
            //             const SizedBox(width: 12),
            //             Text(
            //               'Credits & Acknowledgments',
            //               style: Theme.of(context).textTheme.headlineSmall,
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 12),
            //         const Text(
            //           '• Flutter team for the amazing framework\n'
            //           '• Open source community for the packages\n'
            //           '• Material Design for UI guidelines\n'
            //           '• All educators who inspired this project',
            //           style: TextStyle(fontSize: 14, height: 1.5),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 24),

            // Footer
            Center(
              child: Column(
                children: [
                  const Text(
                    'Made with ❤️ using Flutter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2024 AttendEase by Bicky Muduli. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ClickableInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ClickableInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Icon(Icons.open_in_new, size: 14, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;
  final Color color;
  final VoidCallback onTap;

  const _SocialLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
