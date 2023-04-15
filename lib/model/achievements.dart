class Achievement {
  String name;
  String description;
  int progress;
  int target; //
  bool unlocked;

  Achievement({
    required this.name,
    required this.description,
    required this.progress,
    required this.target,
    required this.unlocked,
  });
}
