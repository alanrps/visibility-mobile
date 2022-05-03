import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';

void showNotification(BuildContext context, String title, String subtitle){
    AchievementView(
        context,
        title: title,
        subTitle: subtitle,
        //onTab: _onTabAchievement,
        icon: Icon(Icons.flash_on_outlined, color: Colors.white),
        //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
        //borderRadius: 5.0,
        color: Colors.green,
        //textStyleTitle: TextStyle(),
        //textStyleSubTitle: TextStyle(),
        //alignment: Alignment.topCenter,
        // duration: Duration(seconds: 3),
        //isCircle: false,
        listener: (status){
          print(status);
          //AchievementState.opening
          //AchievementState.open
          //AchievementState.closing
          //AchievementState.closed
        }
    )..show();
  }