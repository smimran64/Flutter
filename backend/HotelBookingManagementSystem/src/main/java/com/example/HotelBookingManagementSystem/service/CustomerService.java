package com.example.HotelBookingManagementSystem.service;

import com.example.HotelBookingManagementSystem.dto.CustomerDTO;
import com.example.HotelBookingManagementSystem.dto.HotelAdminDTO;
import com.example.HotelBookingManagementSystem.entity.*;
import com.example.HotelBookingManagementSystem.jwt.JwtService;
import com.example.HotelBookingManagementSystem.repository.CustomerRepository;
import com.example.HotelBookingManagementSystem.repository.TokenRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class CustomerService {


    @Autowired
    private CustomerRepository customerRepository;

    public List<CustomerDTO> getAllCustomers() {
        List<Customer> customers = customerRepository.findAll();
        return customers.stream()
                .map(this::mapToDTO)
                .toList();
    }

    public Optional<Customer> getCustomerById(Long id) {
        return customerRepository.findById(id);
    }


    public Customer saveCustomer(Customer customer) {
        return customerRepository.save(customer);
    }

    public void deleteCustomer(Long id) {
        customerRepository.deleteById(id);
    }

//    public Customer getProfileByUserId(Long userId) {
//        return customerRepository.findByUserId(userId)
//                .orElseThrow(() -> new RuntimeException("Customer not found"));
//    }


    public CustomerDTO getProfile(String email) {
        Customer customer = customerRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Customer not found"));

        return mapToDTO(customer);
    }

    private CustomerDTO mapToDTO(Customer customer) {
        return new CustomerDTO(
                customer.getId(),
                customer.getName(),
                customer.getEmail(),
                customer.getPhone(),
                customer.getAddress(),
                customer.getGender(),
                customer.getDateOfBirth(),
                customer.getImage()
        );
    }

    public CustomerDTO findCustomerById(Integer id) {
        Customer customer = customerRepository.findCustomerByUser_Id(id);
        if (customer == null) {
            throw new EntityNotFoundException("Customer not found for user ID: " + id);
        }
        return mapToDTO(customer);
    }



}
