package com.example.HotelBookingManagementSystem.jwt;


import com.example.HotelBookingManagementSystem.service.UserService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    // Injecting JwtService to handle token operations (extract username, validate token)
    private final JwtService jwtService;

    // Injecting UserService to load user details from the database
    private final UserService userService;

    // Constructor-based Dependency Injection for JwtService and UserService
    public JwtAuthenticationFilter(JwtService jwtService, UserService userService) {
        this.jwtService = jwtService;
        this.userService = userService;
    }




    @Override
    protected void doFilterInternal(
            HttpServletRequest request,              // Incoming HTTP Request
            HttpServletResponse response,            // HTTP Response
            FilterChain filterChain                  // Chain of filters to execute
    ) throws ServletException, IOException {



        System.out.println("JwtAuthenticationFilter: Incoming request to " + request.getRequestURI());
        String authHeader = request.getHeader("Authorization");
        System.out.println("Authorization header: " + authHeader);

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            System.out.println("No JWT token found, skipping filter.");
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);
        String username = jwtService.extractUserName(token);
        System.out.println("Extracted Username from Token: " + username);

        // Proceed only if username is extracted and user is not already authenticated
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // Loading user details (from DB) using UserService based on extracted username
            UserDetails userDetails = userService.loadUserByUsername(username);

            boolean valid = jwtService.isValid(token, userDetails);
            System.out.println("Token validation result: " + valid);
            // Validating the token against the loaded user details
            if (jwtService.isValid(token, userDetails)) {

                // If token is valid, create an Authentication token (Spring Security standard)
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,                      // Principal (user details)
                        null,                             // Credentials (password) — null since already authenticated
                        userDetails.getAuthorities()      // User roles/authorities
                );

                // Building web authentication details (like remote IP, session ID) from the request
                authToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );

                // Setting the authentication object in Spring Security's SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }

        // Continue with the remaining filter chain (other filters, controllers, etc.)
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        System.out.println("Incoming Request Path: " + path);  // Add this log
        boolean skip = path.equals("/api/user/login") || path.equals("/images") || path.startsWith("/images/") || path.startsWith("/api/user/active/") || path.startsWith("/auth/login");
        System.out.println("Should Skip Filter: " + skip);  // Add this log
        return skip;
    }


//    @Override
//    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
//
//    }
}
