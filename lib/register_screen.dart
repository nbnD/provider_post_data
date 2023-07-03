import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_post_data/register_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField(emailController, "Email", emailNode, passwordNode,
                  const Icon(Icons.person), false),
              const SizedBox(height: 20),
              _buildTextField(passwordController, "Password", passwordNode,
                  null, const Icon(Icons.lock), true),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    final loginResponse = loginProvider.loginUser(
                        emailController.text, passwordController.text);

                    loginResponse.then((response) {
                      if (loginProvider.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Token: ${loginProvider.loginResponse.token!}  Id: ${loginProvider.loginResponse.id.toString()}'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Failed"),
                          ),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.blue,
                  ),
                  child: loginProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      FocusNode focusNode,
      FocusNode? focusNodeNext,
      Icon? iconData,
      bool isPassword) {
    return TextFormField(
        controller: controller,
        validator: (value) {},
        keyboardType: TextInputType.emailAddress,
        obscureText: isPassword,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.12),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green.withOpacity(0.5),
            ),
          ),
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: iconData,
        ),
        onFieldSubmitted: (String val) {
          fieldFocusChange(context, focusNode, focusNodeNext);
        });
  }

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
