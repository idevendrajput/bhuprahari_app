import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:get/get.dart';
import '../../components/global_snackbar.dart';
import '../../main.dart'; // For global accessors, navigate, snackBar
import '../../services/auth_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/assets.dart';
import '../../utils/responsive.dart' as $appUtils;
import '../dashboard/main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = Get.put(AuthService());
  final StreamController<bool> _loadingController = StreamController<bool>();
  bool _passwordVisible = false; // For password visibility toggle

  Future<void> _login() async {
    _loadingController.add(true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      GlobalSnackbarHelper.showSnackbar($strings.error, "Please enter email and password.");
      _loadingController.add(false);
      return;
    }

    final success = await _authService.login(email, password);
    _loadingController.add(false);

    if (success) {
      GlobalSnackbarHelper.showSnackbar($strings.success, "Login successful!");
      navigate(context, const MainPage(), finishAffinity: true);
    } else {
      // Error message handled by ApiService.snackBar
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loadingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            Logos.textLogo,
            height: $appUtils.sizing(25, context),
            color: $styles.colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $appUtils.gap(context, height: 50),
            Text(
              "Welcome to Bhuprahari",
              style: TextStyle(
                fontSize: $appUtils.sizing(24.0, context),
                fontWeight: FontWeight.bold,
                color: $styles.colors.title,
              ),
              textAlign: TextAlign.center,
            ),
            $appUtils.gap(context, height: 30),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: $styles.colors.greyMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                  borderSide: BorderSide(color: $styles.colors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                  borderSide: BorderSide(color: $styles.colors.blue, width: 2.0),
                ),
              ),
              style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
            ),
            $appUtils.gap(context, height: 15),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: $styles.colors.greyMedium),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: $styles.colors.greyMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                  borderSide: BorderSide(color: $styles.colors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                  borderSide: BorderSide(color: $styles.colors.blue, width: 2.0),
                ),
              ),
              style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
            ),
            $appUtils.gap(context, height: 25),
            SizedBox(
              width: double.infinity,
              child: StreamBuilder<bool>(
                stream: _loadingController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  final isLoading = snapshot.data ?? false;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: $styles.colors.blue,
                      foregroundColor: $styles.colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                      ),
                      padding: EdgeInsets.all($appUtils.sizing(15.0, context)),
                      textStyle: TextStyle(
                        fontSize: $appUtils.sizing(16.0, context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                      height: $appUtils.sizing(20.0, context),
                      width: $appUtils.sizing(20.0, context),
                      child: CircularProgressIndicator(
                        color: $styles.colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Login"),
                  );
                },
              ),
            ),
            $appUtils.gap(context, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: $appUtils.sizing(14.0, context),
                    color: $styles.colors.title,
                  ),
                ),
                $appUtils.gap(context, width: 5),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: $styles.colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: $appUtils.sizing(14.0, context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
