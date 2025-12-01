import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/landing_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(context),

          //Change Password
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                _changePasswordField(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.password_rounded),
                  SizedBox(width: 8),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          //Sign Out
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.exit_to_app_rounded),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          //Delete Account
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final TextEditingController editController =
                    TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('Please Confirm'),
                      content: Column(
                        mainAxisSize: .min,
                        children: [
                          const Text('Enter password to delete account'),
                          TextField(
                            obscureText: true,
                            controller: editController,
                            onSubmitted: (input) =>
                                _deleteAccountConfirmation(input),
                            decoration: InputDecoration(
                              hintText: "Enter password...",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        // The "Yes" button
                        TextButton(
                          onPressed: () async {
                            _deleteAccountConfirmation(
                              editController.text,
                              onSuccess: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                  ..clearSnackBars()
                                  ..showSnackBar(
                                    SnackBar(content: Text("Account deleted")),
                                  );
                              },
                              onFail: (message) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..clearSnackBars()
                                  ..showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                              },
                            );
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_circle_outline_rounded),
                  SizedBox(width: 8),
                  Text(
                    'Delete Accounts',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  User? user = FirebaseAuth.instance.currentUser;

  return Container(
    padding: EdgeInsets.all(16.0),

    alignment: Alignment.center,
    child: Column(
      children: [
        Text(
          'Current User:',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 8),

        FittedBox(
          fit: .fitWidth,
          child: Text(
            '${user?.email}',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 25,
              fontWeight: FontWeight.w100,
              letterSpacing: 8,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 15),
      ],
    ),
  );
}

//Password Changer
Future<void> _changePasswordField(context) async {
  String currentPassword = '';
  String newPassword = '';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFFF8EDEA),
        title: Text(
          'Change Password',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 20,
            fontWeight: FontWeight.w100,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
              onChanged: (value) {
                currentPassword = value;
              },
            ),

            const SizedBox(height: 8),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
              onChanged: (value) {
                newPassword = value;
              },
            ),
          ],
        ),

        actions: <Widget>[
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await _changePassword(currentPassword, newPassword, context);
                  Navigator.of(context).pop();
                },
                child: Text('Change'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> _changePassword(
  String currentPassword,
  String newPassword,
  context,
) async {
  User? user = await FirebaseAuth.instance.currentUser;

  AuthCredential credential = EmailAuthProvider.credential(
    email: user!.email!,
    password: currentPassword,
  );

  await user
      .reauthenticateWithCredential(credential)
      .then((_) {
        return user.updatePassword(newPassword);
      })
      .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );
      })
      .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password not changed due to ${error.toString()}'),
          ),
        );
      });
}

Future<void> _deleteAccountConfirmation(
  String password, {
  Function()? onSuccess,
  Function(String)? onFail,
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) {
    if (onFail != null) {
      onFail("account not initialized properly for deletion");
    }
    return;
  }
  AuthCredential cred = EmailAuthProvider.credential(
    email: user.email!,
    password: password,
  );

  user
      .reauthenticateWithCredential(cred)
      .then((value) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        db.collection('users').doc(value.user!.uid).delete();
        user.delete();
        if (onSuccess != null) {
          onSuccess();
        }
      })
      .catchError((error) {
        if (onFail != null) {
          onFail("$error");
        }
      });
}
