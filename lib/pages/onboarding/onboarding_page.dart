import 'package:flutter/material.dart';
import 'package:flutter_onboarding/pages/home/home_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  int _currentPage = 0;

  List<OnboardingView> pages = const [
    OnboardingView(
      imagePath: 'assets/images/nft_image_1.gif',
      title: 'Largest digital NFT marketplace',
      subtitle: 'More freedom and flexibility',
    ),
    OnboardingView(
      imagePath: 'assets/images/nft_image_2.gif',
      title: 'Instant sales or auction bids',
      subtitle: 'Easy trade or exchange of assets',
    ),
    OnboardingView(
      imagePath: 'assets/images/nft_image_3.gif',
      title: 'Rarest items from digital artists',
      subtitle: 'Early access to unique items',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [...pages],
                  ),
                  if (_currentPage < pages.length - 1)
                    Positioned(
                      top: 10.0,
                      right: 5.0,
                      child: TextButton(
                        onPressed: () {
                          _controller.animateToPage(
                            pages.length - 1,
                            duration: Durations.medium2,
                            curve: Curves.bounceInOut,
                          );
                        },
                        child: const Text(
                          "Skip",
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10)
                  .copyWith(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: textColor!,
                      dotColor: textColor.withOpacity(0.45),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 5,
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: (_currentPage + 1) / pages.length,
                    ),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: value,
                            backgroundColor: textColor.withOpacity(0.35),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              textColor,
                            ),
                            strokeWidth: 3,
                          ),
                          IconButton(
                            tooltip: "Next",
                            icon: Icon(
                              _currentPage == pages.length - 1
                                  ? Icons.check_rounded
                                  : Icons.chevron_right_rounded,
                              color: textColor,
                            ),
                            onPressed: () {
                              if (_currentPage < pages.length - 1) {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                // Acción cuando se completa el onboarding => HomePage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomePage(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingView extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingView({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 300,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
