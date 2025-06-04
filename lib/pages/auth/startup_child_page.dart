import 'package:responsive_sizer/responsive_sizer.dart';
import '../../components/custom_text.dart';
import '../../models/start_up_screen_data.dart';
import '../../style/colors.dart';
import '../../style/styles.dart';

class StartupChildPage extends StatelessWidget {
  final StartUpScreenData startUpScreenData;

  const StartupChildPage({super.key, required this.startUpScreenData});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(7.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          CustomText(
            startUpScreenData.title,
            fontSize: 30,
            style: FontStyles.bold,
            align: TextAlign.center,
          ),
          Spacer(),
          Image.asset(startUpScreenData.image, height: 30.h),
          Spacer(),
          CustomText(
            startUpScreenData.description,
            style: FontStyles.medium,
            align: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
