import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showIssueSheet(BuildContext context, String title, String desc) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          const SizedBox(height: 16),
          TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Describe your issue...')),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: ElevatedButton.icon(
              onPressed: () { Navigator.pop(context); _launchUrl('https://wa.me/${AppStrings.supportWA}?text=${Uri.encodeComponent("Issue: $title\n${ctrl.text}")}'); },
              icon: const Text('💬'), label: const Text('WhatsApp'))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
              onPressed: () { Navigator.pop(context); _launchUrl('tel:${AppStrings.supportPhone}'); },
              icon: const Icon(Icons.phone), label: const Text('Call Now'))),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final issues = [
      {'icon': Icons.inventory_2_outlined, 'color': AppColors.primary, 'title': 'Where is my order?', 'desc': 'Tell us your order ID.'},
      {'icon': Icons.currency_exchange,    'color': AppColors.green,   'title': 'Refund Status',       'desc': 'Share your order ID.'},
      {'icon': Icons.cancel_outlined,      'color': Colors.redAccent,  'title': 'Cancel My Order',     'desc': 'Share your order ID to cancel.'},
      {'icon': Icons.help_outline,         'color': AppColors.secondary,'title': 'Other Issues',       'desc': 'Tell us your issue.'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
          child: Column(children: issues.asMap().entries.map((e) {
            final i = e.key; final item = e.value;
            return Column(children: [
              GestureDetector(
                onTap: () => _showIssueSheet(context, item['title'] as String, item['desc'] as String),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(children: [
                  Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                  const SizedBox(width: 14),
                  Expanded(child: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                  const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
                ])),
              ),
              if (i < issues.length - 1) Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
            ]);
          }).toList()),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _launchUrl('https://wa.me/${AppStrings.supportWA}?text=Hi, I need help with my TezDrop order'),
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14), margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBF7D0))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('💬', style: TextStyle(fontSize: 20)), SizedBox(width: 8),
              Text('Chat on WhatsApp', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 14)),
            ])),
        ),
        GestureDetector(
          onTap: () => _launchUrl('tel:${AppStrings.supportPhone}'),
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBFDBFE))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.phone, color: AppColors.blue, size: 20), SizedBox(width: 8),
              Text('Call: +91 90580 55350', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
            ])),
        ),
      ]),
    );
  }
}
