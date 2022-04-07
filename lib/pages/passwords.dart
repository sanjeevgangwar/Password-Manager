import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/controller/encrypter.dart';
import 'package:password_manager/icons_map.dart' as CustomIcons;

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  Box box = Hive.box('passwords');
  bool longPressed = false;
  EncryptService _encryptService = new EncryptService();
  Future fetch() async {
    if (box.values.isEmpty) {
      return Future.value(null);
    } else {
      return Future.value(box.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Your Passwords",
          style: TextStyle(
            fontFamily: "customFont",
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: insertDB,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "You have saved no password 😓.\nSave some... \nIt's Secure 🔐.\nEverything is in your Phone..",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.blue,
                  fontFamily: "customFont",
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map data = box.getAt(index);
                return Card(
                  margin: EdgeInsets.all(
                    12.0,
                  ),
                  child: Slidable(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 15.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      tileColor: Colors.white,
                      leading: CustomIcons.icons[data['type']] ??
                          Icon(
                            Icons.lock,
                            color: Colors.blue,
                            size: 25.0,
                          ),
                      title: Text(
                        "${data['nick']}",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "click on copy icon to copy your password",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _encryptService.copyToClipboard(
                            data['password'],
                            context,
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          color: Colors.blue,
                          size: 25.0,
                        ),
                      ),
                    ),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void insertDB() {
    String type;
    String nick;
    String email;
    String password;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(
          12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Service",
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "Google",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                  color: Colors.white,
                ),
                onChanged: (val) {
                  type = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nick Name",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "Will be dispplayed as a Title",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                  color: Colors.white,
                ),
                onChanged: (val) {
                  nick = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username/Email/Phone",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                  color: Colors.white,
                ),
                onChanged: (val) {
                  email = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont,",
                  color: Colors.white,
                ),
                onChanged: (val) {
                  password = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // encrypt
                  password = _encryptService.encrypt(password);
                  // insert into db
                  Box box = Hive.box('passwords');
                  // insert
                  var value = {
                    'type': type.toLowerCase(),
                    'nick': nick,
                    'email': email,
                    'password': password,
                  };
                  box.add(value);

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "customFont",
                  ),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 50.0,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
