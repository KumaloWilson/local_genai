import 'package:get/get.dart';
import 'package:local_gen_ai/features/ai_model_management/views/ai_models_screen.dart';
import 'package:local_gen_ai/features/chat/views/conversation_screen.dart';

class Routes {
  static String initialScreen = "/";
  static String conversationScreen = "/conversationScreen";
  static String modelsScreen = "/modelsScreen";

  static List<GetPage> routes = [
    GetPage(name: conversationScreen, page: ()=> const ConversationScreen()),
    GetPage(name: modelsScreen, page: ()=> const AIModelScreen()),
    // GetPage(name: municipalitiesScreen, page: ()=> const MunicipalitiesScreen()),
    //
    //
    // GetPage(
    //   name: initialScreen,
    //   page: (){
    //     return const HomeScreen();
    //   }
    // ),
    //
    // GetPage(
    //   name: propertyDetails,
    //   page: (){
    //     return PropertyDetailsScreen();
    //   }
    // ),
    //
    //
    // GetPage(
    //   name: historyDetails,
    //   page: () {
    //     final PurchaseHistory purchase = Get.arguments as PurchaseHistory;
    //
    //     return PurchaseHistoryDetailsScreen(
    //       purchase: purchase,
    //     );
    //   },
    // ),
    //
    //
    // GetPage(
    //     name: webviewPaymentPage,
    //     page: (){
    //       final redirectUrl = Get.arguments as String;
    //       return PaymentWebViewScreen(redirectUrl: redirectUrl,);
    //     }
    //
    // ),

  ];
}

