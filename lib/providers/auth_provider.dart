import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _user = supabase.auth.currentUser;
  }

  Future<bool> signUp(String email, String password, String fullName) async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('Attempting signup with email: $email');

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    print('Signup response user: ${response.user?.id}');
    print('Signup response session: ${response.session?.accessToken}');

    // Check if user was created (even without immediate session)
    if (response.user != null) {
      print('User created successfully: ${response.user!.email}');
      
      // Set the user
      _user = response.user;
      
      // Try to create profile
      try {
        await supabase.from('profiles').upsert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });
        print('Profile created successfully');
      } catch (profileError) {
        print('Profile creation failed: $profileError');
        // Don't fail the signup for this
      }
      
      // If no session but user exists, it might need email confirmation
      if (response.session == null) {
        print('User created but needs email confirmation');
        _errorMessage = 'Account created! Please check your email for confirmation, or try logging in directly.';
        // Still return true because account was created
        return true;
      }
      
      return true;
    }
    
    print('No user in response');
    _errorMessage = 'Failed to create account';
    return false;
    
  } on AuthApiException catch (e) {
    print('Auth API error: ${e.message}');
    _errorMessage = e.message;
    return false;
  } catch (e) {
    print('General signup error: $e');
    _errorMessage = e.toString();
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('Attempting signin with email: $email'); // Debug log

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        return true;
      }
      
      _errorMessage = 'Invalid email or password';
      return false;
    } catch (e) {
      print('Sign in error: $e'); // Debug log
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      _user = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}