import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const VisionAIApp());
}

class VisionAIApp extends StatelessWidget {
  const VisionAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision AI Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0B1A),
        primaryColor: const Color(0xFF8A2BE2),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8A2BE2),
          secondary: Color(0xFF00FFFF),
          surface: Color(0xFF1A1625),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainDashboardScreen(),
        '/image_gen': (context) => const ImageGeneratorScreen(),
        '/video_gen': (context) => const VideoGeneratorScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

// Glassmorphism Container Widget
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Neon Button
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(0xFF8A2BE2).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
            : null,
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFF00FFFF)],
              )
            : null,
        border: isPrimary ? null : Border.all(color: const Color(0xFF00FFFF)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- SCREENS ---------------- //

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFFF).withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'VISION AI STUDIO',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color(0xFF8A2BE2),
                    blurRadius: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create The Impossible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8A2BE2).withOpacity(0.3),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00FFFF).withOpacity(0.2),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            // Login Form
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: GlassContainer(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 64, color: Colors.white),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to continue your AI journey',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          prefixIcon: const Icon(Icons.email, color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      NeonButton(
                        text: 'LOGIN',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(color: const Color(0xFF00FFFF).withOpacity(0.8)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const DashboardContent(),
    const Center(child: Text('Gallery')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision AI', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.diamond, color: Color(0xFF00FFFF)),
            onPressed: () => Navigator.pushNamed(context, '/premium'),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1625),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8A2BE2), Color(0xFF00FFFF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text('Creator 404', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Pro Member', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0D0B1A),
          selectedItemColor: const Color(0xFF00FFFF),
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Gallery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Unlock Ultra HD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Generate 4K images & cinematic videos.',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                NeonButton(
                  text: 'Upgrade',
                  isPrimary: false,
                  onPressed: () => Navigator.pushNamed(context, '/premium'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Create AI Magic',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              _buildFeatureCard(
                context,
                'AI Image\nGenerator',
                Icons.image,
                [const Color(0xFF8A2BE2), const Color(0xFF4B0082)],
                '/image_gen',
              ),
              _buildFeatureCard(
                context,
                'AI Video\nCreator',
                Icons.videocam,
                [const Color(0xFF00FFFF), const Color(0xFF008080)],
                '/video_gen',
              ),
              _buildFeatureCard(
                context,
                'Photo\nEnhancer',
                Icons.auto_fix_high,
                [const Color(0xFFFF1493), const Color(0xFF8B008B)],
                '/image_gen', // route to image gen for now
              ),
              _buildFeatureCard(
                context,
                'AI\nAvatars',
                Icons.face,
                [const Color(0xFFFFA500), const Color(0xFFFF4500)],
                '/image_gen', // route to image gen for now
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String title, IconData icon, List<Color> colors, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
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

class ImageGeneratorScreen extends StatelessWidget {
  const ImageGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Gen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe your imagination:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GlassContainer(
              padding: const EdgeInsets.all(4),
              child: TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'A futuristic cyber city with flying cars in 4K...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Style', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStyleChip('Cinematic', true),
                  _buildStyleChip('Anime', false),
                  _buildStyleChip('Realistic', false),
                  _buildStyleChip('Fantasy Art', false),
                  _buildStyleChip('3D Render', false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Aspect Ratio', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatioBox('1:1', Icons.crop_square, true),
                _buildRatioBox('16:9', Icons.crop_16_9, false),
                _buildRatioBox('9:16', Icons.crop_portrait, false),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: NeonButton(
                text: 'GENERATE (4K)',
                icon: Icons.auto_awesome,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8A2BE2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF8A2BE2) : Colors.white.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
      ),
    );
  }

  Widget _buildRatioBox(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF00FFFF) : Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF00FFFF) : Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFF00FFFF) : Colors.white70)),
        ],
      ),
    );
  }
}

class VideoGeneratorScreen extends StatelessWidget {
  const VideoGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Video Creator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, size: 48, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Text(
                      'Upload Source Image (Optional)',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Prompt for Video:', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),
            GlassContainer(
              padding: const EdgeInsets.all(4),
              child: TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'A dog walking in the park during golden hour, cinematic motion...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Duration:', style: TextStyle(color: Colors.white, fontSize: 16)),
                const Spacer(),
                Text('3 Seconds (Pro)', style: TextStyle(color: const Color(0xFF00FFFF))),
              ],
            ),
            Slider(
              value: 3,
              min: 1,
              max: 10,
              activeColor: const Color(0xFF00FFFF),
              onChanged: (v) {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: NeonButton(
                text: 'GENERATE VIDEO',
                icon: Icons.movie_creation,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vision AI Pro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.diamond, size: 80, color: Color(0xFF00FFFF)),
            const SizedBox(height: 24),
            const Text(
              'Unlock Limitless Creativity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildProFeature('Unlimited 4K Generations'),
            _buildProFeature('Faster Cloud Rendering'),
            _buildProFeature('No Watermark'),
            _buildProFeature('Exclusive AI Models'),
            _buildProFeature('Longer Video Generations'),
            const SizedBox(height: 40),
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Pro Monthly', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('\$9.99 / mo', style: TextStyle(color: Color(0xFF00FFFF), fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(text: 'SUBSCRIBE NOW', onPressed: () {}),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00FFFF)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Account', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.white),
            title: const Text('Theme', style: TextStyle(color: Colors.white)),
            trailing: const Text('Dark Neon', style: TextStyle(color: Colors.white54)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('About', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
