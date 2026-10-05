import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../controller/medicines_controller.dart';
import '../model/medicine_model.dart';

class MedicineCard extends ConsumerWidget {
  final MedicineModel medicine;

  const MedicineCard({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
    ref.watch(medicinesControllerProvider);

    final controller =
    ref.read(
      medicinesControllerProvider.notifier,
    );

    final quantity =
        state.cart[medicine.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              gradient:
              const LinearGradient(
                colors: [
                  Color(0xFFFFE4E6),
                  Color(0xFFFFE7E0),
                ],
              ),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 38,
              color: Color(0xFFEA580C),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        medicine.name,
                        style: const TextStyle(
                          color:
                          AppColors.darkText,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    if (medicine.prescription)
                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xFFFEE2E2,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: const Text(
                          'Rx',
                          style: TextStyle(
                            color:
                            Color(0xFFDC2626),
                            fontSize: 10,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  medicine.manufacturer,
                  style: const TextStyle(
                    color:
                    AppColors.greyText,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  medicine.description,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color:
                    AppColors.primary,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Text(
                      '₹${medicine.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color:
                        AppColors.darkText,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Text(
                      '₹${medicine.mrp.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color:
                        AppColors.greyText,
                        fontSize: 11,
                        decoration:
                        TextDecoration
                            .lineThrough,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Text(
                      '${medicine.discount}% OFF',
                      style:
                      const TextStyle(
                        color:
                        Color(0xFF16A34A),
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    if (quantity > 0)
                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xFFFFE7D9,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Row(
                          children: [
                            _CircleButton(
                              icon:
                              Icons.remove,
                              onTap: () =>
                                  controller
                                      .removeFromCart(
                                    medicine.id,
                                  ),
                            ),

                            SizedBox(
                              width: 28,
                              child: Text(
                                '$quantity',
                                textAlign:
                                TextAlign.center,
                                style:
                                const TextStyle(
                                  color:
                                  Color(
                                    0xFFEA580C,
                                  ),
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            _CircleButton(
                              icon:
                              Icons.add,
                              onTap: () =>
                                  controller
                                      .addToCart(
                                    medicine.id,
                                  ),
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: _ActionButton(
                          label: 'Add',
                          background:
                          const Color(
                            0xFFFFE7D9,
                          ),
                          foreground:
                          const Color(
                            0xFFEA580C,
                          ),
                          onTap: () =>
                              controller
                                  .addToCart(
                                medicine.id,
                              ),
                        ),
                      ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: _ActionButton(
                        label: 'Buy Now',
                        backgroundGradient:
                        const LinearGradient(
                          colors: [
                            Color(0xFFF97316),
                            Color(0xFFEF4444),
                          ],
                        ),
                        foreground:
                        Colors.white,
                        onTap: () =>
                            controller
                                .buyNow(
                              medicine,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: Color(0xFFEA580C),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color? background;
  final Gradient? backgroundGradient;
  final Color foreground;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.background,
    this.backgroundGradient,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
        BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          padding:
          const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: background,
            gradient: backgroundGradient,
            borderRadius:
            BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 11,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}