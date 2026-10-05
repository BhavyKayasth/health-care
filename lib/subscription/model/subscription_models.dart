import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum SubscriptionPlan {
  monthly,
  yearly,
}

enum SubscriptionPaymentMethod {
  upi,
  qr,
  card,
  netbanking,
  wallet,
}

enum SubscriptionView {
  plans,
  payment,
  qr,
}

class SubscriptionPlanData {
  final SubscriptionPlan id;
  final String name;
  final String price;
  final String period;
  final String? savings;
  final List<String> features;
  final String badge;
  final List<Color> colors;

  const SubscriptionPlanData({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.savings,
    required this.features,
    required this.badge,
    required this.colors,
  });

  int get amount {
    return id == SubscriptionPlan.monthly
        ? 50
        : 500;
  }
}

class SubscriptionPaymentMethodData {
  final SubscriptionPaymentMethod id;
  final String name;
  final IconData icon;
  final String subtitle;
  final List<Color> colors;
  final bool popular;

  const SubscriptionPaymentMethodData({
    required this.id,
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.colors,
    required this.popular,
  });
}

class SubscriptionBenefitData {
  final IconData icon;
  final String title;
  final String description;

  const SubscriptionBenefitData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const subscriptionPlans = [
  SubscriptionPlanData(
    id: SubscriptionPlan.monthly,
    name: 'Monthly Plan',
    price: '₹50',
    period: '/month',
    savings: null,
    features: [
      'Access to 60+ verified doctors',
      'Emergency video consultations',
      '24/7 phone support',
      'Exclusive health tips',
      'No hidden charges',
    ],
    badge: 'Popular',
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF06B6D4),
    ],
  ),
  SubscriptionPlanData(
    id: SubscriptionPlan.yearly,
    name: 'Yearly Plan',
    price: '₹500',
    period: '/year',
    savings: 'Save ₹100',
    features: [
      'All Monthly Plan features',
      'Priority video consultations',
      'Free health checkup reminders',
      'Premium health reports',
      'Family sharing (up to 4)',
    ],
    badge: 'Best Value',
    colors: [
      Color(0xFFA855F7),
      Color(0xFFEC4899),
    ],
  ),
];

final subscriptionPaymentMethods = [
  const SubscriptionPaymentMethodData(
    id: SubscriptionPaymentMethod.upi,
    name: 'UPI Payment',
    icon: LucideIcons.smartphone,
    subtitle: 'Google Pay, PhonePe, Paytm',
    colors: [
      Color(0xFFA855F7),
      Color(0xFF9333EA),
    ],
    popular: true,
  ),
  const SubscriptionPaymentMethodData(
    id: SubscriptionPaymentMethod.qr,
    name: 'Scan QR Code',
    icon: LucideIcons.qrCode,
    subtitle: 'Scan & Pay via any UPI app',
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF06B6D4),
    ],
    popular: false,
  ),
  const SubscriptionPaymentMethodData(
    id: SubscriptionPaymentMethod.card,
    name: 'Debit/Credit Card',
    icon: LucideIcons.creditCard,
    subtitle: 'Visa, Mastercard, RuPay',
    colors: [
      Color(0xFF22C55E),
      Color(0xFF059669),
    ],
    popular: false,
  ),
  const SubscriptionPaymentMethodData(
    id: SubscriptionPaymentMethod.netbanking,
    name: 'Net Banking',
    icon: LucideIcons.building2,
    subtitle: 'All major banks supported',
    colors: [
      Color(0xFFF97316),
      Color(0xFFEF4444),
    ],
    popular: false,
  ),
  const SubscriptionPaymentMethodData(
    id: SubscriptionPaymentMethod.wallet,
    name: 'Digital Wallets',
    icon: LucideIcons.wallet,
    subtitle: 'Paytm, Mobikwik, Freecharge',
    colors: [
      Color(0xFFEC4899),
      Color(0xFFE11D48),
    ],
    popular: false,
  ),
];

const subscriptionBenefits = [
  SubscriptionBenefitData(
    icon: LucideIcons.phone,
    title: '60+ Doctors',
    description: 'Direct access to verified doctors',
  ),
  SubscriptionBenefitData(
    icon: LucideIcons.video,
    title: 'Video Calls',
    description: 'Emergency consultations anytime',
  ),
  SubscriptionBenefitData(
    icon: LucideIcons.clock3,
    title: '24/7 Support',
    description: 'Round the clock availability',
  ),
  SubscriptionBenefitData(
    icon: LucideIcons.shieldCheck,
    title: 'Secure & Safe',
    description: 'Your data is protected',
  ),
];