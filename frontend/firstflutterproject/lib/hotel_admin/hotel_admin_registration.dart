import 'dart:io';
import 'dart:typed_data';
import 'package:date_field/date_field.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/hotel_admin_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart'; // Required for modern look
import 'package:flutter_animate/flutter_animate.dart'; // Required for animations
import 'package:dotted_border/dotted_border.dart' as dotted_border; // Alias for DottedBorder

class HotelAdminRegistration extends StatefulWidget {
  const HotelAdminRegistration({super.key});

  @override
  State<HotelAdminRegistration> createState() => _HotelAdminRegistrationState();
}

class _HotelAdminRegistrationState extends State<HotelAdminRegistration> {

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
  bool _isButtonTapped = false; // For submit button animation

  final _formKey = GlobalKey<FormState>();

  // --- Professional Color Palette ---
  static const Color primaryColor = Color(0xFF0D47A1); // Deep Navy Blue
  static const Color accentColor = Color(0xFFFFCC80); // Light Gold/Amber
  static const Color secondaryColor = Color(0xFF00BFA5); // Teal for contrast
  static const Color backgroundColor = Color(0xFFF4F6F9); // Light Gray background
  static const Color inputFillColor = Colors.white;


  @override
  void initState() {
    super.initState();
    // Initialize to the expected default value
    selectedGender = "Male";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Title with Flutter Animate ---
                Text(
                  'Hotel Partner Sign-up 🏨',
                  style: GoogleFonts.montserrat(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: -0.5),

                const SizedBox(height: 8),

                Text(
                  'Access the management portal for your property.',
                  style: GoogleFonts.openSans(
                    color: primaryColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 500.ms, delay: 400.ms),

                const SizedBox(height: 35),

                // --- Form Fields with Staggered Animation ---

                // Full Name
                _buildModernTextField(
                  controller: name,
                  label: "Full Name",
                  icon: Icons.person_outline_rounded,
                  delay: 600.ms,
                ),
                const SizedBox(height: 18),

                // Email
                _buildModernTextField(
                  controller: email,
                  label: "Work Email Address",
                  icon: Icons.alternate_email_rounded,
                  keyboard: TextInputType.emailAddress,
                  delay: 700.ms,
                ),
                const SizedBox(height: 18),

                // Password
                _buildModernPasswordField(
                  controller: password,
                  label: "Secure Password",
                  icon: Icons.lock_outline_rounded,
                  isVisible: _isPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  delay: 800.ms,
                ),
                const SizedBox(height: 18),

                // Confirm Password
                _buildModernPasswordField(
                  controller: confirmPassword,
                  label: "Confirm Password",
                  icon: Icons.lock_reset_rounded,
                  isVisible: _isConfirmPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  delay: 900.ms,
                ),
                const SizedBox(height: 18),

                // Phone Number
                _buildModernTextField(
                  controller: cell,
                  label: "Work Phone Number",
                  icon: Icons.phone_android_rounded,
                  keyboard: TextInputType.phone,
                  delay: 1000.ms,
                ),
                const SizedBox(height: 18),

                // Address
                _buildModernTextField(
                  controller: address,
                  label: "Hotel/Office Address",
                  icon: Icons.location_city_rounded,
                  delay: 1100.ms,
                ),
                const SizedBox(height: 25),

                // --- Gender Radio Group (Animated) ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Gender",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: inputFillColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: v2.RadioGroup(
                        controller: genderController,
                        values: const ["Male", "Female", "Other"],
                        indexOfDefault: 0,
                        orientation: v2.RadioGroupOrientation.horizontal,
                        decoration: v2.RadioGroupDecoration(
                          spacing: 30,
                          labelStyle: GoogleFonts.poppins(color: primaryColor),
                          activeColor: secondaryColor, // Use Teal for distinction
                        ),
                        onChanged: (val) {
                          setState(() {
                            selectedGender = val.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms, delay: 1200.ms),
                const SizedBox(height: 25),

                // --- Date of Birth Field (Animated) ---
                DateTimeFormField(
                  decoration: InputDecoration(
                    labelText: 'Date Of Birth (Required)',
                    labelStyle: GoogleFonts.poppins(color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: secondaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.calendar_today_rounded, color: primaryColor),
                    filled: true,
                    fillColor: inputFillColor,
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dob,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ).animate().fadeIn(duration: 500.ms, delay: 1300.ms),

                const SizedBox(height: 25),

                // --- Dotted Border with Conditional Image Display (Fix applied) ---
                GestureDetector(
                  onTap: pickImage,
                  child: dotted_border.DottedBorder( // Using alias
                    borderType: dotted_border.BorderType.RRect,
                    radius: const Radius.circular(15),
                    padding: const EdgeInsets.all(8),
                    color: primaryColor.withOpacity(0.5),
                    strokeWidth: 2,
                    dashPattern: const [8, 4],
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Center(
                        child: (kIsWeb && webImage != null)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            webImage!,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ).animate().fadeIn().scale(),
                        )
                            : (!kIsWeb && selectedImage != null)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedImage!.path),
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ).animate().fadeIn().scale(),
                        )
                            : Column( // Default state when no image is selected
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded, // Changed icon for professional touch
                              color: primaryColor,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Profile Photo (Required)',
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 1400.ms),

                const SizedBox(height: 30),

                // --- Submit Button (Professional Look with Hover Animation) ---
                GestureDetector(
                  onTapDown: (_) => setState(() => _isButtonTapped = true),
                  onTapUp: (_) => setState(() => _isButtonTapped = false),
                  onTapCancel: () => setState(() => _isButtonTapped = false),
                  onTap: _register, // Calls the original method
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    height: 60,
                    // Subtle scale animation on tap
                    transform: Matrix4.identity()..scale(_isButtonTapped ? 0.98 : 1.0),
                    decoration: BoxDecoration(
                      // Professional gradient: Deep Navy to Teal
                      gradient: LinearGradient(
                        colors: [secondaryColor, secondaryColor.withOpacity(0.8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: secondaryColor.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: _isButtonTapped ? 0 : 2, // Pulsing shadow
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "REGISTER AS ADMIN",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white, // White text on Teal/Navy
                        ),
                      ),
                    ),
                  ).animate().scaleXY(duration: 400.ms, delay: 1500.ms, curve: Curves.easeOutBack),
                ),

                const SizedBox(height: 25),

                // --- Login Redirect Link (Animated) ---
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Loginpage()),
                    );
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already registered? ",
                        style: GoogleFonts.poppins(color: primaryColor.withOpacity(0.8), fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Go to Login',
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 1600.ms),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // --- Modernized Field Widgets with Animation Prop ---

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    Duration delay = Duration.zero,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: secondaryColor, width: 2), // Teal focus border
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay).slideX(begin: -0.1);
  }

  /// Modernized Password Field with eye icon and Animation Prop
  Widget _buildModernPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggle,
    Duration delay = Duration.zero,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == "Confirm Password" && value != password.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: secondaryColor, width: 2), // Teal focus border
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: primaryColor,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay).slideX(begin: -0.1);
  }

  // --- Utility Field Methods (Aliased to the new modern methods) ---

  // NOTE: These methods must remain here, but they are internally redirected
  // to the new modern methods to maintain compatibility with the rest of the code.

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return _buildModernTextField(
      controller: controller,
      label: label,
      icon: icon,
      keyboard: keyboard,
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
    return _buildModernPasswordField(
      controller: controller,
      label: label,
      icon: icon,
      isVisible: isVisible,
      onToggle: onToggle,
    );
  }


  // --- Image Picker Function (Unchanged Logic) ---

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

  // --- Registration Method (Unchanged Logic) ---

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

      final hotelAdmin = {
        "name": name.text,
        "email": email.text,
        "phone": cell.text,
        "gender": selectedGender ?? "Male",
        "address": address.text,
        "dateOfBirth": selectedDOB?.toIso8601String() ?? "",
      };

      final apiService = HotelAdminService();

      bool success = false;

      // Call registration API based on platform
      if (kIsWeb && webImage != null) {
        success = await apiService.hotelAdminRegistration(
          user: user,
          hotelAdmin: hotelAdmin,
          photoBytes: webImage!,
        );
      } else if (selectedImage != null) {
        success = await apiService.hotelAdminRegistration(
          user: user,
          hotelAdmin: hotelAdmin,
          photoFile: File(selectedImage!.path),
        );
      }

      // Handle success or failure
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hotel Admin Registration Successful')));

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