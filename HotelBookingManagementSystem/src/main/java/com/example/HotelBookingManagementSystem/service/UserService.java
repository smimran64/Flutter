package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.AuthenticationResponse;
import com.example.HotelBookingManagementSystem.dto.UserDto;
import com.example.HotelBookingManagementSystem.entity.Role;
import com.example.HotelBookingManagementSystem.entity.Token;
import com.example.HotelBookingManagementSystem.entity.User;
import com.example.HotelBookingManagementSystem.jwt.JwtService;
import com.example.HotelBookingManagementSystem.repository.TokenRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;

@Service
public class UserService implements UserDetailsService {


    private final PasswordEncoder passwordEncoder;
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenRepository tokenRepository;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    @Lazy
    private AuthenticationManager authenticationManager;

    @Autowired
    EmailService emailService;

    @Value("src/main/resources/static/images")
    private String uploadDir;

    public UserService(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        List<GrantedAuthority> authorities = Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_" + user.getRole().name())
        );


        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                authorities
        );
    }

    public void saveOrUpdate(User user, MultipartFile imageFile) throws IOException {

        if (imageFile != null && !imageFile.isEmpty()) {
            // Image save করে extension সহ file name নাও
            String savedFileName = saveImage(imageFile, user);
            user.setImage(savedFileName); // DB-তে এই নাম save হবে
        }


        user.setRole(Role.ADMIN);
        userRepository.save(user);
        sendActivationEmail(user);

    }

    public List<User> findAll() {

        return userRepository.findAll();
    }


    public List<UserDto> getAllUsers() {
        List<User> users = userRepository.findAll();
        return users.stream()
                .map(user -> new UserDto(
                        user.getId(),
                        user.getName(),
                        user.getEmail(),
                        user.getPhone(),
                        user.getImage(),
                        user.getRole()
                ))
                .toList();
    }

    public User findById(int id) {

        return userRepository.findById(id).get();
    }

    public void delete(User user) {
        userRepository.delete(user);
    }


