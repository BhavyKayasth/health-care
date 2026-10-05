import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/medicines_controller.dart';
import '../data/medicine_data.dart';

class MedicineCartSheet
    extends ConsumerWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineCartSheet({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // Read the latest state so cart
    // updates are reflected while this
    // bottom sheet is open.
    final currentState = ref.watch(
      medicinesControllerProvider,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              //------------------------------------------------
              // HEADER
              //------------------------------------------------

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Cart',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (currentState.cartItems
                  .isEmpty)
                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    vertical: 50,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons
                              .shopping_cart_outlined,
                          size: 65,
                          color:
                          Color(0xFFBFDBFE),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color:
                            Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                //------------------------------------------------
                // ITEMS
                //------------------------------------------------

                ...currentState.cartItems.map(
                      (item) {
                    final medicine =
                        item.key;
                    final quantity =
                        item.value;

                    return Container(
                      margin:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding:
                      const EdgeInsets.all(
                        12,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFFF0F7FF,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xFFFFE7D9,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                            child:
                            const Icon(
                              Icons
                                  .medication_rounded,
                              color:
                              Color(
                                0xFFEA580C,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  medicine.name,
                                  style:
                                  const TextStyle(
                                    color:
                                    Color(
                                      0xFF0F172A,
                                    ),
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(
                                  height: 3,
                                ),

                                Text(
                                  '₹${medicine.price.toStringAsFixed(0)} × $quantity',
                                  style:
                                  const TextStyle(
                                    color:
                                    Color(
                                      0xFF2563EB,
                                    ),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            '₹${(medicine.price * quantity).toStringAsFixed(0)}',
                            style:
                            const TextStyle(
                              color:
                              Color(
                                0xFF0F172A,
                              ),
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                //------------------------------------------------
                // TOTAL
                //------------------------------------------------

                Container(
                  padding:
                  const EdgeInsets.all(16),
                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      colors: [
                        Color(0xFFF0F7FF),
                        Color(0xFFE6FBFF),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style:
                            TextStyle(
                              color:
                              Color(
                                0xFF2563EB,
                              ),
                            ),
                          ),
                          Text(
                            '₹${currentState.cartTotal.toStringAsFixed(0)}',
                            style:
                            const TextStyle(
                              color:
                              Color(
                                0xFF0F172A,
                              ),
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: const [
                          Text(
                            'Delivery',
                            style: TextStyle(
                              color:
                              Color(
                                0xFF2563EB,
                              ),
                            ),
                          ),
                          Text(
                            'FREE',
                            style: TextStyle(
                              color:
                              Color(
                                0xFF16A34A,
                              ),
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const Divider(
                        height: 22,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style:
                            TextStyle(
                              color:
                              Color(
                                0xFF0F172A,
                              ),
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${currentState.cartTotal.toStringAsFixed(0)}',
                            style:
                            const TextStyle(
                              color:
                              Color(
                                0xFF0F172A,
                              ),
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //------------------------------------------------
                // PARTNER PLATFORMS
                //------------------------------------------------

                const Text(
                  'Buy Through Partner',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.7,
                  ),
                  itemCount:
                  medicinePartners.length,
                  itemBuilder:
                      (context, index) {
                    final partner =
                    medicinePartners[index];

                    final name =
                    partner['name']!;
                    final commission =
                    partner['commission']!;

                    final selected =
                        currentState
                            .selectedPlatform ==
                            name;

                    return InkWell(
                      onTap: () {
                        controller
                            .buyThroughPartner(
                          name,
                        );
                      },
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      child: Container(
                        padding:
                        const EdgeInsets.all(
                          12,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                          border: Border.all(
                            color: selected
                                ? const Color(
                              0xFF3B82F6,
                            )
                                : const Color(
                              0xFFE2E8F0,
                            ),
                            width:
                            selected ? 2 : 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color:
                              Color(
                                0x10000000,
                              ),
                              blurRadius: 8,
                              offset:
                              Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Text(
                              name,
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xFF0F172A,
                                ),
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              '$commission commission',
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xFF16A34A,
                                ),
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                if (currentState.selectedPlatform !=
                    null)
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(
                      12,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFFECFDF5,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      'Opening ${currentState.selectedPlatform}...',
                      textAlign:
                      TextAlign.center,
                      style:
                      const TextStyle(
                        color:
                        Color(
                          0xFF15803D,
                        ),
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}