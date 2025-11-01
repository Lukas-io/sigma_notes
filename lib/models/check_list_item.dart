class CheckListItemModel {
  final String title;
  final bool isChecked;

  CheckListItemModel({required this.title, this.isChecked = false});

  Map<String, dynamic> toMap() {
    return {'title': title, 'isChecked': isChecked};
  }

  factory CheckListItemModel.fromMap(Map<String, dynamic> map) {
    return CheckListItemModel(
      title: map['title'],
      isChecked: map['isChecked'] ?? false,
    );
  }
}

final sampleCheckList1 = [
  CheckListItemModel(title: "I need a job mehn.", isChecked: true),
  CheckListItemModel(
    title:
        "Get a job from twitter to tell all my fans. I made my wealth from a notes app",
    isChecked: false,
  ),
  CheckListItemModel(title: "Finish Flutter project 🚀", isChecked: true),
  CheckListItemModel(
    title:
        "Call the electrician to fix the kitchen sink before it floods everything, seriously 😅",
    isChecked: false,
  ),
];

final sampleCheckList2 = [
  CheckListItemModel(title: "Buy groceries 🥦🥖", isChecked: true),
  CheckListItemModel(
    title:
        "Plan weekend hiking trip with friends and check weather, gear, and snacks 🍫🏞️",
    isChecked: false,
  ),
  CheckListItemModel(
    title: "Send weekly report (pretend it’s exciting) 📊",
    isChecked: true,
  ),
  CheckListItemModel(
    title: "Meditate for 10 minutes 🧘‍♂️ (or at least try, maybe nap instead)",
    isChecked: false,
  ),
];
