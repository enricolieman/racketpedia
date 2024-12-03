import 'package:flutter/material.dart';
import 'package:Racketpedia/view/home_view.dart';
import 'package:Racketpedia/view/brand_tech_view.dart';
import 'package:Racketpedia/view/balancepoint_guide_view.dart';
import 'package:Racketpedia/view/information_view.dart';
import 'package:Racketpedia/view/recommendations_view.dart';
import 'package:Racketpedia/view/racket_detail_view.dart'
    as detailView; // Prefix added
import 'package:Racketpedia/core/app_constants.dart';
import 'package:Racketpedia/model/racket_list_model.dart';
import 'package:Racketpedia/view/stiffness_guide_view.dart';
import 'package:Racketpedia/view/weight_guide_view.dart';
import 'package:Racketpedia/view/splash_screen_view.dart'; // Import SplashScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racketpedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        AppConstansts.homeRoute: (context) => HomeView(),
        AppConstansts.recommendationsRoute: (context) => RecommendationsView(),
        AppConstansts.informationRoute: (context) => const InformationView(),
        AppConstansts.brandTechRoute: (context) => const BrandTechnologyView(),
        AppConstansts.balancePointRoute: (context) =>
            const BalancePointGuideView(),
        AppConstansts.stiffnessRoute: (context) => const StiffnessGuideView(),
        AppConstansts.weightRoute: (context) => const WeightGuideView(),
        AppConstansts.racketDetailRoute: (context) {
          final racket = ModalRoute.of(context)!.settings.arguments as Racket;
          return detailView.RacketDetailView(
              racket: racket); // Use the prefix here
        },
      },
    );
  }
}
