import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';

class MedicineCheckoutSheet
    extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineCheckoutSheet({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final medicine = state.buyNowItem;

    if (medicine == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height:
      MediaQuery.of(context).size.height * .88,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF0F7FF),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF97316),
                  Color(0xFFEF4444),
                ],
              ),
              borderRadius:
              BorderRadius.vertical(
                top: Radius.circular(34),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            state.checkoutStep ==
                                CheckoutStep.address
                                ? 'Delivery Details'
                                : 'Payment',
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 22,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            state.checkoutStep ==
                                CheckoutStep.address
                                ? 'Where should we deliver?'
                                : 'Choose payment method',
                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed:
                      controller.closeCheckout,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _ProgressStep(
                      number: 1,
                      title: 'Address',
                      active:
                      state.checkoutStep ==
                          CheckoutStep.address,
                      completed:
                      state.checkoutStep ==
                          CheckoutStep.payment,
                    ),

                    Expanded(
                      child: Container(
                        height: 3,
                        color: state.checkoutStep ==
                            CheckoutStep.payment
                            ? Colors.white
                            : Colors.white30,
                      ),
                    ),

                    _ProgressStep(
                      number: 2,
                      title: 'Payment',
                      active:
                      state.checkoutStep ==
                          CheckoutStep.payment,
                      completed: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          //--------------------------------------------------
          // CONTENT
          //--------------------------------------------------

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                120,
              ),
              child: Column(
                children: [
                  _ProductSummary(
                    medicine: medicine,
                  ),

                  const SizedBox(height: 16),

                  if (state.checkoutStep ==
                      CheckoutStep.address)
                    _AddressSection(
                      state: state,
                      controller: controller,
                    )
                  else
                    _PaymentSection(
                      state: state,
                      controller: controller,
                    ),
                ],
              ),
            ),
          ),

          //--------------------------------------------------
          // FOOTER
          //--------------------------------------------------

          Container(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                state.checkoutStep ==
                    CheckoutStep.address
                    ? () {
                  final success =
                  controller
                      .continueToPayment();

                  if (!success) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all address fields correctly.',
                        ),
                      ),
                    );
                  }
                }
                    : state.selectedPayment ==
                    null
                    ? null
                    : () {
                  final success =
                  controller
                      .placeOrder();

                  if (success) {
                    _showSuccessDialog(
                      context,
                    );
                  }
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  state.checkoutStep ==
                      CheckoutStep.address
                      ? const Color(
                    0xFFF97316,
                  )
                      : const Color(
                    0xFF16A34A,
                  ),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      state.checkoutStep ==
                          CheckoutStep.address
                          ? 'Continue to Payment'
                          : 'Pay ₹${medicine.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text('Order Placed'),
            ],
          ),
          content: const Text(
            'Your medicine order has been placed successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller
                    .closePlacedOrder();
              },
              child: const Text(
                'Done',
              ),
            ),
          ],
        );
      },
    );
  }
}

//============================================================
// PRODUCT SUMMARY
//============================================================

