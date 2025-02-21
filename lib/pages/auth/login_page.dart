import 'package:career_counsellor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final String webClientId = '$WEB_CLIENT_ID.apps.googleusercontent.com';
  final String iosClientId = '$IOS_CLIENT_ID.apps.googleusercontent.com';

  Future<void> _googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double iconSize = screenWidth * 0.3;

    final double curveVertexY = screenHeight * 0.55 - 50 + 5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: screenHeight * 0.55,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4F79),
                ),
              ),

              Positioned(
                top: screenHeight * 0.1,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/onboarding_images/image_4.svg',
                    // height: screenHeight * 0.3,
                    width: screenWidth * 0.8,
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.55 - 50,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: DeepCurveClipper(),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: screenHeight * 0.07),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.08),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Text(
                            'Chart Your Path to Success: Expert Career Guidance Awaits.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.1),
                              ),
                            ),
                            onPressed: _googleSignIn,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logos/google_logo.webp',
                                  height: screenWidth * 0.1,
                                  width: screenWidth * 0.1,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        // Additional content (e.g., page indicator) can go here.
                      ],
                    ),
                  ),
                ),
              ),
              // Playstore Icon: Positioned so its center is at the curve's vertex.
              Positioned(
                top: curveVertexY - iconSize / 2,
                left: (screenWidth - iconSize) / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.08),
                  child: Image.asset(
                    'assets/onboarding_images/playstore-icon.png',
                    height: iconSize,
                    width: iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeepCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Using the original fixed values for the curve:
    // - Starting point: (0, 50)
    // - Control point: (size.width/2, -40)
    // - End point: (size.width, 50)
    // This creates a deep curve (with the vertex at 5 on the y-axis).
    path.lineTo(0, 50);
    path.quadraticBezierTo(
      size.width / 2,
      -40,
      size.width,
      50,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
