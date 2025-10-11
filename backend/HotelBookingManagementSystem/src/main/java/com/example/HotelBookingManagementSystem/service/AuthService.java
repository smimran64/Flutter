package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.AuthenticationResponse;
import com.example.HotelBookingManagementSystem.dto.UserDto;
import com.example.HotelBookingManagementSystem.entity.*;
import com.example.HotelBookingManagementSystem.jwt.JwtService;
import com.example.HotelBookingManagementSystem.repository.TokenRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import jakarta.mail.MessagingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class AuthService {

    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private TokenRepository tokenRepository;
    @Autowired
    private EmailService emailService;
    @Autowired
    private CustomerService customerService;

    @Autowired
    private HotelAminService hotelAminService;

    @Autowired
    private AdminService adminService;

    @Autowired
    @Lazy
    private AuthenticationManager authenticationManager;

    @Value("src/main/resources/static/images")
    private String uploadDir;
    @Autowired
    private JwtService jwtService;


    public void saveOrUpdate(User user, MultipartFile imageFile) {

        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = saveImage(imageFile, user);
            user.setImage(filename);
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


    public UserDto getUserById(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new UserDto(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getPhone(),
                user.getImage(),
                user.getRole()
        );
    }

    public User findById(int id) {
        return userRepository.findById(id).get();
    }

    public void delete(User user) {
        userRepository.delete(user);
    }



    private void sendActivationEmail(User user) {
        String subject = "Welcome to Our Service – Confirm Your Registration";

        String activationLink="http://localhost:8082/api/user/active/"+user.getId();

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
                + "      <p>Best regards,<br>Hotel Booking Management System</p>"
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


    // for User folder
    public String saveImage(MultipartFile file, User user) {

        Path uploadPath = Paths.get(uploadDir + "/users");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectory(uploadPath);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        String userName = user.getName();
        String fileName = userName.trim().replaceAll("\\s+", "_");

        String saveFileName = user.getName() + "_" + UUID.randomUUID().toString();


        try {
            Path filePath = uploadPath.resolve(saveFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return saveFileName;

    }


    // Start Customer


    public String saveImageForCustomer(MultipartFile file, Customer customer) {

        Path uploadPath = Paths.get(uploadDir + "/customer");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectory(uploadPath);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        String customerName = customer.getName();
        String fileName = customerName.trim().replaceAll("\\s+", "_");

        String savedFileName = fileName + "_" + UUID.randomUUID().toString();

        try {
            Path filePath = uploadPath.resolve(savedFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return savedFileName;

    }


    public void registerCustomer(User user, MultipartFile imageFile, Customer customerData) throws IOException {
        if (imageFile != null && !imageFile.isEmpty()) {
            // Save image for both User and JobSeeker
            String filename = saveImage(imageFile, user);
            String customerImage = saveImageForCustomer(imageFile, customerData);
            customerData.setImage(customerImage);
            user.setImage(filename);
        }

        // Encode password before saving User
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.CUSTOMER);
        user.setActive(false);

        // Save User FIRST and get persisted instance
        User savedUser = userRepository.save(user);

        // Now, associate saved User with JobSeeker and save JobSeeker
        customerData.setUser(savedUser);
        customerService.saveCustomer(customerData);

        // Now generate token and save Token associated with savedUser
        String jwt = jwtService.generateToken(savedUser);
        saveUserToken(jwt, savedUser);

        // Send Activation Email
        sendActivationEmail(savedUser);
    }

    // end customer


    // Hotel Admin Details Start



    public String saveImageForHotelAmin(MultipartFile file, HotelAdmin hotelAdmin) {

        Path uploadPath = Paths.get(uploadDir + "/hotelAdmin");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectory(uploadPath);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        String hotelAdminName = hotelAdmin.getName();
        String fileName = hotelAdminName.trim().replaceAll("\\s+", "_");

        String savedFileName = fileName + "_" + UUID.randomUUID().toString();

        try {
            Path filePath = uploadPath.resolve(savedFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return savedFileName;

    }

    public void registerHotelAdmin(User user, MultipartFile imageFile, HotelAdmin hotelAdminData) throws IOException {
        if (imageFile != null && !imageFile.isEmpty()) {
            // Save image for both User and HotelAdmin
            String filename = saveImage(imageFile, user);
            String hotelAdminImage = saveImageForHotelAmin(imageFile, hotelAdminData);
            hotelAdminData.setImage(hotelAdminImage);
            user.setImage(filename);
        }

        // Encode password before saving User
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.HOTEL_ADMIN);
        user.setActive(false);

        // Save User FIRST and get persisted instance
        User savedUser = userRepository.save(user);

        // Now, associate saved User with JobSeeker and save JobSeeker
        hotelAdminData.setUser(savedUser);
        hotelAminService.saveHotelAdmin(hotelAdminData);

        // Now generate token and save Token associated with savedUser
        String jwt = jwtService.generateToken(savedUser);
        saveUserToken(jwt, savedUser);

        // Send Activation Email
        sendActivationEmail(savedUser);
    }



                                             // Hotel Admin part End//




                                        // Super Admin Part start

    public String saveImageForAdmin(MultipartFile file, Admin admin) {

        Path uploadPath = Paths.get(uploadDir + "/Admins");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectory(uploadPath);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        String AdminName = admin.getName();
        String fileName = AdminName.trim().replaceAll("\\s+", "_");

        String savedFileName = fileName + "_" + UUID.randomUUID().toString();

        try {
            Path filePath = uploadPath.resolve(savedFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return savedFileName;

    }


    public void registerAdmin(User user, MultipartFile imageFile, Admin adminData) throws IOException {
        if (imageFile != null && !imageFile.isEmpty()) {
            // Save image for both User and HotelAdmin
            String filename = saveImage(imageFile, user);
            String adminImage = saveImageForAdmin(imageFile, adminData);
            adminData.setImage(adminImage);
            user.setImage(filename);
        }

        // Encode password before saving User
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.ADMIN);
        user.setActive(false);

        // Save User FIRST and get persisted instance
        User savedUser = userRepository.save(user);

        // Now, associate saved User with JobSeeker and save JobSeeker
        adminData.setUser(savedUser);
        adminService.saveAdmin(adminData);

        // Now generate token and save Token associated with savedUser
        String jwt = jwtService.generateToken(savedUser);
        saveUserToken(jwt, savedUser);

        // Send Activation Email
        sendActivationEmail(savedUser);
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
    public AuthenticationResponse authenticate(User request) {
        // Authenticate Username & Password
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        // Fetch User from DB
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // Check Activation Status
        if (!user.isActive()) {
            throw new RuntimeException("Account is not activated. Please check your email for activation link.");
        }

        // Generate JWT Token
        String jwt = jwtService.generateToken(user);

        // Remove Existing Tokens (Invalidate Old Sessions)
        removeAllTokenByUser(user);

        // Save New Token to DB (Optional if stateless)
        saveUserToken(jwt, user);

        // Return Authentication Response
        return new AuthenticationResponse(jwt, "User Login Successful");
    }


    public  String activeUser(int id){

        User user=userRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("User not Found with this ID "+id));

        if(user !=null){
            user.setActive(true);

            userRepository.save(user);
            return "User Activated Successfully!";

        }else {
            return  "Invalid Activation Token!";
        }

    }

}
