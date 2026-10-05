import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';

import '../widgets/emergency_banner.dart';
import '../widgets/health_metrics.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_pharmacies.dart';
import '../widgets/quick_actions.dart';
import '../widgets/support_banner.dart';
import '../widgets/upcoming_appointments.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: const [
              //------------------------------------------------
              // HEADER
              //------------------------------------------------

              SliverToBoxAdapter(
                child: HomeHeader(),
              ),

              //------------------------------------------------
              // QUICK ACTIONS
              //------------------------------------------------

              SliverToBoxAdapter(
                child: QuickActions(),
              ),

              //------------------------------------------------
              // HEALTH METRICS
              //------------------------------------------------

              SliverToBoxAdapter(
                child: HealthMetrics(),
              ),

              //------------------------------------------------
              // NEARBY PHARMACIES
              //------------------------------------------------

              SliverToBoxAdapter(
                child: NearbyPharmacies(),
              ),

              //------------------------------------------------
              // EMERGENCY
              //------------------------------------------------

              SliverToBoxAdapter(
                child: EmergencyBanner(),
              ),

              //------------------------------------------------
              // SUPPORT
              //------------------------------------------------

              SliverToBoxAdapter(
                child: SupportBanner(),
              ),

              //------------------------------------------------
              // UPCOMING APPOINTMENTS
              //------------------------------------------------

              // SliverToBoxAdapter(
              //   child: UpcomingAppointments(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}