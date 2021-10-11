class Todo {
  Todo(this.title, this.text);
  String title;
  String text;

  Map toMap() {
    return {
      "title": title,
      "text": text,
    };
  }
}