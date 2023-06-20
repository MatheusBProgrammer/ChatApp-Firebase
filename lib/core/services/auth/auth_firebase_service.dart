import 'dart:io';
import 'dart:async';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthFirebaseService implements AuthService {
  static AppUser? _currentUser;
  static final _userStream = Stream<AppUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      //if currentUser is null, then user is null, else convert user to ChatUser
      _currentUser = user == null ? null : _toAppUser(user);
      //add the data to the stream
      //in the StreamBuilder, this data will be available in snapshot.data, and snapshot.hasData will be true, changing the UI
      controller.add(_currentUser);
    }
  });

  @override
  AppUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<AppUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    //1. get an instance of FirebaseAuth
    final signup = await Firebase.initializeApp(
      //name of the app, used to identify the app in the Firebase Console
      name: 'userSignup',
      //options, used to provide the Firebase API key
      options: Firebase.app().options,
    );
    //2. use the instance to create a new user
    //2.1 app:singup is the instance of FirebaseApp created above
    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;
    //1. Upload the user's photo to Firebase Storage
    final imageName = '${credential.user!.uid}.jpg';
    final imageURL = await _uploadImage(image, imageName);

    //2. update the user attributes to use the name and photo in the application
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageURL);

    //3. save the user to the database
    await _saveAppUser(_toAppUser(credential.user!, imageURL));

    //4. convert the User from FirebaseAuth to AppUser
    await login(email, password);

    //5. delete the instance of FirebaseApp created above
    //this is necessary because the app is not needed anymore
    //and it will cause an error if it is not deleted
    //this is because the app is already initialized in the main.dart
    //and it cannot be initialized again
    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    //get an instance of FirebaseAuth
    final auth = FirebaseAuth.instance;
    //use the instance to login the user
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadImage(File? image, String imageName) async {
    if (image == null) return null;
    //1. get an instance of FirebaseStorage
    final storage = FirebaseStorage.instance;
    //2. create a reference to the folder where the image will be saved
    final storageImagePath = storage.ref().child('user_images');
    //3. create a reference to the image file itself
    final storageImage = storageImagePath.child(imageName);
    //4. upload the image file to the reference
    await storageImage.putFile(image).whenComplete(() {});
    //5. upload the image file to the reference
    return await storageImage.getDownloadURL();
  }

  //convert the User from FirebaseAuth to AppUser
  //this is necessary because the User from FirebaseAuth does not have the attributes that are needed in the application
  //for example, the User from FirebaseAuth does not have the name attribute
  //the AppUser will be used in the application, and because of that, it needs to have the attributes that are needed in the application
  static AppUser _toAppUser(User user, [String? imageUrl]) {
    //convert the User from FirebaseAuth to AppUser
    return AppUser(
      //uses the uid from FirebaseAuth as id for AppUser
      id: user.uid,
      //uses the displayName from FirebaseAuth as name for AppUser
      //the displayname was set when the user was created, by the signup method, by the updateDisplayName method
      name: user.displayName ?? user.email!.split('@')[0],
      //uses the email from FirebaseAuth as email for AppUser
      email: user.email!,
      //uses the photoURL from FirebaseAuth as imageURL for AppUser
      //the photoURL was set when the user was created, by the signup method, by the updatePhotoURL method
      imageURL: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  //save the user to the database
  //this is important because the user will be needed in the application
  Future<void> _saveAppUser(AppUser user) async {
    //1. get an instance of FirebaseFirestore
    final store = FirebaseFirestore.instance;
    //2. create a reference to the collection where the user will be saved
    final docRef = store.collection('users').doc(user.id);
    //3. save the user to the reference
    //the user will be saved as a Map, where the key is the name of the attribute
    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageURL,
    });
  }
}
