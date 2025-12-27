part of 'conversation_dtos.dart';

enum FeedbackPriority {
  normal("Normal", "عادی"),
  medium("Medium", "متوسط"),
  urgent("Urgent", "فوری");

  const FeedbackPriority(this.title, this.titleTr1);

  final String title;
  final String titleTr1;

  String getTitle() => !isPersianLang ? title : titleTr1;

  Color get color {
    switch (this) {
      case FeedbackPriority.normal:
        return AppColors.blue;
      case FeedbackPriority.medium:
        return AppColors.orange;
      case FeedbackPriority.urgent:
        return AppColors.red;
    }
  }

  static FeedbackPriority fromValue(final String? value) {
    switch (value) {
      case 'normal':
        return FeedbackPriority.normal;
      case 'medium':
        return FeedbackPriority.medium;
      case 'urgent':
        return FeedbackPriority.urgent;
      default:
        return FeedbackPriority.normal;
    }
  }
}

class FeedbackDto extends MessageEntity {
  const FeedbackDto({
    required super.id,
    required super.createdAt,
    this.text,
    required this.priority,
    required this.isRead,
    this.senderId,
    this.category,
    this.subcategory,
  });

  final String? text;
  final FeedbackPriority priority;
  final bool isRead;
  final String? senderId;
  final FeedbackCategoryDto? category;
  final FeedbackSubcategoryDto? subcategory;

  @override
  bool get isOwner => false;

  @override
  String? get messageText => text;

  factory FeedbackDto.fromMap(final Map<String, dynamic> json) {
    return FeedbackDto(
      id: json['id']?.toString() ?? '',
      text: json['template'],
      priority: FeedbackPriority.fromValue(json['priority']),
      createdAt:
          DateTime.tryParse(json['received_at'] ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] ?? false,
      senderId: json['sender_id']?.toString(),
      category: json['category'] != null
          ? FeedbackCategoryDto.fromMap(
              json['category'] as Map<String, dynamic>,
            )
          : null,
      subcategory: json['subcategory'] != null
          ? FeedbackSubcategoryDto.fromMap(
              json['subcategory'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'is_pinned': isRead,
      'client_id': senderId,
      'category': category?.toJson(),
      'subcategory': subcategory?.toJson(),
    };
  }

  @override
  FeedbackDto copyWith({
    final String? id,
    final String? text,
    final FeedbackPriority? priority,
    final DateTime? createdAt,
    final bool? isRead,
    final String? senderId,
    final FeedbackCategoryDto? category,
    final FeedbackSubcategoryDto? subcategory,
  }) {
    return FeedbackDto(
      id: id ?? this.id,
      text: text ?? this.text,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      senderId: senderId ?? this.senderId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    priority,
    createdAt.toIso8601String(),
    isRead,
    senderId,
    category,
    subcategory,
  ];
}

class FeedbackCategoryDto extends Equatable {
  const FeedbackCategoryDto({
    required this.id,
    required this.title,
    required this.icon,
    required this.subCategories,
    required this.titleEn,
  });

  final int id;
  final String title;
  final String icon;
  final List<FeedbackSubcategoryDto> subCategories;
  final String titleEn;

  String get displayTitle => isPersianLang ? title : titleEn;

  factory FeedbackCategoryDto.fromMap(final Map<String, dynamic> json) {
    return FeedbackCategoryDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      subCategories:
          (json['sub_categories'] as List<dynamic>?)
              ?.map(
                (final e) =>
                    FeedbackSubcategoryDto.fromMap(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      titleEn: json['title_en'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'sub_categories': subCategories.map((final e) => e.toJson()).toList(),
      'title_en': titleEn,
    };
  }

  FeedbackCategoryDto copyWith({
    final int? id,
    final String? title,
    final String? icon,
    final List<FeedbackSubcategoryDto>? subCategories,
    final String? titleEn,
  }) {
    return FeedbackCategoryDto(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      subCategories: subCategories ?? this.subCategories,
      titleEn: titleEn ?? this.titleEn,
    );
  }

  @override
  List<Object?> get props => [id, title, icon, subCategories, titleEn];
}

class FeedbackSubcategoryDto extends Equatable {
  const FeedbackSubcategoryDto({
    required this.id,
    required this.title,
    required this.titleEn,
    this.templates = const [],
  });

  final int id;
  final String title;
  final String titleEn;
  final List<MessageTemplateDto> templates;

  String get displayTitle => isPersianLang ? title : titleEn;

  factory FeedbackSubcategoryDto.fromMap(final Map<String, dynamic> json) {
    return FeedbackSubcategoryDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      templates: json['templates'] != null
          ? List<MessageTemplateDto>.from(json['templates'].map((final x) => MessageTemplateDto.fromMap(x)).toList())
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_en': titleEn,
      'templates': templates,
    };
  }

  FeedbackSubcategoryDto copyWith({
    final int? id,
    final String? title,
    final String? titleEn,
    final List<MessageTemplateDto>? templates,
  }) {
    return FeedbackSubcategoryDto(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      templates: templates ?? this.templates,
    );
  }

  @override
  List<Object?> get props => [id, title, titleEn, templates];
}

class MessageTemplateDto extends Equatable {
  const MessageTemplateDto({
    required this.id,
    required this.title,
    required this.titleEn,
  });

  final int id;
  final String title;
  final String titleEn;

  String get displayTitle => isPersianLang ? title : titleEn;

  factory MessageTemplateDto.fromMap(final Map<String, dynamic> json) {
    return MessageTemplateDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_en': titleEn,
    };
  }

  MessageTemplateDto copyWith({
    final int? id,
    final String? title,
    final String? titleEn,
    final List<String>? templates,
  }) {
    return MessageTemplateDto(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
    );
  }

  @override
  List<Object?> get props => [id, title, titleEn];
}
