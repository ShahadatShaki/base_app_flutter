import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'UserController.dart';

class EditProfileController extends UserController {
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";

  var imageUrl = "".obs;

  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController dateOfBirth;

  @override
  void onInit() {
    lastNameController = TextEditingController();
    firstNameController = TextEditingController();
    dateOfBirth = TextEditingController();
    getProfileDataOffline();

    // dateOfBirth.

    super.onInit();
  }

  editProfileUi() {
    firstNameController.text = profile.value.firstName;
    lastNameController.text = profile.value.lastName;
    dateOfBirth.text = Constants.calenderStingToString(
        profile.value.birthdate, "dd MMM, yyyy");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirth.dispose();
    super.dispose();
  }

  void pickDob(BuildContext context) {
    Component().pickDate(
      context: context,
      onDatePick: (dateTime) {
        dateOfBirth.text = Constants.calenderToString(dateTime, "dd MMM, yyyy");
      },
    );
  }

  void pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageUrl.value = image?.path ?? "";
  }
}
