import 'hospital_model.dart';

enum MessageSender {
  user,
  ai,
}

enum MessageType {
  text,
  hospitalRecommendation,
}

class ChatModel {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final MessageType type;
  final List<HospitalModel> hospitals;

  const ChatModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.type = MessageType.text,
    this.hospitals = const [],
  });

  ChatModel copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    MessageType? type,
    List<HospitalModel>? hospitals,
  }) {
    return ChatModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      hospitals: hospitals ?? this.hospitals,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"].toString(),
      text: json["text"] ?? json["content"] ?? "",
      sender: (json["sender"] ?? "ai") == "user"
          ? MessageSender.user
          : MessageSender.ai,
      timestamp:
      DateTime.tryParse(json["timestamp"] ?? "") ?? DateTime.now(),
      type: (json["type"] ?? "") == "hospital_recommendation"
          ? MessageType.hospitalRecommendation
          : MessageType.text,
      hospitals: (json["hospitals"] as List<dynamic>?)
          ?.map((e) => HospitalModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "sender": sender == MessageSender.user ? "user" : "ai",
      "timestamp": timestamp.toIso8601String(),
      "type": type == MessageType.hospitalRecommendation
          ? "hospital_recommendation"
          : "text",
      "hospitals": hospitals.map((e) => e.toJson()).toList(),
    };
  }
}