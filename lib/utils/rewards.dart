class Reward {
  String action;
  int points;

  Reward({ required this.action, required this.points});

  static List<Reward> rewards(){
    return [
      Reward(action: "evaluationWheelChairParking", points: 10),
      Reward(action: "evaluationPlace", points: 15),
      Reward(action: "evaluationPlace200", points: 25),
      Reward(action: "comment", points: 5),
      Reward(action: "evaluationEdit", points: 10),
    ];
  }
}