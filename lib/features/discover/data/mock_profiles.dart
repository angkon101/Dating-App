import '../domain/user_profile.dart';

final List<UserProfile> kSampleBangladeshiProfiles = [
  UserProfile(
    id: 'user_01',
    name: 'Ayesha Rahman',
    age: 25,
    gender: 'female',
    division: 'Dhaka',
    area: 'Gulshan-2',
    education: 'IBA, University of Dhaka',
    profession: 'Software Product Architect',
    intent: 'meaningful_dating',
    bio: 'Balancing high-speed tech with slow coffee mornings. Fan of thoughtful conversations, indie acoustic playlists, and exploring heritage spots in Old Dhaka.',
    isPrivacyBlurred: true, // Demonstrates Bangladesh Discreet Shield
    isVerified: true,
    distanceKm: 2.1,
    avatarUrls: [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
    ],
    prompts: const [
      ProfilePrompt(
        question: 'My holy grail food spot in Dhaka is...',
        answer: 'Beauty Lassi for breakfast in Old Dhaka, followed by artisanal espresso at North End.',
      ),
      ProfilePrompt(
        question: 'Green flags I deeply value in someone...',
        answer: 'Emotional maturity, intellectual curiosity, and being deeply kind to service workers.',
      ),
    ],
  ),
  UserProfile(
    id: 'user_02',
    name: 'Fahim Morshed',
    age: 28,
    gender: 'male',
    division: 'Dhaka',
    area: 'Dhanmondi',
    education: 'BUET (Architecture)',
    profession: 'Sustainable Urban Architect',
    intent: 'serious_marriage',
    bio: 'Designing eco-conscious spaces by day, sketching rainy streets of Dhaka by evening. Looking for someone grounded, humorous, and ready for life’s next big chapter.',
    isPrivacyBlurred: false,
    isVerified: true,
    distanceKm: 4.8,
    avatarUrls: [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    ],
    prompts: const [
      ProfilePrompt(
        question: 'A Sunday afternoon well spent in my world looks like...',
        answer: 'Cycling around Rabindra Sarobar, sipping tong chai, and discussing architecture books.',
      ),
      ProfilePrompt(
        question: 'Old Dhaka Kacchi or Cha-biscuit at TSC?',
        answer: 'Start with TSC debate, end with Grand Nawab Kacchi. Balance is key.',
      ),
    ],
  ),
  UserProfile(
    id: 'user_03',
    name: 'Dr. Tasnim Kabir',
    age: 26,
    gender: 'female',
    division: 'Dhaka',
    area: 'Banani',
    education: 'Dhaka Medical College (DMC)',
    profession: 'Resident Physician',
    intent: 'halal_modest',
    bio: 'Passionate about healthcare equity and preventive medicine. Modest, grounded, close to family values, and an avid reader of historical biographies.',
    isPrivacyBlurred: true,
    isVerified: true,
    distanceKm: 3.2,
    avatarUrls: [
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=800&q=80',
    ],
    prompts: const [
      ProfilePrompt(
        question: 'My philosophy on balancing career, family, and personal freedom...',
        answer: 'Mutual respect is non-negotiable. Supporting each other’s aspirations while building a warm home.',
      ),
    ],
  ),
  UserProfile(
    id: 'user_04',
    name: 'Zubair Hossain',
    age: 27,
    gender: 'male',
    division: 'Dhaka',
    area: 'Uttara (Sector 4)',
    education: 'North South University (NSU)',
    profession: 'Creative Strategist & Photographer',
    intent: 'coffee_and_chat',
    bio: 'Documenting the soul of Bangladesh through 35mm film. Always down for good acoustic live sessions, rooftop chai chats, and street photography walks.',
    isPrivacyBlurred: false,
    isVerified: false,
    distanceKm: 6.5,
    avatarUrls: [
      'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=800&q=80',
    ],
    prompts: const [
      ProfilePrompt(
        question: 'The most underrated place in Bangladesh to unwind...',
        answer: 'Tanguar Haor during late autumn when the migratory birds arrive. Pure stillness.',
      ),
    ],
  ),
  UserProfile(
    id: 'user_05',
    name: 'Samira Chowdhury',
    age: 24,
    gender: 'female',
    division: 'Chattogram',
    area: 'Khulshi',
    education: 'Chittagong University',
    profession: 'Visual Artist & Textile Designer',
    intent: 'meaningful_dating',
    bio: 'Reviving traditional Jamdani and Khadi motifs with modern minimalism. Loves coastal sea breezes at Patenga and heartfelt acoustic Rabindra Sangeet covers.',
    isPrivacyBlurred: false,
    isVerified: true,
    distanceKm: 12.0,
    avatarUrls: [
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
    ],
    prompts: const [
      ProfilePrompt(
        question: 'Green flags I deeply value in someone...',
        answer: 'Someone who listens to understand rather than to reply, and genuinely loves their craft.',
      ),
    ],
  ),
];

