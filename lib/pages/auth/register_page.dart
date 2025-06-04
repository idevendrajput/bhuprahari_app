import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/global_snackbar.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/assets.dart';
import '../../utils/responsive.dart' as $appUtils; // For global accessors, navigatePop, snackBar

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();
  final StreamController<bool> _loadingController = StreamController<bool>();
  bool _passwordVisible = false; // For password visibility toggle

  Future<void> _register() async {
    _loadingController.add(true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final profile = _profileController.text.trim();

    if (email.isEmpty || password.isEmpty || profile.isEmpty) {
      GlobalSnackbarHelper.showSnackbar($strings.error, "Please fill all fields.");
      _loadingController.add(false);
      return;
    }

    final success = await _authService.register(email, password, profile);
    _loadingController.add(false);

    if (success) {
      GlobalSnackbarHelper.showSnackbar($strings.success, "Registration successful! Please login.");
      if(!mounted) return;
      navigatePop(context);
    } else {
      // Error message handled by ApiService.snackBar
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _profileController.dispose();
    _loadingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Logos.textLogo,
          height: $appUtils.sizing(25, context),
          color: $styles.colors.blue,
        ),
        centerTitle: true,
        backgroundColor: $styles.colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $appUtils.gap(context, height: 50),
            Text(
              "Create Your Account",
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
            $appUtils.gap(context, height: 15),
            TextFormField(
              controller: _profileController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Profile Name",
                labelText: "Profile Name",
                prefixIcon: Icon(Icons.person, color: $styles.colors.greyMedium),
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
                    onPressed: isLoading ? null : _register,
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
                        : const Text("Register"),
                  );
                },
              ),
            ),
            $appUtils.gap(context, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: $appUtils.sizing(14.0, context),
                    color: $styles.colors.title,
                  ),
                ),
                $appUtils.gap(context, width: 5),
                InkWell(
                  onTap: () {
                    navigatePop(context);
                  },
                  child: Text(
                    "Login",
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
