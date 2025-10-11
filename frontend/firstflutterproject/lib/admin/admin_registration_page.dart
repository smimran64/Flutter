

import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;
import 'package:date_field/date_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/foundation.dart';


class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  final v2.RadioGroupController genderController = v2.RadioGroupController();

  DateTime? selectedDOB;
  XFile? selectedImage;

  String? selectedGender;

  Uint8List? webImage;

  final ImagePicker _picker = ImagePicker();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Admin Registration Form',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter the details below to continue',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Full Name
                _buildTextField(
                  controller: name,
                  label: "Full Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                // Email
                _buildTextField(
                  controller: email,
                  label: "Email",
                  icon: Icons.email,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                _buildPasswordField(
                  controller: password,
                  label: "Password",
                  icon: Icons.lock,
                  isVisible: _isPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                _buildPasswordField(
                  controller: confirmPassword,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  isVisible: _isConfirmPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                _buildTextField(
                  controller: cell,
                  label: "Phone Number",
                  icon: Icons.phone,
                  keyboard: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Address
                _buildTextField(
                  controller: address,
                  label: "Address",
                  icon: Icons.home,
                ),
                const SizedBox(height: 16),

                // Gender
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                v2.RadioGroup(
                  controller: genderController,
                  values: const ["Male", "Female", "Other"],
                  indexOfDefault: 0,
                  orientation: v2.RadioGroupOrientation.horizontal,
                  decoration: const v2.RadioGroupDecoration(spacing: 20),
                  onChanged: (val) {
                    setState(() {
                      selectedGender = val.toString();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Date of Birth
                DateTimeFormField(
                  decoration: const InputDecoration(labelText: 'Date Of Birth'),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dob,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                //Image
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Upload Image'),
                  onPressed: pickImage,
                ),

                // Display selected Image preview
                if (kIsWeb && webImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      webImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (!kIsWeb && selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(selectedImage!.path),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register, // ✅ এটিই আপনার ফাংশন কল
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  /// Password Field with eye icon
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }


  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      } else {
        final XFile? pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
        );

        if (pickedImage != null) {
          setState(() {
            selectedImage = pickedImage;
          });
        }
      }
    }
  }



  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      // Validate that the user has selected an image
      if (kIsWeb && webImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select an image')));
        return;
      }

      if (!kIsWeb && selectedImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select an image')));
        return;
      }

      // Prepare user & customer data
      final user = {
        "name": name.text,
        "email": email.text,
        "phone": cell.text,
        "password": password.text,
      };

      final admin = {
        "name": name.text,
        "email": email.text,
        "phone": cell.text,
        "gender": selectedGender ?? "Male",
        "address": address.text,
        "dateOfBirth": selectedDOB?.toIso8601String() ?? "",
      };

      final apiService = AdminService();

      bool success = false;

      // Call registration API based on platform
      if (kIsWeb && webImage != null) {
        success = await apiService.adminRegistration(
          user: user,
          admin: admin,
          photoBytes: webImage!,
        );
      } else if (selectedImage != null) {
        success = await apiService.adminRegistration(
          user: user,
          admin: admin,
          photoFile: File(selectedImage!.path),
        );
      }

      // Handle success or failure
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration Successful')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginpage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }
}
