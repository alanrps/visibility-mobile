import 'package:app_visibility/models/badges.dart';
import 'package:app_visibility/utils/rewards.dart';
import 'package:app_visibility/utils/levels.dart';

class Utils{
  static convertListToLowerCase(List<String> data){
    return data.map((element) => element.toLowerCase()).toList();
  }

  static rewardActions(String action){
    int actionPoints = Reward.rewards().fold(0, (int acc, Reward element){
      if(element.action == action)
        acc = element.points;

      return acc;
    });

    if(actionPoints == 0){
      throw Exception({ "rewardAction": "reward action not found" });
    }

    return actionPoints;
  }

  // information_amount -> preciso atualizar items
  // achievements [category, actions_amount]
  static validateBadges(Map<String, int> informationAmount, List<Badges> badges){
        // CATEGORIA/ PONTUACAO

        // percorrer as conquistas e verificar valor na categoria
    
  }

  static validateBadgesPoints(Map<String, int> informationAmount, Map<String, dynamic> badges){

  }

  static int validateLevel(int currentPoints, int level){
    int currentLevel = level;
    int maxLevel = 10;

    if(level == maxLevel){
      return level;    
    }

    Level.generateLevels().forEach((Level element){
      if(element.id == (level + 1)){
        currentLevel = currentPoints >= element.points ? element.id : level;  
      }
    });

    return currentLevel;
  }
}