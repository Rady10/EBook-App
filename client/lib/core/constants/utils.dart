import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<File?> pickImage() async{
  try{
    final filePickerRes =  await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if(filePickerRes != null){
      return File(filePickerRes.files.first.path!);
    }
    return null;
  } catch (e){
    return null;
  }
}

