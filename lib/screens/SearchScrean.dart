import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/db_helper/db_helper.dart';
import 'package:student/model/students.dart';
import 'package:student/screens/viewStudent.dart';

import 'edituser.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<dynamic> userList = [];
  late List<dynamic> _filteredUserList = [];

  TextEditingController _searchController = TextEditingController();

  getAllUserDetails() async {
    var users = await DatabaseHelper.instance.readAllUsers();
    // userlist.clear();
    setState(() {
      userList = users.map((user) {
        var userModel = Student();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.clas = user['clas'];
        userModel.age = user['age'];
        userModel.Roll = user['Roll'];
        userModel.selectedImage = user['selectedImage'];
        return userModel;
      }).toList();
      _filteredUserList = userList;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  void _filterUserList(String enteredKeyword) {
    List<dynamic> filteredList = userList.where((user) {
      return user.name!.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      _filteredUserList = filteredList;
    });
  }

  showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              content: Text('Are you sure you want to delete this profile ?'),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () async {
                      var result = await DatabaseHelper.instance
                          .deleteDataById('students', userId);
                      if (result != null) {
                        Navigator.pop(context);
                        getAllUserDetails();
                        showSuccesSnackBar('User Details Deleted succesfully');
                      }
                    },
                    child: const Text(
                      'delete',
                    )),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel'),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 196, 196),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('SEARCH PAGE'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterUserList,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'What are you looking for?',
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Border color when enabled
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.greenAccent), // Border color when focused
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _filteredUserList.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewStudent(
                          user: _filteredUserList[index],
                        ),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: _filteredUserList[index].selectedImage !=
                                  null &&
                              File(_filteredUserList[index].selectedImage!)
                                  .existsSync()
                          ? FileImage(
                                  File(_filteredUserList[index].selectedImage!))
                              as ImageProvider<Object>?
                          : NetworkImage(
                                  'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png')
                              as ImageProvider<Object>,
                    ),
                    title: Text(_filteredUserList[index].name ?? 'No Name'),
                    subtitle: Text(_filteredUserList[index].clas ?? 'No class'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUser(
                                  user: _filteredUserList[index],
                                ),
                              ),
                            ).then(
                              (data) {
                                if (data != null) {
                                  getAllUserDetails();
                                  showSuccesSnackBar(
                                      'User updated successfully');
                                }
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.lightGreen,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteFormDialog(
                                context, _filteredUserList[index].id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
