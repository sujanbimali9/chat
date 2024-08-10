class TValidator {
  static String? email(String? text) {
    if (text == null || text.isEmpty) {
      return 'Email is required.';
    }
    final emailRegExp = RegExp(r'[\w.-/]+@[\w-/]+\.[\w]{2,3}');

    if (!emailRegExp.hasMatch(text)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? phone(String? phoneNo) {
    if (phoneNo == null || phoneNo.isEmpty) return null;
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNo)) {
      return 'Invalid phone number';
    }
    return null;
  }

  static String? password(String? text) {
    if (text == null || text.isEmpty) {
      return 'Password is required.';
    }

    if (!RegExp(r'[\w._-]{8,}').hasMatch(text)) {
      return 'Must be 8 character or more';
    } else if (!RegExp(r'[A-Z]+').hasMatch(text)) {
      return 'Must have atleast 1 uppercase';
    } else if (!RegExp(r'[\W]+').hasMatch(text)) {
      return 'Must have atleast 1 specialcharacter';
    } else if (!RegExp(r'[\d]+').hasMatch(text)) {
      return 'Must have atleast 1 number';
    } else if (!RegExp(r'[a-z]+').hasMatch(text)) {
      return 'Must have atleast 1 lowercase';
    }

    return null;
  }

  static String? test(String? text) {
    if (text == null || text.isEmpty) {
      return 'Email is required.';
    }
    final emailRegExp = RegExp(r'[\w-./]+@([\w-/]+\.)+[\w-/]{2,4}$');

    if (!emailRegExp.hasMatch(text)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validate(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }
}
