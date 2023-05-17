import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/guest/ListingSearchPage.dart';
import 'package:base_app_flutter/pages/guest/PickCalenderPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/Component.dart';
import '../../../utility/AssetsName.dart';
import '../LocationSearch.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  SearchOptions searchOptions = SearchOptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              "assets/images/splash_screen_img.png",
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColors.white),
              child: Container(
                padding: EdgeInsets.all(24),
                width: double.infinity,
                child: Column(
                  children: [
                    searchLayout(),
                    const SizedBox(height: 16),
                    checkinCheckoutLayout(),
                    const SizedBox(height: 16),
                    guestCountLayout(),
                    const SizedBox(height: 24),
                    button()
                  ],
                ),
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
        child: InkWell(
          onTap: () async {
            var data = await Get.to(
                () => LocationSearch(searchOptions: searchOptions));
            if (data != null) {
              setState(() {
                searchOptions = data;
              });
            }
          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Component.showIconStatic(name: AssetsName.ic_location, size: 24),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    searchOptions.name.isEmpty
                        ? "Where do you want to stay?"
                        : searchOptions.getName(),
                    style: TextStyle(
                        color: searchOptions.name.isEmpty
                            ? AppColors.darkGray
                            : AppColors.textColorBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Component.showIconStatic(name: AssetsName.search)
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkinCheckoutLayout() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: InkWell(
          onTap: () async {
            var data = await Get.to(
                () => PickCalenderPage(searchOptions: searchOptions));
            if (data != null) {
              setState(() {
                searchOptions = data;
                int i = 0;
              });
            }
          },
          child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Component.showIconStatic(
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
                          fontSize: searchOptions
                                  .getCheckinCheckoutShortDate()
                                  .isEmpty
                              ? 16
                              : 12),
                    ),
                    SizedBox(
                        height: searchOptions
                                .getCheckinCheckoutShortDate()
                                .isNotEmpty
                            ? 4
                            : 0),
                    searchOptions.getCheckinCheckoutShortDate().isNotEmpty
                        ? Text(
                            searchOptions.getCheckinCheckoutShortDate(),
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
      ),
    );
  }

  guestCountLayout() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: InkWell(
          onTap: () => {showGuestCountBottomSheet()},
          child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Component.showIconStatic(
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
                          fontSize:
                              searchOptions.getGuestCounts().isEmpty ? 16 : 12),
                    ),
                    SizedBox(
                        height: searchOptions.getGuestCounts().isEmpty ? 0 : 4),
                    searchOptions.getGuestCounts().isNotEmpty
                        ? Text(
                            searchOptions.getGuestCounts(),
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
      ),
    );
  }

  var bottomSheet;
  late SearchOptions damiSearchOption;

  showGuestCountBottomSheet() {
    damiSearchOption = SearchOptions();
    damiSearchOption.guestCount = searchOptions.guestCount;
    damiSearchOption.childCount = searchOptions.childCount;
    damiSearchOption.infantCount = searchOptions.infantCount;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setModelState /*You can rename this!*/) {
          bottomSheet = setModelState;

          return Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    const Expanded(
                        child: Text(
                      'Select Guest Size',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                showCounterInput("Adults", "Ages 13 or above"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput("Child", "Ages 2-12"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput("Infants", "Under 2"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.lineColor,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          foregroundColor: AppColors.darkGray,
                          backgroundColor: AppColors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text('Cancel')),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: Component.textButtonStyle(),
                        onPressed: () {
                          setState(() {
                            searchOptions.guestCount =
                                damiSearchOption.guestCount;
                            searchOptions.childCount =
                                damiSearchOption.childCount;
                            searchOptions.infantCount =
                                damiSearchOption.infantCount;
                          });
                          Get.back();
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text('Done')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  showCounterInput(String title, String subtitle) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textColorBlack)),
                SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGray)),
              ],
            ),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, -1);
                });
                setState(() {});
              },
              child: Component.showIconStatic(
                name: AssetsName.minus,
                size: 40,
              )),
          Container(
            margin: EdgeInsets.only(right: 12, left: 12),
            child: Text("${damiSearchOption.getCount(title)} ",
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textColorBlack)),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, 1);
                });
                setState(() {});
              },
              child: Component.showIconStatic(name: AssetsName.plus, size: 40))
        ],
      ),
    );
  }

  button() {
    return TextButton(
      style: Component.textButtonStyle(),
      onPressed: () {
        Get.to(() => ListingSearchPage(searchOptions: searchOptions));
      },
      child: Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text('Search')),
    );
  }
}
