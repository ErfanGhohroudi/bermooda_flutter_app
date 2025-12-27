part of '../../data.dart';

class MediaReadDto {
  MediaReadDto({
    required this.url,
    this.id,
  });

  factory MediaReadDto.fromJson(final String str) => MediaReadDto.fromMap(json.decode(str));

  factory MediaReadDto.fromMap(final dynamic json) => MediaReadDto(
        id: json["id"].toString(),
        url: json["url"],
      );
  String? id;
  String url;

  String toJson() => json.encode(removeNullEntries(toMap()));

  dynamic toMap() => {
        "id": id,
        "url": url,
      };
}

class MediaUpdateDto {
  factory MediaUpdateDto.fromJson(final String str) => MediaUpdateDto.fromMap(json.decode(str));

  MediaUpdateDto({
    this.id,
    this.title,
    this.description,
    this.size,
    this.time,
    this.artist,
    this.album,
    this.order,
    this.link1,
    this.link2,
    this.link3,
    this.tags,
    this.removeTags,
    this.addTags,
  });

  factory MediaUpdateDto.fromMap(final Map<String, dynamic> json) => MediaUpdateDto(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        size: json["size"],
        time: json["time"],
        artist: json["artist"],
        album: json["album"],
        order: json["order"],
        link1: json["link1"],
        link2: json["link2"],
        link3: json["link3"],
        tags: json["tags"] == null ? [] : List<int>.from(json["tags"]!.map((final x) => x)),
        removeTags: json["removeTags"] == null ? [] : List<int>.from(json["removeTags"]!.map((final x) => x)),
        addTags: json["addTags"] == null ? [] : List<int>.from(json["addTags"]!.map((final x) => x)),
      );
  String? id;
  String? title;
  String? description;
  String? size;
  String? time;
  String? artist;
  String? album;
  int? order;
  String? link1;
  String? link2;
  String? link3;
  List<int>? tags;
  List<int>? removeTags;
  List<int>? addTags;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "size": size,
        "time": time,
        "artist": artist,
        "album": album,
        "order": order,
        "link1": link1,
        "link2": link2,
        "link3": link3,
        "tags": List<dynamic>.from(tags!.map((final x) => x)),
        "removeTags": removeTags == null ? [] : List<dynamic>.from(removeTags!.map((final x) => x)),
        "addTags": addTags == null ? [] : List<dynamic>.from(addTags!.map((final x) => x)),
      };
}


class CreateMediaReadDto {
  String? filesPath;
  String? categoryId;
  String? contentId;
  String? groupChatId;
  String? groupChatMessageId;
  String? productId;
  String? userId;
  int? privacyType;
  int? order;
  String? time;
  String? artist;
  String? album;
  String? commentId;
  String? bookmarkId;
  String? chatId;
  String? title;
  String? notificationId;
  String? size;

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileName;
  int? tag;
  String? url;
  List<int>? tags;
  String? fileType;

  CreateMediaReadDto({
    this.filesPath,
    this.categoryId,
    this.contentId,
    this.groupChatId,
    this.groupChatMessageId,
    this.productId,
    this.userId,
    this.privacyType,
    this.time,
    this.artist,
    this.order,
    this.album,
    this.commentId,
    this.bookmarkId,
    this.chatId,
    this.title,
    this.tags,
    this.notificationId,
    this.size,
  });

  String toJson() => json.encode(removeNullEntries(toMap()));

  dynamic toMap() => {
    "filesPath": filesPath,
    "CategoryId": categoryId,
    "ContentId": contentId,
    "GroupChatId": groupChatId,
    "ProductId": productId,
    "UserId": userId,
    "order": order,
    "PrivacyType": privacyType,
    "Artist": artist,
    'Album': album,
    'CommentId': commentId,
    'BookmarkId': bookmarkId,
    'ChatId': chatId,
    "Tags": tags == null ? [] : List<dynamic>.from(tags!.map((final int x) => x)),
    'Title': title ?? fileName,
    'NotificationId': notificationId,
    'Size': size,
  };
}
class MediaFilterDto {
  MediaFilterDto({
    this.pageSize,
    this.pageNumber,
  });

  factory MediaFilterDto.fromJson(final String str) => MediaFilterDto.fromMap(json.decode(str));

  factory MediaFilterDto.fromMap(final dynamic json) => MediaFilterDto(
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
      );

  int? pageSize;
  int? pageNumber;

  String toJson() => json.encode(removeNullEntries(toMap()));

  dynamic toMap() => {
        "pageSize": pageSize,
        "pageNumber": pageNumber,
      };
}
