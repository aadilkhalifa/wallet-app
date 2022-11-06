const categories = ['Food', 'Shopping', 'Groceries', 'Entertainment', 'Others'];

int nextAutomationId = 1;

class Automation {
  late int id;
  String recipient;
  String category;
  Automation(this.recipient, this.category) {
    id = nextAutomationId++;
  }
}
