import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in
  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  //sign up
  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password, emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/');
  }

  //sign out
  Future<void> signOut() async{
    await _supabase.auth.signOut();
  }

  //Get user email
  String? getCurrentUserEmail(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getCurrentUserId(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
