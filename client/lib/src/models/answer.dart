class Answer{
  final String answer;
  final bool isCorrect;

  Answer({required this.answer, required this.isCorrect});


  @override
  String toString() {
    print(answer);
    return super.toString();
  }
}