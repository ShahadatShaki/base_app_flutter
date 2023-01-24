import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../component/Component.dart';
import '../../../utility/AssetsName.dart';

class ExplorePage extends StatelessWidget {
  ExplorePage({Key? key}) : super(key: key);

  String checkinCheckout = "sfjkjkj";
  String guestCount = "sfjkjkj";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SvgPicture.asset(
              "assets/images/splash.svg",
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColors.white),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      searchLayout(),
                      const SizedBox(
                        height: 16,
                      ),
                      checkinCheckoutLayout(),
                      const SizedBox(
                        height: 16,
                      ),
                      guestCountLayout(),
                      const SizedBox(
                        height: 24,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: Component.roundShape(),
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.appColor,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
                        child: Container(
                            height: 50,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text('Gradient')),
                      ),
                    ],
                  ),
                ),

                // Card(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.only(
                //           topRight: Radius.circular(20),
                //           topLeft: Radius.circular(20))),
                //   child:
                //
                // ),
              ),
            ),
          )
        ],
      ),
    );
  }

  searchLayout() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Component.showIcon(name: AssetsName.ic_location, size: 24),
              const SizedBox(
                width: 16,
              ),
              const Expanded(
                child: Text(
                  "Where do you want to stay?",
                  style: TextStyle(color: AppColors.darkGray, fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Component.showIcon(name: AssetsName.search)
            ],
          ),
        ),
      ),
    );
  }

  checkinCheckoutLayout() {
    checkinCheckout = "fkd";

    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: Container(
          height: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Component.showIcon(
                name: AssetsName.calender,
                size: 24,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Check In - Check Out",
                    style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: checkinCheckout.isEmpty ? 16 : 12),
                  ),
                  SizedBox(height: checkinCheckout.isNotEmpty ? 4 : 0),
                  checkinCheckout.isNotEmpty
                      ? Text(
                          checkinCheckout,
                          style: const TextStyle(
                              color: AppColors.textColorBlack, fontSize: 16),
                        )
                      : SizedBox(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  guestCountLayout() {
    guestCount = "";

    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: Container(
          height: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Component.showIcon(
                name: AssetsName.guest,
                size: 24,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guest",
                    style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: guestCount.isEmpty ? 16 : 12),
                  ),
                  SizedBox(height: guestCount.isNotEmpty ? 4 : 0),
                  guestCount.isNotEmpty
                      ? Text(
                          guestCount,
                          style: TextStyle(
                              color: AppColors.textColorBlack, fontSize: 16),
                        )
                      : SizedBox(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
