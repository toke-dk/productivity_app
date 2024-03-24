import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../models/donation.dart';

class SupportBanner extends StatelessWidget {
  const SupportBanner({super.key, required this.donation});

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  spreadRadius: 1,
                  blurRadius: 3)
            ], borderRadius: BorderRadius.circular(5), color: Colors.white),
            padding:
            const EdgeInsets.only(top: 6, left: 50, bottom: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              donation.name.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1),
                            ),
                          ),
                          Gap(7),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 15,
                          ),
                          Gap(12),
                        ],
                      ),
                      donation.message == null
                          ? SizedBox.shrink()
                          : Container(
                        padding: EdgeInsets.only(right: 7),
                        child: Text(
                          donation.message!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primary),
                      child: FittedBox(
                        child: Text(
                          '${donation.valueInKr.toString().replaceAll(".", ",")} kr.',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(donation.dateAdded),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(left: 0, top: 0, bottom: 0, child: donation.earnedMedal),
      ],
    );
  }
}
