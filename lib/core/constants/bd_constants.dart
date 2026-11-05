import 'package:flutter/material.dart';

/// Bangladeshi Geographies, Intent Types, and Cultural Constants
class BDConstants {
  static const String appName = 'Porichoy';
  static const String appNameBangla = 'পরিচয়';
  static const String appTagline = 'Meaningful, Privacy-First Connections in Bangladesh';

  // 8 Administrative Divisions of Bangladesh
  static const List<String> divisions = [
    'Dhaka',
    'Chattogram',
    'Sylhet',
    'Rajshahi',
    'Khulna',
    'Barishal',
    'Rangpur',
    'Mymensingh',
  ];

  // Popular Areas across Major Cities
  static const Map<String, List<String>> popularAreas = {
    'Dhaka': [
      'Gulshan-1',
      'Gulshan-2',
      'Banani',
      'Dhanmondi',
      'Uttara',
      'Bashundhara R/A',
      'Mohakhali',
      'Mirpur DOHS',
      'Baridhara DOHS',
      'Mohammadpur',
      'Lalmatia',
      'Khilgaon',
      'Old Dhaka',
    ],
    'Chattogram': [
      'GEC Circle',
      'Agrabad',
      'Khulshi',
      'Nasirabad',
      'Panchlaish',
      'Halishahar',
    ],
    'Sylhet': [
      'Zindabazar',
      'Upashahar',
      'Kumarpara',
      'Shibgonj',
      'Amberkhana',
    ],
    'Rajshahi': [
      'Shaheb Bazar',
      'Kazihata',
      'Padma Residential',
      'Motihar',
    ],
  };

  // Prominent Educational Institutions in Bangladesh
  static const List<String> popularInstitutions = [
    'Dhaka University (DU)',
    'BUET',
    'IBA, University of Dhaka',
    'North South University (NSU)',
    'BRAC University',
    'Dhaka Medical College (DMC)',
    'IUT (Gazipur)',
    'Chittagong University (CU)',
    'Shahjalal University of Science & Technology (SUST)',
    'Armed Forces Medical College (AFMC)',
    'East West University (EWU)',
    'Independent University Bangladesh (IUB)',
    'AIUB',
    'Jahangirnagar University (JU)',
  ];

  // Intent Types
  static const Map<String, ({String title, String titleBangla, String desc, IconData icon})> intents = {
    'meaningful_dating': (
      title: 'Meaningful Dating',
      titleBangla: 'দীর্ঘমেয়াদী সম্পর্ক',
      desc: 'Looking to build an emotional connection and see where it leads',
      icon: Icons.favorite_outline_rounded,
    ),
    'serious_marriage': (
      title: 'Marriage Minded',
      titleBangla: 'বিবাহের পরিকল্পনা',
      desc: 'Ready for serious commitment with aligned values',
      icon: Icons.diamond_outlined,
    ),
    'coffee_and_chat': (
      title: 'Coffee & Chat',
      titleBangla: 'আড্ডা ও বন্ধুত্ব',
      desc: 'Meeting thoughtful individuals for coffee, food, and culture',
      icon: Icons.coffee_outlined,
    ),
    'halal_modest': (
      title: 'Modest & Halal',
      titleBangla: 'শালীন ও মূল্যবোধ ভিত্তিক',
      desc: 'Respectful, values-first dating honoring personal boundaries',
      icon: Icons.shield_outlined,
    ),
  };

  // Cultural Conversation Prompts for BD
  static const List<String> defaultPrompts = [
    'My holy grail food spot in Dhaka is...',
    'The most underrated place in Bangladesh to unwind...',
    'A Sunday afternoon well spent in my world looks like...',
    'Green flags I deeply value in someone...',
    'Old Dhaka Kacchi or Cha-biscuit at TSC?',
    'My philosophy on balancing career, family, and personal freedom...',
  ];
}

