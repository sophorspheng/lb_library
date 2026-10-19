import 'package:flutter/cupertino.dart';
import 'package:lb_library/config/theme/app_color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: 18,
      color: AppColor.primary,
    );
    // return Center(
    //   child: Container(
    //     width: 45.0,
    //     height: 45.0,
    //     padding: const EdgeInsets.all(8.0),
    //     decoration: const BoxDecoration(shape: BoxShape.circle),
    //     child: const SpinKitDoubleBounce(
    //       color: AppColor.primary,
    //       size: 30,
    //     ),
    //   ),
    // );
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     SpinKitDoubleBounce(
    //       color: AppColor.primary,
    //       size: 80,
    //     ),
    //     Image.asset(
    //       AssetPath.ardbLogoWhiteBg,
    //       width: 50,
    //       height: 50,
    //       fit: BoxFit.contain,
    //     ),
    //   ],
    // );
  }
}
