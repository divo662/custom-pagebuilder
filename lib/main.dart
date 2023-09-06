import 'package:flutter/material.dart';

const item = [
  Color(0xffff1744),
  Color(0xffff9100),
  Color(0xff00695c),
  Color(0xff5c6bc0),
  Color(0xff37474f),
  Color(0xfff50057)
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: CustomPage(),
    );
  }
}

class CustomPage extends StatefulWidget {
  const CustomPage({Key? key}) : super(key: key);

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final ValueNotifier<double> _notifier = ValueNotifier(0.0);
  final _button = GlobalKey();
  final _pageController = PageController();

  final List<String> pageImg = [
    "images/mp3-player.png",
    "images/listening.png",
    "images/listening2.png",
    "images/rollerblade.png",
    "images/bee.png",
    "images/music-player.png",
  ];

  final List<String> musicTitle = [
    "Welcome to Musica!",
    "Musica Magic",
    "Let's Jam, Musica-Style",
    "Musica Mania Unleashed",
    "Musica: Where Ears Party!",
    "Musica Mayhem",
  ];

  final List<String> musicDesc = [
    "Where the beats are bouncier than a kangaroo."
        "Join the musical madness!",

    "Get ready to groove, spin, and twirl through a world"
        "of music that's as wild as a dancing pineapple",

    "Dive into the zaniest melodies and rhythms in town."
        "Warning: May induce spontaneous dance-offs!",

    "Discover tunes so catchy, even your pet goldfish will"
        "be tapping its fins. It's a musical riot!",

    "We're turning up the volume on fun! Grab your"
        "headphones and let the musical extravaganza begin!",

    "It's a cacophony of musical awesomeness!"
        "Prepare for a symphony of laughter and good vibes!",
  ];

  @override
  void initState() {
    _pageController.addListener(() {
      _notifier.value = _pageController.page!;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _notifier,
            builder: (_, __) => CustomPaint(
              // Create a CustomPaint widget with the FlowPainter as the painter
              painter: FlowPainter(
                context: context,
                notifier: _notifier,
                target: _button,
                colors: item, // Pass the 'item' list of colors to the painter
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController, // Controller for managing page scrolling
            itemCount: item.length, // Total number of pages
            itemBuilder: (c, i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Image.asset(
                        pageImg[i], // Display an image based on the index 'i'
                        width: 290,
                        height: 290,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(musicTitle[i], // Display the title from 'musicTitle' list
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: Colors.white,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(musicDesc[i], // Display the description from 'musicDesc' list
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey.shade200,
                        fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 250, left: 10),
              child: Text(
                "Slide to continue >>",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.grey.shade200,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 195),
                  child: ClipOval(
                    child: AnimatedBuilder(
                      animation: _notifier,
                      builder: (_, __) {
                        // Calculate the fractional part of _notifier's value
                        final animatorVal = _notifier.value - _notifier.value.floor();
                        double opacity = 0, iconPos = 0;
                        int colorIndex;

                        // If the fractional part is less than 0.5, perform these actions
                        if (animatorVal < 0.5) {
                          opacity = (animatorVal - 0.5) * -2;
                          iconPos = 80 * -animatorVal;
                          colorIndex = _notifier.value.floor() + 1;
                        }
                        // If the fractional part is greater than or equal to 0.5, perform these actions
                        else {
                          colorIndex = _notifier.value.floor() + 2;
                          iconPos = -80;
                        }

                        // If the fractional part is greater than 0.9, perform these actions
                        if (animatorVal > 0.9) {
                          iconPos = -250 * (1 - animatorVal) * 10;
                          opacity = (animatorVal - 0.9) * 10;
                        }

                        // Ensure that colorIndex stays within the bounds of the 'item' list
                        colorIndex = colorIndex % item.length;

                        // Build a circular button with animation effects
                        return SizedBox(
                          key: _button,
                          width: 80,
                          height: 100,
                          child: Transform.translate(
                            offset: Offset(iconPos, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item[colorIndex],
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(opacity),
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FlowPainter extends CustomPainter {
  final BuildContext context;
  final ValueNotifier<double> notifier;
  final GlobalKey target;
  final List<Color> colors;

  RenderBox? _renderBox;

  FlowPainter({
    required this.context,
    required this.notifier,
    required this.target,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final screen = MediaQuery.of(context).size;

    // Check if _renderBox is null, and if so, find the RenderBox from the target context.
    if (_renderBox == null && target.currentContext != null) {
      _renderBox = target.currentContext!.findRenderObject() as RenderBox;
    }

    // Check if _renderBox or notifier is null, and if so, return early.
    if (_renderBox == null) return;

    // Get the current page as an integer.
    final page = notifier.value.floor();

    // Calculate the fractional part of the page change.
    final animatorVal = notifier.value - page;

    // Convert the target position to global coordinates.
    final targetPos = _renderBox!.localToGlobal(Offset.zero);

    // Define scaling factors for x and y dimensions.
    final xScale = screen.height * 8, yScale = xScale / 2;

    // Apply a curve transformation to animatorVal.
    var curvedVal = Curves.easeInOut.transformInternal(animatorVal);

    // Calculate the reversal of the curve transformation.
    final reversal = 1 - curvedVal;

    Paint buttonPaint = Paint(), bgPaint = Paint();
    Rect buttonRect, byReact = Rect.fromLTWH(0, 0, screen.width, screen.height);

    if (animatorVal < 0.5) {
      // Set background and button colors based on the current page.
      bgPaint.color = colors[page % colors.length];
      buttonPaint.color = colors[(page + 1) % colors.length];

      // Calculate the button rectangle for the first half of the animation.
      buttonRect = Rect.fromLTRB(
        targetPos.dx - (xScale * curvedVal),
        targetPos.dy - (yScale * curvedVal),
        targetPos.dx + _renderBox!.size.width * reversal,
        targetPos.dy + _renderBox!.size.height + (yScale * curvedVal),
      );
    } else {
      // Set background and button colors for the second half of the animation.
      bgPaint.color = colors[(page + 1) % colors.length];
      buttonPaint.color = colors[page % colors.length];

      // Calculate the button rectangle for the second half of the animation.
      buttonRect = Rect.fromLTRB(
        targetPos.dx + _renderBox!.size.width * reversal,
        targetPos.dy - xScale * reversal,
        targetPos.dx + _renderBox!.size.width + xScale * reversal,
        targetPos.dy + _renderBox!.size.height + yScale * reversal,
      );
    }

    // Draw the background rectangle.
    canvas.drawRect(byReact, bgPaint);

    // Draw the rounded button rectangle.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        buttonRect,
        Radius.circular(screen.height),
      ),
      buttonPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
