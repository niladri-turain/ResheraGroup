import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../login/model/user_address_model.dart';
import '../../login/provider/user_address_provider.dart';
import '../../../core/constants/app_sizes.dart';

class AddressSelectionSheet extends StatelessWidget {
  final ShippingAddress? selectedAddress;
  final Function(ShippingAddress) onAddressSelected;

  const AddressSelectionSheet({
    super.key,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  String _formatAddress(ShippingAddress addr) {
    return addr.address ?? "";
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final addressProvider = context.watch<UserAddressProvider>();
    final addresses = addressProvider.addressModel?.data?.shipping ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(0.04),
        vertical: AppSize.height(0.02),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: AppSize.width(0.1),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: AppSize.height(0.02)),
          const Text(
            "Select Shipping Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSize.height(0.02)),
          if (addressProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (addresses.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.height(0.04)),
              child: const Center(child: Text("No shipping addresses found")),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final addr = addresses[index];
                  final isSelected = selectedAddress?.id == addr.id;

                  return GestureDetector(
                    onTap: () {
                      onAddressSelected(addr);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppSize.height(0.015)),
                      padding: EdgeInsets.all(AppSize.width(0.03)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey.shade200,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(0xFF7B2CBF).withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSize.width(0.02)),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4C4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              addr.type?.toLowerCase() == 'home' ? Icons.home_outlined : Icons.business_outlined,
                              color: const Color(0xFFD2691E),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: AppSize.width(0.03)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatAddress(addr),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Phone | ${addr.phone ?? ''}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
