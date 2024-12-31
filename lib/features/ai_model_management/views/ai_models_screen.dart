import 'package:flutter/material.dart';

class AIModelScreen extends StatelessWidget {
  const AIModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Models"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle filter selection
            },
            itemBuilder: (BuildContext context) {
              return ['Sort by Size', 'Sort by Name', 'Offline Only']
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual model count
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.smart_toy, size: 40, color: Colors.blue),
                    title: Text("Model ${index + 1}"),
                    subtitle: const Text(
                        "Version: 1.0\nSize: 500MB\nStatus: Downloaded"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle actions: Set Active, Update, Delete
                      },
                      itemBuilder: (context) {
                        return ['Set as Active', 'Update', 'Delete']
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Upload Custom Model Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Import Local Model"),
              onPressed: () {
                // Handle custom model upload
              },
            ),
          ),
        ],
      ),
    );
  }
}
