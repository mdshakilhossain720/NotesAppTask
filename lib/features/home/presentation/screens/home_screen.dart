import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/firebase_service.dart';
import '../provider/notes_provider.dart';
import 'widgets/add_new_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.firebaseReady});
  final bool firebaseReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      // body: ListView.builder(
      //   padding: const EdgeInsets.all(16),
      //   itemCount: 5, // replace with provider/hive data
      //   itemBuilder: (context, index) {
      //     return _noteCard();
      //   },
      // ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text("No Notes Found"));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final note = notes[i];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _noteCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Note Title",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "This is a sample description of the note. It looks clean and modern UI.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
