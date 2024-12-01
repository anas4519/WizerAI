import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            TextField(
              obscureText: isObscure,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure
                        ? const Icon(Icons.visibility_off_rounded)
                        : const Icon(Icons.visibility_rounded)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Container(
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: TextButton(
                onPressed: () async {},
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  ),
                ),
                child: const Text('Sign In', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'Forgot your password?',
                style: TextStyle(color: Colors.pink),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            InkWell(
              onTap: () {},
              child: const Text('Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.pink)),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Divider(
              color: Colors.grey[800],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: isDark ? Colors.grey[200] : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  // side: BorderSide(color: Colors.grey),
                ),
              ),
              onPressed: () {
                // No logic here as requested
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/google_logo.webp', // Ensure you have a Google logo in your assets
                    height: 45,
                    width: 45,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
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
