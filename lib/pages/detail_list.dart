import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MealDetailPage extends StatelessWidget {
  final String mealId;

  MealDetailPage(this.mealId, {required meal});

  @override
  Widget build(BuildContext context) {
    final apiUrl =
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meal Detail",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown.shade400,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.brown.shade300,
              Colors.brown.shade200,
              Colors.brown.shade100,
            ],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: http.get(Uri.parse(apiUrl)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Failed to load meal details'));
            }
            final meal = json.decode(snapshot.data!.body)['meals'][0];
            List<String> ingredients = [];
            for (int i = 1; i <= 20; i++) {
              if (meal['strIngredient$i'] != null &&
                  meal['strIngredient$i'].trim().isNotEmpty) {
                ingredients.add(
                    '${meal['strIngredient$i']} - ${meal['strMeasure$i']}');
              } else {
                break;
              }
            }

            return Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200, // Set the height as needed
                    child: Image.network(
                      meal['strMealThumb'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    meal['strMeal'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Kategori: ${meal['strCategory']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Area: ${meal['strArea']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: ingredients.map((ingredient) {
                      return Text(ingredient);
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    meal['strInstructions'],
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown.shade400,
        onPressed: () async {
          _launchUrl('https://www.youtube.com/watch?v=4aZr5hZXP_s');
        },
        icon: const Icon(
          Icons.open_in_browser,
          color: Colors.white,
        ),
        label: const Text(
          "Watch Tutorial",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
