package com.idoit.config;

import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.idoit.auth.CustomOAuth2UserService;

import jakarta.servlet.DispatcherType;

@Configuration
public class SecurityConfig {
    private final CustomOAuth2UserService customOAuth2UserService;

    public SecurityConfig(CustomOAuth2UserService customOAuth2UserService) {
        this.customOAuth2UserService = customOAuth2UserService;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        AuthenticationSuccessHandler successHandler = (request, response, authentication) -> {
            System.out.println("✅ LOGIN SUCCESS HANDLER HIT: " + authentication.getName());
            System.out.println("✅ AUTH = " + authentication.getAuthorities());

            boolean isAdmin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

            boolean isCompany = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_COMPANY"));

            boolean isUser = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));

            // ✅ 우선순위: ADMIN > COMPANY > USER
            if (isAdmin) {
                response.sendRedirect("/admin");
            } else if (isCompany) {
                response.sendRedirect("/company"); // CompanyController에서 /company -> /company/dashboard 로 redirect 해둔 상태 OK
            } else if (isUser) {
                response.sendRedirect("/"); 
            } else {
                // 혹시 모를 예외: 권한이 이상하면 메인으로
                response.sendRedirect("/");
            }
        };

        http
            .csrf(csrf -> csrf.disable())
            .cors(cors -> cors.disable())
            .authorizeHttpRequests(request -> request
                .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                .requestMatchers(PathRequest.toStaticResources().atCommonLocations()).permitAll()
                
                .requestMatchers(HttpMethod.GET, "/job_posting-img/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/upload/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                
                .requestMatchers(HttpMethod.POST, "/application/apply").hasRole("USER")
                
                // ===== 공고: 공개 영역 =====
                .requestMatchers(HttpMethod.GET, "/job_posting/list").permitAll()
                .requestMatchers(HttpMethod.GET, "/job_posting/detail/**").permitAll()

                // ===== 공고: 기업 전용 =====
                .requestMatchers(HttpMethod.GET,  "/job_posting/writeform").hasRole("COMPANY")
                .requestMatchers(HttpMethod.POST, "/job_posting/write").hasRole("COMPANY")
                .requestMatchers(HttpMethod.GET,  "/job_posting/updateform/**").hasRole("COMPANY")
                .requestMatchers(HttpMethod.POST, "/job_posting/update").hasRole("COMPANY")
                .requestMatchers(HttpMethod.POST, "/job_posting/delete/**").hasRole("COMPANY")

                // 주소 검색 팝업 허용
                .requestMatchers("/member/jusopopup").permitAll()
                .requestMatchers("/company/jusopopup").permitAll()

                // 공지 사용자 공개
                .requestMatchers("/notice/list", "/notice/detail").permitAll()

                // 이미지 업로드
                .requestMatchers("/upload/board-image").hasAnyRole("USER","ADMIN")
                .requestMatchers("/upload/notice-image").hasRole("ADMIN")

                .requestMatchers(HttpMethod.GET,  "/member/join").permitAll()
                .requestMatchers(HttpMethod.POST, "/member/join").permitAll()
                .requestMatchers(HttpMethod.GET,  "/company/join").permitAll()
                .requestMatchers(HttpMethod.POST, "/company/join").permitAll()

                .requestMatchers(
                    "/","/member/login","/member/join","/j_spring_security_check","/error",
                    "/css/**", "/js/**", "/images/**",
                    "/oauth2/**","/login/oauth2/**","/policy/**"
                ).permitAll()

                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/member/login")
                .loginProcessingUrl("/j_spring_security_check")
                .usernameParameter("j_username")
                .passwordParameter("j_password")
                .authenticationDetailsSource(request -> request.getParameter("loginType"))
                .successHandler(successHandler)
                .failureHandler((request, response, exception) -> {
                    Throwable t = exception;
                    while (t != null) {
                        if (t instanceof org.springframework.security.authentication.DisabledException) {
                            response.sendRedirect("/member/login?blocked=true");
                            return;
                        }
                        t = t.getCause();
                    }
                    response.sendRedirect("/member/login?error=true");
                })

                .permitAll()
            )
            .oauth2Login(oauth -> oauth
            	    .loginPage("/member/login")
            	    .successHandler(successHandler)
            	    .failureHandler((request, response, exception) -> {
            	        Throwable t = exception;
            	        while (t != null) {
            	            if (t instanceof org.springframework.security.authentication.DisabledException) {
            	                response.sendRedirect("/member/login?blocked=true");
            	                return;
            	            }
            	            t = t.getCause();
            	        }
            	        response.sendRedirect("/member/login?error=true");
            	    })

            	)

            .rememberMe(rm -> rm
            	    .key("idoit-remember-me-key")
            	    .rememberMeParameter("remember-me")
            	    .tokenValiditySeconds(60 * 60 * 24 * 14)
            	)
            .logout(logout -> logout
                .logoutSuccessUrl("/member/login")
            );

        return http.build();
    }
}
