import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kdeccourse/Search.dart';
import 'package:kdeccourse/app_colors.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:kdeccourse/category_detail.dart';
import 'package:kdeccourse/course_detail.dart';
import 'package:kdeccourse/firebase_auth_service.dart';
import 'package:kdeccourse/login_screen.dart';
import 'package:kdeccourse/models/parent_model.dart';
import 'package:kdeccourse/profile_screen.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 40
    ..radius = 10.0
    ..boxShadow = <BoxShadow>[]
    ..progressColor = AppColor.secondary
    ..backgroundColor = Colors.white
    ..indicatorColor = AppColor.secondary
    ..textColor = AppColor.secondary
    ..maskColor = Colors.grey.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = true
    ..dismissOnTap = false;
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar', 'AR'),
        Locale('en', 'US'),
      ],
      path: 'assets/translation',
      fallbackLocale: const Locale('ar', 'AR'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(email: "", name: ""),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: 'KDEC Courses',
        theme: ThemeData(
          primaryColor: AppColor.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primary,
            secondary: AppColor.secondary,
          ),
          fontFamily: "EgyMotion",
        ),
        home: const LoginScreen(skip: true),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    return Scaffold(
      body: FutureBuilder<List<Parent>>(
        future: BackendQueries.getAllParents(),
        builder: (context, parents) => ConnectionState.done ==
                parents.connectionState
            ? Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                        delegate:
                            CustomSliverAppBarDelegate(expandedHeight: 320),
                        pinned: true),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: InkWell(
                              onTap: () => parents.data![index].hasChildren
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CategoryDetails(
                                              title:
                                                  parents.data![index].name)))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CourseDetail(
                                              courseName:
                                                  parents.data![index].name,
                                              ext: parents
                                                  .data![index].imgExt))),
                              child: Column(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${BackendQueries.imageUrl}${parents.data![index].name}.${parents.data![index].imgExt}",
                                    height: (index == parents.data!.length - 1)
                                        ? MediaQuery.of(context).size.height *
                                            0.3
                                        : MediaQuery.of(context).size.height *
                                            0.3,
                                    width: double.infinity,
                                    placeholder: (context, url) => Image.asset(
                                      "images/placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "images/placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  parents.data![index].name,
                                  style: TextStyle(
                                      fontSize: multiplier * unitHeightValue),
                                ),
                              ]),
                            ),
                          );
                        },
                        childCount: parents.data?.length ?? 0,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBarDelegate({required this.expandedHeight});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Stack(
        fit: StackFit.expand,
        children: [
          buildBodyBar(shrinkOffset),
          // buildAppBar(shrinkOffset),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: floatingSearchBar(context, shrinkOffset)),
          Positioned(
              top: 10,
              right: 10,
              child: SafeArea(child: floatingAvatar(context, shrinkOffset))),
        ],
      ),
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;
  double disAppear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;
  //Widget buildAppBar(double shrinkOffset) => Opacity(opacity: appear(shrinkOffset),child: AppBar(title: Text("School of christ"),centerTitle: true,));
  Widget buildBodyBar(double shrinkOffset) => Opacity(
      opacity: disAppear(shrinkOffset),
      child: Image.asset(
        "images/cover.jpg",
        fit: BoxFit.cover,
      ));
  Widget floatingSearchBar(BuildContext context, double shrinkOffset) => Center(
        child: Opacity(
          opacity: disAppear(shrinkOffset),
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width - 40,
            child: TextField(
              onTap: () => showSearch(context: context, delegate: Search()),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: 'search'.tr(),
              ),
            ),
          ),
        ),
      );
  Widget floatingAvatar(BuildContext context, double shrinkOffset) => Opacity(
        opacity: disAppear(shrinkOffset),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () => EasyLocalization.of(context)!.setLocale(
                    EasyLocalization.of(context)!
                        .supportedLocales
                        .where((element) =>
                            element !=
                            EasyLocalization.of(context)!.currentLocale)
                        .first),
                icon: const Icon(Icons.language),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen())),
                    icon: const Icon(
                      Icons.person,
                      color: AppColor.secondary,
                    ))),
          ],
        ),
      );
  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
