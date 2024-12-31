
import 'message.dart';
import 'participants.dart';

class Chat {
  Chat({
    required this.id,
    required this.participants,
    required this.participantIDs,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final List<dynamic> participantsJson = json['participants'];
    final List<Participant> participants = participantsJson.map((participantJson) => Participant.fromJson(participantJson)).toList();


    return Chat(
      id: json['id'],
      participants: participants,
      messages: List<Message>.from(json['messages'].map((messageJson) => Message.fromJson(messageJson))),
      participantIDs: List<String>.from(json['participantIDs'])
    );
  }
  final String id;
  final List<Participant> participants;
  final List<String> participantIDs;
  final List<Message> messages;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'participantIDs': participantIDs
    };
  }
}
