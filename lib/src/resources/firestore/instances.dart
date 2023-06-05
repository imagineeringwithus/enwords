import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'constants.dart';
import 'helper.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference get colWords => _firestore.collection(kdb_words);

final _storage = FirebaseStorage.instance;
Reference refByUrl(String url) => _storage.refFromURL(url);
Reference get refGalleryImages => _storage.ref().child('gallery/images/');
