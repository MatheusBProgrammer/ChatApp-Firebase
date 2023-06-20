import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  //the function is going to be executed in the AuthForm widget,
  //in there the AuthFormData will receive the image
  final void Function(File image) onImagePick;

  const UserImagePicker({super.key, required this.onImagePick});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    //the source is the camera or the gallery
    final picker = ImagePicker();
    //this line is going to open the camera and wait for the user to take a picture
    //so, its a Future
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      widget.onImagePick(_image!);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          //the FileImage is a class that is going to convert the file to an image
          backgroundImage: _image != null ? FileImage(_image!) : null,
          radius: 40,
          backgroundColor: Colors.grey,
        ),
        TextButton(
            onPressed: _pickImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Add Image',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
