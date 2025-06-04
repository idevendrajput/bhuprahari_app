import 'package:bhuprahari_app/pages/auth/login_page.dart';
import 'package:bhuprahari_app/pages/auth/startup_child_page.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/default_button.dart';
import '../../main.dart';
import '../../models/start_up_screen_data.dart';
import '../../style/colors.dart';
import '../../style/styles.dart';
import '../../utils/assets.dart';
import '../../utils/responsive.dart';

class Startup extends StatefulWidget {
  const Startup({super.key});

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  final List<StartUpScreenData> _dataList = [
    StartUpScreenData(
      title: "Monitor Your Land with Precision",
      description:
      "Track changes, detect unauthorized activity, and safeguard your land assets with real-time satellite monitoring.",
      image: MyImages.imgScreen1,
    ),
    StartUpScreenData(
      title: "Real-time Alerts, Comprehensive Insights",
      description:
      "Receive instant notifications on detected changes, view historical data, and gain valuable insights into your land's evolution.",
      image: MyImages.imgScreen2,
    ),
    StartUpScreenData(
      title: "Secure Data, Easy Access",
      description:
      "Public data is securely stored and easily accessible anytime, anywhere. Simple setup, powerful protection.",
      image: MyImages.imgScreen3,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
        child: Stack(
          children: [
            Opacity(
              opacity: .5,
              child: Image.asset(
                MyImages.background,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 100,
              child: PageView(
                controller: _pageController,
                onPageChanged: (newIndex) {
                  setState(() {
                    _currentPage = newIndex;
                  });
                },
                children: [
                  ..._dataList.map((e) => StartupChildPage(startUpScreenData: e)),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 30,
              child: Column(
                children: [
                  DotsIndicator(
                    dotsCount: 3,
                    position: _currentPage.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      color: $styles.colors.greyMedium,
                      activeColor: $styles.colors.shark,
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  gap(context, height: 1.h),
                  DefaultButton(
                    _currentPage == 2 ? $strings.getStarted : $strings.next,
                    padding: 3.5.w,
                    fontSize: 18,
                    radius: 40,
                    style: FontStyles.openSansBold,
                    onClick: () {
                      if (_currentPage == 2) {
                        navigate(context, const LoginPage());
                        return;
                      }
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
