import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/icon_asset_constants.dart';
import '../../../core/routes/router.dart';
import '../../../widgets/custom_drawer/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();


  @override
  Widget build(BuildContext context) {
    return  AdvancedDrawer(
      drawer: const AppDrawer(),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context){
              return IconButton(
                onPressed: _advancedDrawerController.showDrawer,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chat History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Get.toNamed(Routes.modelsScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'LLamma 3.2',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(CustomIcons.llama, height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Row(
                children: [
                  Text(
                    'Today'
                  ),
                ],
              ),
              ListTile(
                title: const Text('Chat 1'),
                subtitle: const Text('This is a chat 1'),
                onTap: () {
                  Get.toNamed(Routes.conversationScreen);
                },
              ),
              ListTile(
                title: const Text('Chat 2'),
                subtitle: const Text('This is a chat 2'),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Chat 3'),
                subtitle: const Text('This is a chat 3'),
                onTap: () {
                },
              ),

              Text(
                  'Yesterday'
              ),

              ListTile(
                title: const Text('Chat 1'),
                subtitle: const Text('This is a chat 1'),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Chat 2'),
                subtitle: const Text('This is a chat 2'),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Chat 3'),
                subtitle: const Text('This is a chat 3'),
                onTap: () {
                },
              ),

              Text(
                  'Older'
              ),


              ListTile(
                title: const Text('Chat 1'),
                subtitle: const Text('This is a chat 1'),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Chat 2'),
                subtitle: const Text('This is a chat 2'),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Chat 3'),
                subtitle: const Text('This is a chat 3'),
                onTap: () {
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
