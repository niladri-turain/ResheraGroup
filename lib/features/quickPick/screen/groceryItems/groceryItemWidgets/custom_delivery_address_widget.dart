import 'package:flutter/material.dart';
import 'package:resheragroup/core/service/location_service.dart';

class DeliverAddressWidget extends StatefulWidget {
  final String? address;

  const DeliverAddressWidget({
    super.key,
     this.address,
  });

  @override
  State<DeliverAddressWidget> createState() =>
      _DeliverAddressWidgetState();
}

class _DeliverAddressWidgetState
    extends State<DeliverAddressWidget> {
  late String _selectedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.address ?? "Select Address";
  }

  /// Opens Bottom Sheet
  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                /// Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),

                /// Title
                const Text(
                  "Select delivery location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                /// Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText:
                    "Search for area, street name...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Current Location
                ListTile(
                  leading: const Icon(
                    Icons.my_location,
                    color: Color(0xFF7e22ce),
                  ),
                  title: const Text(
                    "Use your current location",
                    style: TextStyle(
                      color: Color(0xFF7e22ce),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: _isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2),
                  )
                      : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () async {
                    // Close Bottom Sheet
                    Navigator.pop(context);

                    // Show loading in main widget
                    setState(() {
                      _isLoading = true;
                      _selectedAddress="Fetching location...";
                    });

                    try {
                      final String address =
                      await LocationService.getCurrentAddress();

                      if (!mounted) return;

                      setState(() {
                        _selectedAddress = address;
                        _isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to fetch location"),
                        ),
                      );
                    }
                  },
                ),

                /// Add New Address
                ListTile(
                  leading: const Icon(
                    Icons.add,
                    color: Color(0xFF7e22ce),
                  ),
                  title: const Text(
                    "Add new address",
                    style: TextStyle(
                      color: Color(0xFF7e22ce),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                /// Saved Addresses
                const Text(
                  "Your saved addresses",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),

                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.home,
                        color: Colors.orange),
                  ),
                  title: const Text(
                    "Floor 1st, Tiljala, Kolkata",
                  ),
                  onTap: () {
                    setState(() {
                      _selectedAddress =
                      "Tiljala, Kolkata";
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Back Button
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7e22ce),
          ),
          child: IconButton(

            icon: const Icon(Icons.arrow_back,
                color: Colors.white, size: 18,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 10),

        /// Address Section
        Expanded(
          child: GestureDetector(
            onTap: _openBottomSheet,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivering to",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedAddress,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7e22ce),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF7e22ce),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// Right Icons
        const Icon(Icons.search, color: Color(0xFF7e22ce)),
        const SizedBox(width: 10),
        const Icon(Icons.person_outline,
            color: Color(0xFF7e22ce)),
      ],
    );
  }
}