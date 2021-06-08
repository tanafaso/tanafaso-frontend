import 'package:azkar/views/auth/signup/signup_main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignUpMainScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          color: Colors.green.shade900),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).primaryColor,
      imagePadding: EdgeInsets.zero,
    );

    print(Theme.of(context).primaryColor);
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).primaryColor,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "مرحبا بكم في تنافسوا 🔥",
          body: "شجع أقاربك و أصدقائك وتنافس معهم على ذكر الله",
          image: _buildImage('logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "كود المستخدم",
          body:
              "بعد تسجيل الدخول، سيتم تعيين رمز لك. يمكن لأصدقائك استخدام هذا الرمز لإرسال طلب صداقة إليك. تستطيع العثور على هذا الرمز ونسخه ومشاركته مع أصدقائك من خلال صفحة الملف الشخصي. ",
          image: _buildImage('username.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "إضافة الأصدقاء",
          body:
              "إذا شارك صديق لك رمز المستخدم معك، فيمكنك إرسال طلب صداقة إليه عن طريق لصق رمز المستخدم الخاص به في صفحة دعوة الأصدقاء",
          image: _buildImage('add_friend.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "الفيسبوك",
          body:
              "يمكنك ربط حساب الفيسبوك الخاص بك حتى تتمكن من دعوة أصدقائك على الفيسبوك الذين قاموا بالفعل بتنزيل التطبيق وربط حسابات الفيسبوك الخاصة بهم بالتطبيق",
          image: _buildImage('add_facebook_friend.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "تحدي الأصدقاء",
          body: "يمكنك اختيار الأصدقاء وتحدِّيهم لقراءة بعض الأذكار وتكرارها",
          image: _buildImage('challenge.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "متابعة التقدم",
          body: "يمكنك متابعة تقدمك وتقدم أصدقائك في صفحة الأصدقاء",
          image: _buildImage('friends.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      showNextButton: false,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
      done: Padding(
        padding: const EdgeInsets.all(0),
        child: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 30,
          color: Colors.black,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.only(bottom: 3 * 8.0, left: 8, right: 8),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.black,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
