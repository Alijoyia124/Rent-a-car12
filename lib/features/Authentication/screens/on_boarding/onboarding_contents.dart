class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Select your dream Car",
    image: "assets/images/onboardingScreen/onboarding5.jpg",
    desc: "Explore our fleet of dream cars and choose the perfect ride for your next adventure!",
  ),
  OnboardingContents(
    title: "Enjoy your Ride",
    image: "assets/images/onboardingScreen/onboarding1.jpg",
    desc:
        "Ease, comfort, and the joy of the open road. Find your perfect ride and make every drive a delightful experience.",
  ),
  OnboardingContents(
    title: "Give Your Car the Care It Deserves",
    image: "assets/images/onboardingScreen/onboarding3.jpg",
    desc:
        "Explore our car servicing options to keep your vehicle in top-notch condition.",
  ),
];
