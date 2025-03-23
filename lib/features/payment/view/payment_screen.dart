import 'package:flutter/material.dart';
import 'package:uip_tv/features/auth/widget/custom_button.dart';
import 'package:uip_tv/features/dashboard/dashboard.dart';
import 'package:uip_tv/features/dashboard/profile/view/profile_screen.dart';
import 'package:uip_tv/utils/bottom_sheet/bottom_sheet.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentOption = 0;
  bool isCardPayment = true;

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const BottomSuccessSheet(
          title: 'Payment Completed!',
          subtitle:
              'Thank you for starting our service. Hopefully you will have a great experince.',
          icon: Icons.lock,
          iconAssetPath: "assets/icons/tick_mark.png",
          iconBackgroundColor: AppPallete.backgroundColor,
          iconColor: Colors.white,
          buttonText: 'Completed',
          autoDismissSeconds: 3,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Sizer.deviceDefaultPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Sizer.inBetweenMaxDistance(context),
                ),
                Text(
                  "Set up Your Payment &\nBuy Subscription",
                  style: TextStyle(
                      fontSize: Sizer.headingText(context),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Sizer.inBetweenDistance(context)),
                Text(
                  "Starter Plan",
                  style: TextStyle(
                      fontSize: Sizer.normal2Text(context),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(height: Sizer.inBetweenDistance(context)),

                _buildPaymentOptionCard(
                    0, 'Pay Monthly', '.0/ Month/ Member', screenSize),
                SizedBox(height: screenSize.height * 0.01),
                _buildPaymentOptionCard(
                    1, 'Pay Monthly', '.0/ Month/ Member', screenSize),
                SizedBox(height: Sizer.inBetweenDistance(context)),

                // Billed to
                Text(
                  'Billed To',
                  style: TextStyle(
                      fontSize: Sizer.normal2Text(context),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Sizer.inBetweenDistance(context)),

                // Account name
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Tarikul Islam Shykat',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.person, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.inBetweenDistance(context)),

                Text(
                  'Payment Details',
                  style: TextStyle(
                      fontSize: Sizer.normal2Text(context),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(height: screenSize.height * 0.015),

                // Payment method options
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isCardPayment = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                          decoration: BoxDecoration(
                            color: isCardPayment
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFF121212),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCardPayment
                                  ? Colors.transparent
                                  : const Color(0xFF1E1E1E),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.credit_card,
                                size: isSmallScreen ? 24 : 30,
                                color: Colors.white,
                              ),
                              SizedBox(height: screenSize.height * 0.005),
                              Text(
                                'Pay by Card',
                                style: TextStyle(
                                    fontSize: Sizer.normal2Text(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isCardPayment = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                          decoration: BoxDecoration(
                            color: !isCardPayment
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFF121212),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !isCardPayment
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance,
                                size: isSmallScreen ? 24 : 30,
                                color: Colors.white,
                              ),
                              SizedBox(height: screenSize.height * 0.005),
                              Text(
                                'Bank Transfer',
                                style: TextStyle(
                                    fontSize: Sizer.normal2Text(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Card number field
                if (isCardPayment)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '1234 1234 1234 1234',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/icons/payment.png',
                          height: isSmallScreen ? 24 : 30,
                          width: isSmallScreen ? 40 : 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: isSmallScreen ? 24 : 30,
                              width: isSmallScreen ? 40 : 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Text(
                                  'MC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: screenSize.height * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Home',
                        onTap: () {
                          transition().navigateWithpushAndRemoveUntilTransition(
                              context, const MainScreen(),
                              transitionDirection: TransitionDirection.right);
                        },
                        isLoading: false,
                        backgroundColor: AppPallete.subtleColor2,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.03),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Subscribe',
                        onTap: () {
                          _showSuccessBottomSheet();
                        },
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard(
      int index, String title, String price, Size screenSize) {
    final isSmallScreen = screenSize.width < 400;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentOption = index;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedPaymentOption == index
                ? const Color(0xFFFF4D4D)
                : Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmallScreen ? 12 : 16,
        ),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 20 : 24,
              height: isSmallScreen ? 20 : 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedPaymentOption == index
                      ? const Color(0xFFFF4D4D)
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: selectedPaymentOption == index
                  ? Center(
                      child: Container(
                        width: isSmallScreen ? 12 : 14,
                        height: isSmallScreen ? 12 : 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: screenSize.width * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: Sizer.normal2Text(context),
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
