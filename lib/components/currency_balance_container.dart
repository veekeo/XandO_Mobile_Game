import 'package:flutter/material.dart';

class CurrencyBalanceContainer extends StatelessWidget {
  const CurrencyBalanceContainer({super.key, required this.coin});

  final String coin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   showConversionsBottomSheet(context);
      // },
      child: Container(
        width: 125,
        height: 29,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 40, 73),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/naira_coin.png',
                width: 15,
                height: 15,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
              child: Text(
                coin,
                style: const TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const Icon(
            //   Icons.keyboard_arrow_down,
            // ),
          ],
        ),
      ),
    );
  }
}
