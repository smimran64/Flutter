import 'package:flutter/material.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;
import 'package:date_field/date_field.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final v2.RadioGroupController genderController = v2.RadioGroupController();

  DateTime? selectedDOB;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Registration Form',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
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
                      _isConfirmPasswordVisible =
                      !_isConfirmPasswordVisible;
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
                const Text(
                  "Gender",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                v2.RadioGroup(
                  controller: genderController,
                  values: const ["Male", "Female", "Other"],
                  indexOfDefault: 0,
                  orientation: v2.RadioGroupOrientation.horizontal,
                  decoration: const v2.RadioGroupDecoration(
                    spacing: 20,
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // Date of Birth
                DateTimeField(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Handle form submit
                      }
                    },
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

  /// Normal TextField
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
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