class _ProductSummary
    extends StatelessWidget {
  final dynamic medicine;

  const _ProductSummary({
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE4D6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
            BoxDecoration(
              color:
              const Color(0xFFFFE7D9),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 36,
              color: Color(0xFFEA580C),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF0F172A),
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  medicine.manufacturer,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF2563EB),
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      '₹${medicine.price.toStringAsFixed(0)}',
                      style:
                      const TextStyle(
                        color:
                        Color(0xFF0F172A),
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Text(
                      '₹${medicine.mrp.toStringAsFixed(0)}',
                      style:
                      const TextStyle(
                        color:
                        Color(0xFF94A3B8),
                        fontSize: 11,
                        decoration:
                        TextDecoration
                            .lineThrough,
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

//============================================================
// ADDRESS SECTION
//============================================================

class _AddressSection
    extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const _AddressSection({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final address = state.address;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.home_outlined,
                color: Color(0xFFEA580C),
              ),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _CheckoutField(
            label: 'Street Address',
            hint:
            'House no., Building name',
            value: address.street,
            onChanged:
            controller.updateStreet,
          ),

          _CheckoutField(
            label: 'Area / Locality',
            hint: 'Area, Locality',
            value: address.area,
            onChanged:
            controller.updateArea,
          ),

          Row(
            children: [
              Expanded(
                child: _CheckoutField(
                  label: 'City',
                  hint: 'City',
                  value: address.city,
                  onChanged:
                  controller.updateCity,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CheckoutField(
                  label: 'Pincode',
                  hint: 'Pincode',
                  value:
                  address.pincode,
                  keyboardType:
                  TextInputType.number,
                  onChanged:
                  controller
                      .updatePincode,
                ),
              ),
            ],
          ),

          _CheckoutField(
            label: 'Phone Number',
            hint: '10-digit mobile number',
            value: address.phone,
            keyboardType:
            TextInputType.phone,
            onChanged:
            controller.updatePhone,
          ),
        ],
      ),
    );
  }
}

//============================================================
// PAYMENT SECTION
//============================================================

class _PaymentSection
    extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const _PaymentSection({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const methods = [
      'Google Pay',
      'Paytm',
      'PhonePe',
    ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  color:
                  Color(0xFF0F172A),
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${state.address.street}\n'
                    '${state.address.area}, '
                    '${state.address.city} - '
                    '${state.address.pincode}\n'
                    '${state.address.phone}',
                style: const TextStyle(
                  color:
                  Color(0xFF2563EB),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment:
                Alignment.centerRight,
                child: TextButton(
                  onPressed:
                  controller.backToAddress,
                  child:
                  const Text('Change'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(
                  color:
                  Color(0xFF0F172A),
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              ...methods.map(
                    (method) {
                  final selected =
                      state.selectedPayment ==
                          method;

                  return GestureDetector(
                    onTap: () =>
                        controller
                            .selectPayment(
                          method,
                        ),
                    child: Container(
                      width: double.infinity,
                      margin:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding:
                      const EdgeInsets.all(
                        14,
                      ),
                      decoration:
                      BoxDecoration(
                        color: selected
                            ? const Color(
                          0xFFFFF7ED,
                        )
                            : Colors.white,
                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                        border: Border.all(
                          color: selected
                              ? const Color(
                            0xFFF97316,
                          )
                              : const Color(
                            0xFFE2E8F0,
                          ),
                          width:
                          selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xFFEFF6FF,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(
                                14,
                              ),
                            ),
                            child:
                            const Icon(
                              Icons.payment,
                              color:
                              Color(
                                0xFF2563EB,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Text(
                              method,
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xFF0F172A,
                                ),
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),

                          if (selected)
                            const Icon(
                              Icons
                                  .check_circle,
                              color:
                              Color(
                                0xFFF97316,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//============================================================
// CHECKOUT FIELD
//============================================================

class _CheckoutField
    extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  const _CheckoutField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1D4ED8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          TextFormField(
            initialValue: value,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration:
            InputDecoration(
              hintText: hint,
              filled: true,
              fillColor:
              const Color(0xFFF0F7FF),
              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
                borderSide: const BorderSide(
                  color: Color(0xFFDDEBFF),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
                borderSide: const BorderSide(
                  color: Color(0xFFDDEBFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//============================================================
// PROGRESS STEP
//============================================================

class _ProgressStep extends StatelessWidget {
  final int number;
  final String title;
  final bool active;
  final bool completed;

  const _ProgressStep({
    required this.number,
    required this.title,
    required this.active,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: active || completed
                ? Colors.white
                : Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: completed
                ? const Icon(
              Icons.check,
              size: 17,
              color: Color(
                0xFFEA580C,
              ),
            )
                : Text(
              '$number',
              style: TextStyle(
                color:
                active
                    ? const Color(
                  0xFFEA580C,
                )
                    : Colors.white,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 5),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}