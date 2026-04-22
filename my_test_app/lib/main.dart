import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Professional State Management setup
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const StatusSaverApp(),
    ),
  );
}

// ==========================================
// 1. THEME PROVIDER (Dark/Light Mode Logic)
// ==========================================
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ==========================================
// 2. MAIN APP CONFIGURATION
// ==========================================
class StatusSaverApp extends StatelessWidget {
  const StatusSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Pro Status Saver',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF075E54), // WhatsApp Green
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF128C7E),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2C34), // WhatsApp Dark Mode Color
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

// ==========================================
// 3. DASHBOARD (Bottom Navigation Setup)
// ==========================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // List of screens for Bottom Nav
  final List<Widget> _screens =[
    const StatusTab(title: 'WhatsApp'),
    const StatusTab(title: 'WA Business'),
    const SavedGalleryTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const[
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'WhatsApp'),
          NavigationDestination(icon: Icon(Icons.business_center_outlined), label: 'Business'),
          NavigationDestination(icon: Icon(Icons.download_done_rounded), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

// ==========================================
// 4. STATUS TAB (Shows Statuses with Glassmorphism)
// ==========================================
class StatusTab extends StatelessWidget {
  final String title;
  const StatusTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Statuses'),
        actions:[
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      // Dummy Grid to show UI look
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75, // Story shape
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return GlassmorphismCard(
            index: index,
            isVideo: index % 3 == 0, // Har 3rd item ko video dikhane ke liye
          );
        },
      ),
    );
  }
}

// ==========================================
// 5. SAVED GALLERY TAB
// ==========================================
class SavedGalleryTab extends StatelessWidget {
  const SavedGalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Gallery')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Icon(Icons.folder_special, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No saved statuses yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('Saved files will appear here locally.'),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. SETTINGS TAB (Dark Mode, Language, etc.)
// ==========================================
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Tools')),
      body: ListView(
        children:[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Premium Features', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              final provider = Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('App Lock (Fingerprint/PIN)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App Lock will be added soon!')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Multi-Language'),
            subtitle: const Text('English, Hindi, Urdu, Arabic'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Smart Tools', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.crop),
            title: const Text('Image Cropper / Video Trimmer'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Watermark-Free Repost'),
            trailing: const Icon(Icons.star, color: Colors.amber),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 7. UI COMPONENTS (Glassmorphism Effect)
// ==========================================
class GlassmorphismCard extends StatelessWidget {
  final int index;
  final bool isVideo;

  const GlassmorphismCard({super.key, required this.index, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children:[
          // Background Color (Mockup for actual image/video thumbnail)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  Colors.teal.withOpacity(0.5),
                  Colors.blueAccent.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Video Play Icon Indicator
          if (isVideo)
            const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
            ),

          // Glassmorphism Overlay Menu (Bottom part)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.white, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved to Gallery!'), backgroundColor: Colors.green),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white, size: 20),
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preparing to Repost...')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
