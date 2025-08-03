class Summary {
  final int? id;
  final String input;
  final String output;

  Summary({this.id, required this.input, required this.output});

  factory Summary.fromMap(Map<String, dynamic> map) {
    return Summary(
      id: map['id'],
      input: map['input'],
      output: map['output'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'input': input,
      'output': output,
    };
  }
}
