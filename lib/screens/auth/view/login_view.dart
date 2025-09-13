import 'package:ayurvedic_centre_app/core/util/common_widgets.dart';
import 'package:ayurvedic_centre_app/core/util/sized_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/routes.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildForm(context, authProvider)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.asset('assets/images/loginBg.png', width: double.infinity, height: 250, fit: BoxFit.cover),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logoPng.png', height: 84, width: 80, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizeBoxH(30),
            text(
              text: 'Login or register to book \nyour appointments',
              size: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
            SizeBoxH(30),
            _buildEmailField(context),
            SizeBoxH(25),
            _buildPasswordField(context),
            SizeBoxH(80),
            _buildLoginButton(context, authProvider),
            SizeBoxH(40),
            const Spacer(),
            _buildTermsText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(text: 'Email', size: 16),
        SizeBoxH(6),
        buildCommonTextFormField(
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: _emailController,
          context: context,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
            return null;
          },
          maxLine: 1,
          obscureText: false,
          onTap: () {},
          onFieldSubmitted: (_) {},
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(text: 'Password', size: 16),
        SizeBoxH(6),
        buildCommonTextFormField(
          hintText: 'Enter password',
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          controller: _passwordController,
          context: context,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password is required';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
          maxLine: 1,
          obscureText: true,
          onTap: () {},
          onFieldSubmitted: (_) {},
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider) {
    return button(
      name: 'Login',
      height: 50,
      isLoading: authProvider.isLoading,
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          final success = await authProvider.loginFn(_emailController.text.trim(), _passwordController.text.trim());
          if (success) {
            Navigator.pushNamed(context, AppRoutes.home);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed. Please try again')));
          }
        }
      },
    );
  }

  Widget _buildTermsText(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 12, color: Colors.black87),
            children: [
              const TextSpan(text: 'By creating or logging into an account you are agreeing with our '),
              TextSpan(
                text: 'Terms and Conditions',
                style: const TextStyle(color: Color(0XFF0028FC), fontWeight: FontWeight.w600),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Terms and Conditions tapped')));
                  },
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(color: Color(0XFF0028FC), fontWeight: FontWeight.w600),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy Policy tapped')));
                  },
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
    );
  }
}
