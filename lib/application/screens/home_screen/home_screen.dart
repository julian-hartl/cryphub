import 'package:auto_route/auto_route.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../domain/crypto_currency/crypto_currency.dart';
import '../../app_router.dart';
import '../../blocs/latest_currencies/latest_currencies_bloc.dart';
import '../../ui_constants.dart';
import '../../widgets/expandable_sidebar.dart';
import 'widgets/favorite_currencies_carousel.dart';
import 'widgets/latest_currencies_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const HomeScreenContent();
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with LoggerProvider {
  final PagingController<int, CryptoCurrency> pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 4);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      logger.info('Requesting new items from api. Page $pageKey');
      context
          .read<LatestCurrenciesBloc>()
          .add(LatestCurrenciesEvent.loadPage(pageKey));
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  final ExpandableSidebarController sidebarController =
      ExpandableSidebarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandableSidebar(
        controller: sidebarController,
        openBySwipe: true,
        sidebarWidth: MediaQuery.of(context).size.width * 0.8,
        sidebarColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.background,
        sidebar: HomeScreenSidebar(sidebarController: sidebarController),
        child: RefreshIndicator(
          onRefresh: () async {
            pagingController.refresh();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(
                  'Home'.toUpperCase(),
                  style: const TextStyle(letterSpacing: 1.3),
                ),
                leading: IconButton(
                  onPressed: () {
                    sidebarController.toggleSidebar();
                  },
                  icon: const Icon(Icons.menu),
                ),
                floating: true,
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 8.0),
                sliver: FavoriteCurrenciesCarousel(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalPagePadding, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Text('Latest'),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalPagePadding),
                sliver: LatestCurrenciesView(
                  pagingController: pagingController,
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenSidebar extends StatelessWidget {
  const HomeScreenSidebar({
    Key? key,
    required this.sidebarController,
  }) : super(key: key);

  final ExpandableSidebarController sidebarController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPagePadding),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                sidebarController.closeSidebar();
              },
              child: Icon(
                Icons.menu,
                size: 50,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.9),
              ),
            ),
            const Gap(10),
            const Text(
              'Hello!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                letterSpacing: 2,
              ),
            ),
            const Divider(
              height: 25,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => SettingsScreen(),
                // ));
                await AutoRouter.of(context).push(const SettingsScreenRoute());
                sidebarController.closeSidebar();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.settings),
                  Gap(10),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
