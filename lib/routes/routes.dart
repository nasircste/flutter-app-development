import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_estate_flutter/screens/dashboards/financial_dashboard.dart';
import 'package:real_estate_flutter/screens/invoices/create_invoice_details.dart';
import 'package:real_estate_flutter/screens/orders/create_purchase_order_screen.dart';
import '../screens/auth/login_signup_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/complete_registration_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/set_password_screen.dart';
import '../screens/dashboards/ceo_dashboard.dart';
import '../screens/dashboards/admin_dashboard.dart';
import '../screens/dashboards/manager_dashboard.dart';
import '../screens/dashboards/agent_dashboard.dart';
import '../screens/dashboards/hr_dashboard.dart';
import '../screens/dashboards/employee_dashboard.dart';
import '../screens/units/building_info_screen.dart';
import '../screens/properties/property_details_screen.dart';
import '../screens/invoices/create_invoice_screen.dart';

/// GoRouter configuration for the application
/// Follows Nestlo pattern with /:role/dashboard routing and login as landing page
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Landing page - Login/Signup (Nestlo pattern)
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginSignupScreen(),
    ),

    // Login page alias
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginSignupScreen(),
    ),

    // OTP Verification
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        final mode = state.uri.queryParameters['mode'] ?? 'signup';
        return OTPVerificationScreen(phone: phone, mode: mode);
      },
    ),

    // Complete Registration
    GoRoute(
      path: '/complete-registration',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return CompleteRegistrationScreen(phone: phone);
      },
    ),

    // Forgot Password
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Reset Password
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        final otp = state.uri.queryParameters['otp'] ?? '';
        return ResetPasswordScreen(phone: phone, otp: otp);
      },
    ),

    // Set Password (invitation acceptance)
    GoRoute(
      path: '/auth/set-password',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return SetPasswordScreen(token: token);
      },
    ),

    // Role-based Dashboard routing (Nestlo pattern)
    GoRoute(
      path: '/:role/dashboard',
      builder: (context, state) {
        final role = state.pathParameters['role']!.toLowerCase();

        switch (role) {
          case 'ceo':
            return const CEODashboard();
          case 'admin':
            return const AdminDashboard();
          case 'manager':
            return const ManagerDashboard();
          case 'agent':
            return const AgentDashboard();
          case 'hr':
            return const HRDashboard();
          case 'employee':
            return const EmployeeDashboard();
          case 'customer':
            // TODO: Create CustomerDashboard screen
            return const Scaffold(
              body: Center(
                child: Text('Customer Dashboard - Coming Soon'),
              ),
            );
          default:
            // Invalid role - redirect to login
            return const Scaffold(
              body: Center(
                child: Text(
                  'Invalid role. Dashboard not found.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
        }
      },                    
    ),

    // Building/Unit Intake (CEO only) - Single route for entire flow
    GoRoute(
      path: '/:role/building/create',
      builder: (context, state) => const BuildingInfoScreen(),
    ),
    GoRoute(
      path: '/:role/invoice/create',
      builder: (context, state) =>CreateInvoiceScreen(),
    ),
    GoRoute(
      path: '/:role/purchase-order',
      builder: (context, state) =>CreatePurchaseOrderPage(),
    ),
     GoRoute(
      path: '/:role/financial',
      builder: (context, state) => FinancialDashboardPage(),
    ),
    GoRoute(
      path: '/:role/properties/:assetId',
      builder: (context, state) {
        final role = state.pathParameters['role']!.toLowerCase();
        final assetId = state.pathParameters['assetId'] ?? '';
        String? selectedUnitId;
        final extra = state.extra;
        if (extra is Map && extra['selectedUnitId'] != null) {
          selectedUnitId = extra['selectedUnitId'].toString();
        }
        return PropertyDetailsScreen(
          role: role,
          assetId: assetId,
          selectedUnitId: selectedUnitId,
        );
      },
    ),
  ],
);
