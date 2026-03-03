// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:podverse_app/Databases/shared_pref.dart';
// import 'package:podverse_app/view/SignIn_Page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   SharedPref sp = SharedPref();

//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 "assets/images/podverse-New-logo-1 bg.png",
//                 height: 100,
//                 width: 300,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Stream Beyond Limits",
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: const Color(0xFFF5F5F1),
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//               const SizedBox(height: 50),

//               TextField(
//                 controller: nameController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFF2C2C2C),
//                   labelText: 'Full Name',
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   prefixIcon: const Icon(
//                     Icons.person_outline,
//                     color: Colors.white70,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: emailController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFF2C2C2C),
//                   labelText: 'Email',
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   hintText: 'name@example.com',
//                   hintStyle: const TextStyle(color: Colors.white38),
//                   prefixIcon: const Icon(
//                     Icons.email_outlined,
//                     color: Colors.white70,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFF2C2C2C),
//                   labelText: 'Password',
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   prefixIcon: const Icon(
//                     Icons.lock_outline,
//                     color: Colors.white70,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFF2C2C2C),
//                   labelText: 'Confirm Password',
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   prefixIcon: const Icon(Icons.lock, color: Colors.white70),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               Container(
//                 width: double.infinity,
//                 height: 55,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFE50914), Color(0xFFB81D24)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (nameController.text.trim().isEmpty ||
//                         emailController.text.trim().isEmpty ||
//                         passwordController.text.trim().isEmpty ||
//                         confirmPasswordController.text !=
//                             passwordController.text) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please fill all fields correctly'),
//                           backgroundColor: Colors.redAccent,
//                         ),
//                       );
//                       return;
//                     }

//                     try {
//                       await _firebaseAuth.createUserWithEmailAndPassword(
//                         email: emailController.text.trim(),
//                         password: passwordController.text.trim(),
//                       );

//                       Map<String, dynamic> obj = {
//                         "id": emailController.text,
//                         "name": nameController.text,
//                       };
//                       await _firebaseFirestore.collection("Profile").add(obj);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Account Created Successfully!'),
//                           backgroundColor: Color(0xFFB81D24),
//                         ),
//                       );

//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SigninPage(),
//                         ),
//                       );
//                     } on FirebaseAuthException catch (error) {
//                       log("${error.message}");
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please Enter Valid Details!'),
//                           backgroundColor: Color(0xFFB81D24),
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already have an account? ",
//                     style: TextStyle(color: Colors.white70, fontSize: 13.5),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SigninPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Sign In",
//                       style: TextStyle(
//                         color: Color(0xFFE50914),
//                         fontWeight: FontWeight.w300,
//                         fontSize: 13.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podverse_app/Databases/shared_pref.dart';
import 'package:podverse_app/view/SignIn_Page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  SharedPref sp = SharedPref();

  bool isLoading = false;

  Future<void> _signUpUser() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim() !=
            passwordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // Create user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        // Save user info to Firestore
        await _firebaseFirestore
            .collection("Profile")
            .doc(emailController.text)
            .set({
              "uid": user.uid,
              "name": nameController.text.trim(),
              "email": emailController.text.trim(),
              "createdAt": FieldValue.serverTimestamp(),
            });

        // Save locally (optional)
        // await sp.saveUserData(
        //   user.uid,
        //   nameController.text.trim(),
        //   emailController.text.trim(),
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully!'),
            backgroundColor: Color(0xFFB81D24),
          ),
        );

        // Navigate to sign-in page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninPage()),
        );
      }
    } on FirebaseAuthException catch (error) {
      log("FirebaseAuth Error: ${error.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Signup failed'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/podverse-New-logo-1 bg.png",
                height: 100,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Text(
                "Stream Beyond Limits",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFFF5F5F1),
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 50),

              // Full Name
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white70,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Sign Up Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _signUpUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25),

              // Sign In Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFFE50914),
                        fontWeight: FontWeight.w300,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
