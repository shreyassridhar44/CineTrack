import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../models/movie.dart'; // Import the Movie model

@lazySingleton
class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get the watchlist subcollection reference
  CollectionReference<Map<String, dynamic>> _getWatchlistCollectionRef() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in!");
    }
    // Reference to users/{userId}/watchlist
    return _firestore.collection('users').doc(userId).collection('watchlist');
  }

  // Get the user's watchlist as a stream of movie IDs
  Stream<List<int>> getWatchlistStream() {
    return _getWatchlistCollectionRef().snapshots().map((snapshot) {
      // Map each document in the collection to its ID (which is the movie ID)
      return snapshot.docs.map((doc) => int.parse(doc.id)).toList();
    });
  }

  // Add a movie to the watchlist subcollection
  Future<void> addToWatchlist(Movie movie) {
    // The document ID will be the movie's ID (converted to a string)
    return _getWatchlistCollectionRef().doc(movie.id.toString()).set({
      'title': movie.title,
      'posterPath': movie.posterPath,
      'addedAt': FieldValue.serverTimestamp(), // Good practice
    });
  }

  // Remove a movie from the watchlist by deleting its document
  Future<void> removeFromWatchlist(int movieId) {
    return _getWatchlistCollectionRef().doc(movieId.toString()).delete();
  }
}