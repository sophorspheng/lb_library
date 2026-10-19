import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/module/app/view/app_lb.dart';
import 'package:lb_library/widgets/flat_card.dart';
import 'package:lb_library/widgets/loading_widget.dart';

class SpinnerDialog {
  static bool _isTransferLoadingShowed = false;
  static bool _isLoading = false;

  static void onSpinner(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: (_, __) => Future.value(false),
          canPop: false,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              padding: const EdgeInsets.all(16),
              child: const LoadingWidget(),
            ),
          ),
        );
      },
    );
  }

  static Widget onLoadingCenter(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const LoadingWidget(),
      ),
    );
  }

  static Widget onLoadingH48(BuildContext context) {
    return Center(
      child: Container(
        width: 45.0,
        height: 45.0,
        margin: const EdgeInsets.only(top: 48.0),
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
            ),
            padding: const EdgeInsets.all(16),
            child: const LoadingWidget(),
          ),
        ),
      ),
    );
  }

  static void showTransferLoading() {
    _isTransferLoadingShowed = true;
    showDialog(
      context: ReadoraApp.context,
      barrierDismissible: false,
      useSafeArea: false,
      barrierColor: Theme.of(ReadoraApp.context).cardColor,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Theme.of(context).cardColor,
            // systemOverlayStyle:
            //     SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          ),
          body: PopScope(
            onPopInvokedWithResult: (_, __) => Future.value(false),
            canPop: false,
            child: FlatCard(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SpinKitSpinningLines(
                      color: Theme.of(context).primaryColor,
                      size: 200,
                    ),
                    Image.asset(
                      "/assets/images/book_logo.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) => _isTransferLoadingShowed = false);
  }

  static Future<void> closeTransferLoading() async {
    if (!_isTransferLoadingShowed) return;
    if (ReadoraApp.context.mounted && ReadoraApp.context.canPop()) {
      ReadoraApp.context.pop();
      // _isTransferLoadingShowed = false;
    }
    // await Future.delayed(const Duration(milliseconds: 300));
    // if (_isTransferLoadingShowed) {
    //   closeTransferLoading();
    // }
  }

  static void showLoading(BuildContext context) {
    // if (_isLoading) return;
    _isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          onPopInvokedWithResult: (_, __) => Future.value(false),
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                ),
                padding: const EdgeInsets.all(16),
                child: const LoadingWidget(),
              ),
            ),
          ),
        );
      },
    ).then((_) => _isLoading = false);
  }

  static void closeLoading(BuildContext context) {
    if (!_isLoading) return;
    if (context.mounted && context.canPop()) {
      context.pop();
      // _isLoading = false;
    }
    // await Future.delayed(const Duration(milliseconds: 100));
    // if (_isLoading) {
    //   closeLoading(context);
    // }
  }
}
