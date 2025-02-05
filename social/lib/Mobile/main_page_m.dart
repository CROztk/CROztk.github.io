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

    // clear image
    image = null;

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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: postController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(fontSize: 24),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        suffix: IconButton(
                          iconSize: 16,
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
                      onPressed:
                          postController.text.isEmpty ? null : postMessage,
                      icon: Icon(Icons.send)),
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
            // Text and Image Posts tabs
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isTextPostTab = true),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isTextPostTab
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(30),
                        ),
                      ),
                      child: Text("Text Posts",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isTextPostTab = false),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isTextPostTab
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(30),
                          )),
                      child: Text("Image Posts",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
