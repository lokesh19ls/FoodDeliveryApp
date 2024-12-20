class OnboardingContent {
  String image;
  String title;
  String description;
  OnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      description: 'Pick your food from our menu\n            More than 35 times',
      image: "images/screen1.png",
      title: 'Select from Our\n      Best Menu'),
  OnboardingContent(
      description:
          'You can pay cash on delivery and\n       Card payment is available',
      image: 'images/screen2.png',
      title: 'Easy and Online payment'),
  OnboardingContent(
      description: 'Deliver your food at\n     your Doorsteps',
      image: 'images/screen3.png',
      title: 'Quick Delivery at your Doorstep'),
];
