import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/snapshot_utils.dart';
import 'package:azkar/views/core_views/home/user_progress/user_progress_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:odometer/odometer.dart';

class UserProgressWidget extends StatefulWidget {
  UserProgressWidget();

  @override
  State<UserProgressWidget> createState() => _UserProgressWidgetState();
}

class _UserProgressWidgetState extends State<UserProgressWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<OdometerNumber> finishedCountAnimation;
  Animation<OdometerNumber> consecutiveDaysAnimation;

  Future<void> getNeededData() async {
    int finishedCount =
        await ServiceProvider.challengesService.getFinishedChallengesCount();
    int consecutiveDays =
        await ServiceProvider.challengesService.getConsecutiveDaysStreak();
    finishedCountAnimation = OdometerTween(
            begin: OdometerNumber(0), end: OdometerNumber(finishedCount))
        .animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController),
    );
    consecutiveDaysAnimation = OdometerTween(
            begin: OdometerNumber(0), end: OdometerNumber(consecutiveDays))
        .animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController),
    );
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNeededData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            animationController.forward();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'المواظبة',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 45,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: SlideOdometerTransition(
                                odometerAnimation: consecutiveDaysAnimation,
                                numberTextStyle: const TextStyle(
                                  fontSize: 45,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'الإنجازات',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 45,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: SlideOdometerTransition(
                                odometerAnimation: finishedCountAnimation,
                                numberTextStyle: const TextStyle(
                                  fontSize: 45,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SnapshotUtils.getErrorWidget(context, snapshot),
                ),
                // Container(
                //   child: ButtonTheme(
                //     height: 50,
                //     // ignore: deprecated_member_use
                //     child: RawMaterialButton(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //       fillColor: Colors.grey,
                //       onPressed: () async {
                //         performLogout(context);
                //       },
                //       child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: AutoSizeText(
                //               AppLocalizations.of(context).logout,
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 25,
                //                   fontWeight: FontWeight.bold),
                //             ),
                //           )),
                //     ),
                //   ),
                // ),
              ],
            );
          } else {
            return UserProgressLoadingWidget();
          }
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
