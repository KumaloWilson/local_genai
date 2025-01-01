class ChatTemplate {
  final String? name;
  final bool? addGenerationPrompt;
  final String? systemPrompt;
  final String? chatTemplate;
  final String? bosToken;
  final String? eosToken;
  final bool? addBosToken;
  final bool? addEosToken;

  ChatTemplate({
    this.name,
    this.addGenerationPrompt,
    this.systemPrompt,
    this.chatTemplate,
    this.bosToken,
    this.eosToken,
    this.addBosToken,
    this.addEosToken,
  });

  // Factory method to create an instance from a map
  factory ChatTemplate.fromMap(Map<String, dynamic> map) {
    return ChatTemplate(
      name: map['name'],
      addGenerationPrompt: map['addGenerationPrompt'],
      systemPrompt: map['systemPrompt'],
      chatTemplate: map['chatTemplate'],
      bosToken: map['bosToken'],
      eosToken: map['eosToken'],
      addBosToken: map['addBosToken'],
      addEosToken: map['addEosToken'],
    );
  }

  // Method to convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addGenerationPrompt': addGenerationPrompt,
      'systemPrompt': systemPrompt,
      'chatTemplate': chatTemplate,
      'bosToken': bosToken,
      'eosToken': eosToken,
      'addBosToken': addBosToken,
      'addEosToken': addEosToken,
    };
  }
}
