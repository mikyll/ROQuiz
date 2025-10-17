abstract class Command {
  String name = "";
  void execute();
  void undo();
  void redo();
}
