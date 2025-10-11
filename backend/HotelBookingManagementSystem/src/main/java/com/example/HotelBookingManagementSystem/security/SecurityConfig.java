package com.example.HotelBookingManagementSystem.security;


import com.example.HotelBookingManagementSystem.jwt.JwtAuthenticationFilter;
import com.example.HotelBookingManagementSystem.jwt.JwtService;
import com.example.HotelBookingManagementSystem.service.UserService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           JwtAuthenticationFilter jwtAuthenticationFilter,
                                           UserService userService) throws Exception {

        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .authorizeHttpRequests(req -> req
                        .requestMatchers("/images/**",
                                "/images/gallery/**",
                                "/api/customer/**",
                                "/api/customer/",
                                "/api/hotelAdmin/**",
                                "/api/hotel/all",
                                "/api/login",
                                "/api/room/all",
                                "/api/room/**"
                                , "/api/active/**",
                                "/api/user/active/**",
                                "/api/hotel/searchByHotelAdminId",
                                "/api/admin/reg",
                                "/api/location/delete/**",
                                "/api/hoteladmin/reg",
                                "/api/admin/reg",
                                "/api/customer/reg",
                                "/api/user/all",
                                "/api/all",
                                "/api/users/**",
                                "/api/hotel/search",
                                "/api/hotel/{id}/rooms",
                                "/api/hotel/**",
                                "/api/room/hotell/**",
                                "/api/location/all",
                                "/api/amenities/all",
                                "/api/hotel/information/save",
                                "/api/room/hotell/**",
                                "/api/amenities/hotel/**",
                                "/api/hotel/information/hotel/**",
                                "/api/hotel/hotelbyhoteladmin/**",
                                "/api/hotelPhoto/**",
                                "/api/hotelPhoto/hotel/**",
                                "/api/me",
                                "/api/admin/all",
                                "/api/hoteladmin/all",
                                "/api/customer/all",
                                "/api/user/forgot-password",
                                "/api/user/reset-password",
                                "/api/admin/profile",
                                "/api/booking/hotel/**",
                                "/api/hoteladmin/**",
                                "/api/customer/**",
                                "/api/admin/**"




                        ).permitAll()

                        .requestMatchers("/api/hotel/save",
                                "/api/room/save",
                                "/api/amenities/save",
                                "/api/hotel/myHotels",
                                "/api/hotel/information/save",
                                "/api/admin/**",
                                "/api/hoteladmin/profile",
                                "/api/hotel/information/delete/**",
                                "/api/hotelPhoto/upload/**",
                                "/api/hotel/hotelbyhoteladmin/**"
                        ).hasRole("HOTEL_ADMIN")

                        .requestMatchers("/api/location/save"
                                ).hasRole("ADMIN")

                        .requestMatchers("/api/customer/profile",
                                "/api/booking/save"

                        ).hasRole("CUSTOMER")

                        .anyRequest().authenticated()
                )
                .userDetailsService(userService)
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(JwtService jwtService, UserService userService) {
        return new JwtAuthenticationFilter(jwtService, userService);
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:4200", "http://localhost:5001"));
        configuration.setAllowedMethods(List.of("GET", "POST", "DELETE", "PUT", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }



    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/images/**");
    }



}
