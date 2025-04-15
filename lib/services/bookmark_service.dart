import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> _userBookmarksCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(user.email).collection('bookmarks');
  }

  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final collection = _userBookmarksCollection();
    final snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> addBookmark(Map<String, dynamic> recipe) async {
    final collection = _userBookmarksCollection();
    final docRef = collection.doc(recipe['id'].toString());
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set(recipe);
    }
  }

  static Future<void> removeBookmark(int recipeId) async {
    final collection = _userBookmarksCollection();
    final docRef = collection.doc(recipeId.toString());
    await docRef.delete();
  }

  static Future<bool> isBookmarked(int recipeId) async {
    final collection = _userBookmarksCollection();
    final docRef = collection.doc(recipeId.toString());
    final doc = await docRef.get();
    return doc.exists;
  }
}
