abstract class AuthTemplate{

  Future loginWithUsernameAndPassword({required String username, required String password});
  Future registerWithUsernameAndPassword({required String username, required String email, required String password});
}



// class appAuth extends AuthTemplate{

// }