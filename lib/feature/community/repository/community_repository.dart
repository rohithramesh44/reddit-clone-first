import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/model/community_model.dart';

final communityRepositoryProvider = Provider(
    (ref) => CommunityRepository(firestore: ref.watch(firestoreProvider)));

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!'; //it will go to the catch block directly
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!)); //eqal to throw e.message
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
