import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  // firebase storage
  final storage = FirebaseStorage.instance;

  // loading status
  bool _isLoading = false;

  // uploading status
  bool _isUploading = false;

  // getters
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // get images
  Future<List<String>> getImages(String folderName) async {
    // set loading status
    _isLoading = true;

    // get the list under the folder folderName
    ListResult result = await storage.ref(folderName).listAll();

    // get the URLs of the images
    final imageURLs =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

    // set loading status
    _isLoading = false;

    // return the URLs
    return imageURLs;
  }

  // get image
  Future<String> getImage(String folderName, String imageName) async {
    // set loading status
    _isLoading = true;

    // get the URL of the image
    final imageURL =
        await storage.ref(folderName).child(imageName).getDownloadURL();

    // set loading status
    _isLoading = false;

    // return the URL
    return imageURL;
  }

  // upload image
  Future<void> uploadImage(String folderName, String imageName) async {
    // set uploading status
    _isUploading = true;

    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // try to upload the file
      try {
        // path to the image
        String path = "$folderName/$imageName.png";

        // upload the file
        await storage.ref(path).putData(await image.readAsBytes());

        // set uploading status
        _isUploading = false;
      } catch (e) {
        // set uploading status
        _isUploading = false;
      }
    }

    // set uploading status
    _isUploading = false;
  }

  // delete image with the name imageName under the folder folderName
  Future<void> deleteImage(String folderName, String imageName) async {
    // delete the image
    await storage.ref(folderName).child(imageName).delete();
  }

  // delete image with URL imageURL
  Future<void> deleteImageURL(String imageURL) async {
    try {
      // delete the image
      await storage.refFromURL(imageURL).delete();
    } catch (e) {}
  }
}