//    public String saveImage(MultipartFile file, User user) {
//
//        Path uploadPath = Paths.get(uploadDir + "/users");
//
//        if (!Files.exists(uploadPath)) {
//
//            try {
//                Files.createDirectory(uploadPath);
//
//            } catch (IOException e) {
//                throw new RuntimeException(e);
//            }
//        }
//
//        String fileName = file.getName() + "_" + UUID.randomUUID().toString();
//
//
//        try {
//            Path filePath = uploadPath.resolve(fileName);
//            Files.copy(file.getInputStream(), filePath);
//
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }
//
//        return fileName;
//
//    }


    public String saveImage(MultipartFile file, User user) throws IOException {

        Path uploadPath = Paths.get(uploadDir + "/users");

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // original filename এবং extension নাও
        String userName = user.getName();
        String fileName = userName.trim().replaceAll("\\s+", "_");

        String extension = "";
        if (file.getOriginalFilename() != null && file.getOriginalFilename().contains(".")) {
            extension = file.getOriginalFilename()
                    .substring(file.getOriginalFilename().lastIndexOf("."));
        }


        String savedFileName = userName + "_" + UUID.randomUUID() + extension;
        Path filePath = uploadPath.resolve(savedFileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);


        return savedFileName; // এটা DB-তে save করো
    }


    private void sendActivationEmail(User user) {
        String subject = "Welcome to Our Service – Confirm Your Registration";

        String activationLink = "http://localhost:8085/api/user/active/" + user.getId();

        String mailText = "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<style>"
                + "  body { font-family: Arial, sans-serif; line-height: 1.6; }"
                + "  .container { max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px; }"
                + "  .header { background-color: #4CAF50; color: white; padding: 10px; text-align: center; border-radius: 10px 10px 0 0; }"
                + "  .content { padding: 20px; }"
                + "  .footer { font-size: 0.9em; color: #777; margin-top: 20px; text-align: center; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "  <div class='container'>"
                + "    <div class='header'>"
                + "      <h2>Welcome to Our Platform</h2>"
                + "    </div>"
                + "    <div class='content'>"
                + "      <p>Dear " + user.getName() + ",</p>"
                + "      <p>Thank you for registering with us. We are excited to have you on board!</p>"
                + "      <p>Please confirm your email address to activate your account and get started.</p>"
                + "      <p>If you have any questions or need help, feel free to reach out to our support team.</p>"
                + "      <br>"
                + "      <p>Best regards,<br>The Support Team</p>"
                + "      <p>To Activate Your Account, please click the following link:</p>"
                + "      <p><a href=\"" + activationLink + "\">Activate Account</a></p>"
                + "    </div>"
                + "    <div class='footer'>"
                + "      &copy; " + java.time.Year.now() + " YourCompany. All rights reserved."
                + "    </div>"
                + "  </div>"
                + "</body>"
                + "</html>";

        try {
            emailService.sendSimpleEmail(user.getEmail(), subject, mailText);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send activation email", e);
        }
    }


    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLogout(false);
        token.setUser(user);

        tokenRepository.save(token);

    }

    private void removeAllTokenByUser(User user) {
        List<Token> validTokens = tokenRepository.findAllTokenByUser(user.getId());

        if (validTokens.isEmpty()) {
            return;
        }

        validTokens.forEach(t -> {
            t.setLogout(true);
        });

        tokenRepository.saveAll(validTokens);

    }

    // It is Login Method


    public AuthenticationResponse authencate(User request) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByEmail(request.getEmail()).orElseThrow();

        if (!user.isActive()) {
            throw new RuntimeException("Account is not activated. Please check your email for activation link.");
        }

        // Generate Token for Current User
        String jwt = jwtService.generateToken(user);

        //Remove all existing toke for this user
        removeAllTokenByUser(user);

        saveUserToken(jwt, user);

        return new AuthenticationResponse(jwt, "User Login Successful");

    }

    public String activeUser(int id) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not Found with this ID " + id));

        if (user != null) {
            user.setActive(true);

            userRepository.save(user);
            return "User Activated Successfully!";

        } else {
            return "Invalid Activation Token!";
        }

    }


    // Forgot Password

    public String forgotPassword(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();

            // 1. Token generate
            String token = UUID.randomUUID().toString();
            user.setResetToken(token);

            System.out.println(token +"++++++++++++++++++++++++");

            // 2. Expiry after 15 munites
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, 15);
            Date expiryDate = calendar.getTime();
            user.setTokenExpiry(expiryDate);

            // 3. Save user
            userRepository.save(user);

            // Reset link & email

            String resetLink = "http://localhost:4200/reset-password?token=" + token;
            String mailBody = "<!DOCTYPE html>"
                    + "<html><body>"
                    + "<p>Dear " + user.getName() + ",</p>"
                    + "<p>You requested a password reset. Click the link below to reset your password:</p>"
                    + "<p><a href=\"" + resetLink + "\">Reset Password</a></p>"
                    + "<p>This link will expire in 15 minutes.</p>"
                    + "<p>Best regards,<br>Support Team</p>"
                    + "</body></html>";

            try {
                sendEmail(user.getEmail(), "Password Reset Request", mailBody);
            } catch (MessagingException e) {
                throw new RuntimeException("Failed to send email", e);
            }

            return "Reset link sent to your email!";
        }
        return "User not found!";
    }

    // Reset Password
    public String resetPassword(String token, String newPassword) {
        Optional<User> userOpt = userRepository.findByResetToken(token);
        if (userOpt.isPresent()) {
            User user = userOpt.get();

            Date now = new Date();
            if (user.getTokenExpiry() == null || user.getTokenExpiry().before(now)) {
                return "Token expired!";
            }

            user.setPassword(passwordEncoder.encode(newPassword));
            user.setResetToken(null);
            user.setTokenExpiry(null);
            userRepository.save(user);

            return "Password updated successfully!";
        }
        return "Invalid token!";
    }

    // General sendEmail method
    private void sendEmail(String to, String subject, String body) throws MessagingException {
        emailService.sendSimpleEmail(to, subject, body);
    }


}
