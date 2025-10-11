package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.CustomerDTO;
import com.example.HotelBookingManagementSystem.dto.HotelAdminDTO;
import com.example.HotelBookingManagementSystem.entity.Customer;
import com.example.HotelBookingManagementSystem.entity.User;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import com.example.HotelBookingManagementSystem.service.AuthService;
import com.example.HotelBookingManagementSystem.service.CustomerService;
import com.example.HotelBookingManagementSystem.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/customer")
public class CustomerRestController {

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthService authService;


    @PostMapping("/reg")
    public ResponseEntity<Map<String, String>> registerCustomer(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "customer") String customerJson,
            @RequestParam(value = "image") MultipartFile file
    ) throws JsonProcessingException {

        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        Customer customer = objectMapper.readValue(customerJson, Customer.class);
        try {
            authService.registerCustomer(user, file, customer);
            Map<String, String> response = new HashMap<>();

            response.put("Message", "Customer registered successfully");

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {

            Map<String, String> errorResponse = new HashMap<>();

            errorResponse.put("Message", "Customer Registration Failed" + e);

            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);


        }


    }

    @GetMapping("/all")
    public ResponseEntity<List<CustomerDTO>> getAllCustomers() {
        List<CustomerDTO> customerList = customerService.getAllCustomers();
        return ResponseEntity.ok(customerList);
    }

//    @GetMapping("/profile")
//    public ResponseEntity<?> getProfile(Authentication authentication) {
//        System.out.println("Authenticated User: " + authentication.getName());
//        System.out.println("Authorities: " + authentication.getAuthorities());
//        String email = authentication.getName();
//        Optional<User> user =userRepository.findByEmail(email);
//        Customer customer = customerService.getProfileByUserId((long) user.get().getId());
//        return ResponseEntity.ok(customer);
//
//    }

    @GetMapping("/profile")
    public ResponseEntity<CustomerDTO> getProfile(Authentication authentication) {
        String email = authentication.getName(); // logged-in user's email
        CustomerDTO customerDTO = customerService.getProfile(email);
        return ResponseEntity.ok(customerDTO);
    }


    @GetMapping("/{id}")
    public ResponseEntity<CustomerDTO> findCustomerById(@PathVariable Integer id) {
        CustomerDTO dto = customerService.findCustomerById(id);
        return ResponseEntity.ok(dto);
    }
}
