import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kisan_facility/components/app_logo_widget.dart';
import 'package:kisan_facility/components/custom_rounded_button.dart';
import 'package:kisan_facility/components/custom_textfrom_field.dart';
import 'package:kisan_facility/components/layout.dart';
import 'package:kisan_facility/components/login_signup_bottom_text.dart';
import 'package:kisan_facility/components/top_widget.dart';
import 'package:kisan_facility/mixins/selectable_sheet_mixin.dart';
import 'package:kisan_facility/screens/dashborad/dashborad.dart';
import 'package:kisan_facility/screens/dashborad/home/home_screen.dart';
import 'package:kisan_facility/screens/onboardiing/controller/onboarding_controller.dart';
import 'package:kisan_facility/screens/onboardiing/login_screen.dart';
import 'package:kisan_facility/state_provider/logged_user_stateprovider.dart';
import 'package:kisan_facility/utils/app_colors.dart';
import 'package:kisan_facility/utils/navigation_shortcut.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  final bool onBoarding;

  const CreateAccountScreen({super.key, this.onBoarding = true});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final TextEditingController firstNameCtr = TextEditingController();
  final TextEditingController lastNameCtr = TextEditingController();
  final TextEditingController genderCtr = TextEditingController();
  final TextEditingController userTypeCtr = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final ScrollController _controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<String> genderList = ['Male', "Female", "It's Secret"];
  List<String> typeOfUser = ["Farmer", "Guest", "Buyer"];

  @override
  void didChangeDependencies() {
    if (widget.onBoarding == false) {
      final user = ref.watch(userProvider);
      firstNameCtr.text = user?.user?.firstName ?? "";
      lastNameCtr.text = user?.user?.lastName ?? "";
      genderCtr.text = user?.user?.gender ?? "";
      emailCtrl.text = user?.user?.email ?? "";
      phoneCtrl.text = user?.user?.phone ?? "";
    }
    super.didChangeDependencies();
  }

  void createAccount(BuildContext context, WidgetRef ref) {
    String newPhoneValue = "";
    for (int i = 0; i < phoneCtrl.text.length; i++) {
      if (phoneCtrl.text[i] == ")" ||
          phoneCtrl.text[i] == "(" ||
          phoneCtrl.text[i] == "-" ||
          phoneCtrl.text[i] == " ") {
        continue;
      }
      newPhoneValue += phoneCtrl.text[i];
    }
    ref.read(onBoardingControllerProvider.notifier).userCreate(context,
        firstname: firstNameCtr.text,
        middlename: "",
        lastname: lastNameCtr.text,
        email: emailCtrl.text,
        phone: newPhoneValue,
        password: passwordCtrl.text,
        passConfirm: passwordCtrl.text,
        gender: genderCtr.text,
        isUpdate: !widget.onBoarding);
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onBoardingControllerProvider);
    return Layout(
      showAsset: widget.onBoarding,
      child: Form(
        key: _formKey,
        child: ListView(
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            !widget.onBoarding
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TopWidget(
                        centerText: "Update Profile",
                        trailing: const SizedBox(),
                        leading: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_ios))),
                  )
                : const AppLogoWidget(
                    height: 200,
                  ),

            SizedBox(
              height: 20.h,
            ),

            Image.asset(
              "assets/images/user.png",
              height: 90,
              width: 90,
            ),
            SizedBox(
              height: 20.h,
            ),
            // Align(
            //   alignment: AlignmentDirectional.center,
            //   child: Text("Create Account",
            //       style: GoogleFonts.lobster(
            //         textStyle: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 28.sp,
            //             color: Colors.black),
            //       )),
            // ),
            !widget.onBoarding
                ? SizedBox()
                : const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 20, color: AppColors.secondaryColor),
                    ),
                  ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextronField(
                    inputController: firstNameCtr,
                    labelText: "First Name",
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: CustomTextronField(
                    inputController: lastNameCtr,
                    labelText: "Last Name",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextronField(
              inputController: genderCtr,
              labelText: "Gender",
              readOnly: true,
              onTap: () => SelectableSheetMixin.showTypeForSelect((type) {
                genderCtr.text = type;
              }, context, genderList),
            ),
            // SizedBox(
            //   height: 20.h,
            // ),
            // const Text("What Type Of User You Are?"),
            // SizedBox(
            //   height: 10.h,
            // ),
            // CustomTextronField(
            //   inputController: userTypeCtr,
            //   labelText: "Type",
            //   readOnly: true,
            //   onTap: () => SelectableSheetMixin.showTypeForSelect((type) {
            //     userTypeCtr.text = type;
            //   }, context, typeOfUser),
            // ),

            SizedBox(
              height: 20.h,
            ),
            CustomTextronField(
              inputController: emailCtrl,
              labelText: "Email",
              hintText: "@kisan_facility",
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(
              height: 20.h,
            ),
            CustomTextronField(
              inputController: phoneCtrl,
              labelText: "Phone No.",
              hintText: " (000) 000-0000",
              prefix: const Text("+91 "),
              keyboardType: TextInputType.number,
              inputFormatters: [MaskedInputFormatter('(000) 000-0000')],
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextronField(
              inputController: passwordCtrl,
              hintText: "************",
              labelText: 'Password',
            ),
            SizedBox(
              height: 20.h,
            ),
            Column(
              children: [
                CustomRoundedButton(
                    centerText:
                        !widget.onBoarding ? "Update Profile" : "Sign Up",
                    loading: onboarding,
                    onPressed: () {
                      if (widget.onBoarding == true) {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                      }
                      createAccount(context, ref);
                    }),
                !widget.onBoarding
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0.h),
                        child: const Text(
                          "Or",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      ),
                !widget.onBoarding
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Login With",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/google.png',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      )
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            !widget.onBoarding
                ? SizedBox()
                : LoginSignupBottomText(
                    login: false,
                    press: () =>
                        AppNavigation.newScreen(context, AppLoginScreen())),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
