class Level {
  int id;
  int points;

  Level({ required this.id, required this.points });

  static List<Level> generateLevels(){
    return [
      Level(id: 1, points: 0),
      Level(id: 2, points: 15),
      Level(id: 3, points: 75),
      Level(id: 4, points: 250),
      Level(id: 5, points: 500),
      Level(id: 6, points: 1500),
      Level(id: 7, points: 5000),
      Level(id: 8, points: 15000),
      Level(id: 9, points: 50000),
      Level(id: 10, points: 10000),
  ];
  }
}