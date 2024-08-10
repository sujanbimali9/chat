// import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// class AuthUser {
//   final String id;
//   String firstName;
//   String? lastName;
//   final String userName;
//   String? phoneNo;
//   final String? email;

//   String? profilePicture;
//   AuthUser({
//     required this.id,
//     required this.firstName,
//     this.lastName,
//     required this.userName,
//     this.phoneNo,
//     this.email,
//     this.profilePicture,
//   });

//   factory AuthUser.fromSupabaseUser(supabase.User user) {
//     return AuthUser(
//       id: user.id,
//       firstName: user.email!,
//       lastName: user.email!,
//       userName: user.email!,
//       phoneNo: user.phone,
//       email: user.email,
//       profilePicture: null,
//     );
//   }

//   // factory AuthUser.fromFacebookUser(Map<String, dynamic> user) {
//   //   return AuthUser(
//   //     id: user.id,
//   //     firstName: user.email!,
//   //     lastName: user.email!,
//   //     userName: user.email!,
//   //     phoneNo: user.phone,
//   //     email: user.email,
//   //     profilePicture: user.userMetadata?['profilePicture'] as String,
//   //   );
//   // }

//   factory AuthUser.fromGoogleUser(User user) {
//     return AuthUser(
//       id: user.id,
//       firstName: user.email!,
//       lastName: user.email!,
//       userName: user.email!,
//       phoneNo: user.phone,
//       email: user.email,
//       profilePicture: user.userMetadata?['profilePicture'] as String,
//     );
//   }
// }
