import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_drawer.dart';
import 'package:social/components/my_photo_post.dart';
import 'package:social/components/my_text_post.dart';
import 'package:social/database/firestore.dart';
import 'package:social/database/storage.dart';

class MyMainPageMobile extends StatefulWidget {
  const MyMainPageMobile({super.key});

  @override
  State<MyMainPageMobile> createState() => _MyMainPageMobileState();
}

class _MyMainPageMobileState extends State<MyMainPageMobile> {
  // text controller for post
  final TextEditingController postController = TextEditingController();

  // firestore access
  final FireStoreDatabase fireStore = FireStoreDatabase();

  // storage access
  final Storage storage = Storage();

  // tab selector
  bool isTextPostTab = true;

  // image to upload
  XFile? image;

  // post the message
  void postMessage() async {
    // check if the message is empty
    if (postController.text.isEmpty && image == null) {
      return;
    }

    // show circular progress indicator dialog
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // add post to firestore
    if (image != null) {
      String name = FirebaseAuth.instance.currentUser!.email! +
          Timestamp.now().toString();
      await storage.uploadImageXFile("photoPosts/", name, image!);
      String url = await storage.getImage("photoPosts/", "$name.png");
      if (url.isEmpty) {
        Navigator.pop(context);
        return;
      }
      await fireStore.addPhotoPost(postController.text, url);
    } else {
      await fireStore.addPost(postController.text);
    }

    // clear the textfield
    postController.clear();

    // close the dialog
    Navigator.pop(context);

    // update the UI
    setState(() {});
  }

  // select image
  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      drawer: MyDrawer(),
      body: Center(
        child: Column(children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(),
                    suffix: IconButton(
                      icon: image == null
                          ? Icon(Icons.image)
                          : Icon(Icons.image_not_supported),
                      onPressed: image == null
                          ? selectImage
                          : () {
                              image = null;
                              setState(() {});
                            },
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length < 2) {
                      setState(() {});
                    }
                  },
                ),
              ),
              IconButton(
                  onPressed: postController.text.isEmpty ? null : postMessage,
                  icon: Icon(Icons.send)),
            ],
          ),

          // Text and Image Posts tabs
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isTextPostTab = true),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isTextPostTab
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Text Posts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                isTextPostTab ? Colors.white : Colors.black)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isTextPostTab = false),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isTextPostTab
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Image Posts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                isTextPostTab ? Colors.black : Colors.white)),
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: isTextPostTab
                ? fireStore.getPosts()
                : fireStore.getPhotoPosts(),
            builder: (context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // error
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error, size: 80),
                      Text("Something went wrong"),
                    ],
                  ),
                );
              }
              // success
              if (snapshot.hasData) {
                // extract data
                final posts = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return isTextPostTab
                          ? MyTextPost(post: posts[index])
                          : MyPhotoPost(post: posts[index]);
                    },
                  ),
                );
              }
              // no data
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 80),
                    Text("No posts found"),
                  ],
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
