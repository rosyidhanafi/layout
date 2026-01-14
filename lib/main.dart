import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const RecipeHome(),
    );
  }
}

class RecipeHome extends StatefulWidget {
  const RecipeHome({super.key});

  @override
  State<RecipeHome> createState() => _RecipeHomeState();
}

class _RecipeHomeState extends State<RecipeHome> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> recipes = [
    {
      'title': 'Salad',
      'image': 'assets/images/salad.jpg',
      'reviews': [
        {'user': 'User1', 'text': 'Segar dan sehat!', 'rating': 5},
        {'user': 'User2', 'text': 'Rasanya enak banget!', 'rating': 4},
        {'user': 'User3', 'text': 'Kurang garam dikit.', 'rating': 3},
      ],
    },
    {
      'title': 'Soup',
      'image': 'assets/images/soup.jpg',
      'reviews': [
        {'user': 'User1', 'text': 'Hangat dan lezat!', 'rating': 5},
        {'user': 'User2', 'text': 'Pas buat musim hujan.', 'rating': 4},
        {'user': 'User3', 'text': 'Lumayan, tapi agak asin.', 'rating': 3},
      ],
    },
    {
      'title': 'Dessert',
      'image': 'assets/images/dessert.jpg',
      'reviews': [
        {'user': 'User1', 'text': 'Manisnya pas!', 'rating': 5},
        {'user': 'User2', 'text': 'Lembut banget.', 'rating': 5},
        {'user': 'User3', 'text': 'Kurang dingin.', 'rating': 3},
      ],
    },
  ];

  void _nextPage() {
    if (_currentPage < recipes.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 Drawer (untuk hamburger)
      drawer: Drawer(
        backgroundColor: Colors.blue.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1565C0)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black87),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black87),
              title: Text('Settings'),
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 Header dengan hamburger pakai Builder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    const Text(
                      "Recipes",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Gambar + panah luar
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left, size: 50, color: Colors.white),
                      onPressed: _prevPage,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) =>
                                setState(() => _currentPage = index),
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return Image.asset(
                                recipe['image'],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right, size: 50, color: Colors.white),
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                recipes[_currentPage]['title'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (star) => Icon(
                    Icons.star,
                    color: star < 4 ? Colors.yellow : Colors.white24,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: recipes[_currentPage]['reviews'].length,
                    itemBuilder: (context, i) {
                      final review = recipes[_currentPage]['reviews'][i];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.blueAccent),
                        ),
                        title: Text(review['user'],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(review['text'],
                            style: const TextStyle(color: Colors.white70)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (star) {
                            return Icon(Icons.star,
                                size: 16,
                                color: star < review['rating']
                                    ? Colors.yellow
                                    : Colors.white24);
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Recipe",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
