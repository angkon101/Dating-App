class ProfilePrompt {
  final String question;
  final String answer;

  const ProfilePrompt({
    required this.question,
    required this.answer,
  });

  factory ProfilePrompt.fromJson(Map<String, dynamic> json) {
    return ProfilePrompt(
      question: json['question'] as String? ?? json['q'] as String? ?? '',
      answer: json['answer'] as String? ?? json['a'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
  };
}

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String division;
  final String area;
  final String? education;
  final String? profession;
  final String intent; // 'meaningful_dating', 'serious_marriage', 'coffee_and_chat', 'halal_modest'
  final String bio;
  final List<ProfilePrompt> prompts;
  final List<String> avatarUrls;
  final bool isPrivacyBlurred; // Discreet Mode
  final bool isVerified; // Blue checkmark
  final double distanceKm;
  final String? religionValues;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.division,
    required this.area,
    this.education,
    this.profession,
    required this.intent,
    required this.bio,
    this.prompts = const [],
    this.avatarUrls = const [],
    this.isPrivacyBlurred = false,
    this.isVerified = false,
    this.distanceKm = 3.5,
    this.religionValues,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? division,
    String? area,
    String? education,
    String? profession,
    String? intent,
    String? bio,
    List<ProfilePrompt>? prompts,
    List<String>? avatarUrls,
    bool? isPrivacyBlurred,
    bool? isVerified,
    double? distanceKm,
    String? religionValues,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      division: division ?? this.division,
      area: area ?? this.area,
      education: education ?? this.education,
      profession: profession ?? this.profession,
      intent: intent ?? this.intent,
      bio: bio ?? this.bio,
      prompts: prompts ?? this.prompts,
      avatarUrls: avatarUrls ?? this.avatarUrls,
      isPrivacyBlurred: isPrivacyBlurred ?? this.isPrivacyBlurred,
      isVerified: isVerified ?? this.isVerified,
      distanceKm: distanceKm ?? this.distanceKm,
      religionValues: religionValues ?? this.religionValues,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var rawPrompts = json['prompts'];
    List<ProfilePrompt> parsedPrompts = [];
    if (rawPrompts is List) {
      parsedPrompts = rawPrompts
          .map((item) => ProfilePrompt.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    var rawAvatars = json['avatar_urls'];
    List<String> parsedAvatars = [];
    if (rawAvatars is List) {
      parsedAvatars = rawAvatars.map((e) => e.toString()).toList();
    }

    return UserProfile(
      id: json['id'] as String? ?? '',
      name: json['display_name'] as String? ?? json['full_name'] as String? ?? 'Anonymous',
      age: (json['age'] as num?)?.toInt() ?? 25,
      gender: json['gender'] as String? ?? 'female',
      division: json['division'] as String? ?? 'Dhaka',
      area: json['area'] as String? ?? 'Gulshan',
      education: json['education_institution'] as String?,
      profession: json['profession'] as String?,
      intent: json['intent'] as String? ?? 'meaningful_dating',
      bio: json['bio'] as String? ?? '',
      prompts: parsedPrompts,
      avatarUrls: parsedAvatars,
      isPrivacyBlurred: json['is_privacy_blurred'] as bool? ?? false,
      isVerified: json['verification_status'] == 'verified' || json['is_verified'] == true,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 2.5,
      religionValues: json['religion_values'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': name,
    'age': age,
    'gender': gender,
    'division': division,
    'area': area,
    'education_institution': education,
    'profession': profession,
    'intent': intent,
    'bio': bio,
    'prompts': prompts.map((p) => p.toJson()).toList(),
    'avatar_urls': avatarUrls,
    'is_privacy_blurred': isPrivacyBlurred,
    'is_verified': isVerified,
    'distance_km': distanceKm,
    'religion_values': religionValues,
  };
}

