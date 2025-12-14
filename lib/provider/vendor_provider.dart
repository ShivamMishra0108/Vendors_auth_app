import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/vendor.dart';

// StateNotifier is a class provided by riverpod that helps in managing the state:
class VendorProvider  extends StateNotifier<Vendor?> {
  VendorProvider(): super(null);

// Getter method to extract the value from the object
    Vendor? get vendor => state;

// Method to set the vendor user state form json
    void setVendor(String vendorjson){
      state = Vendor.fromJson(vendorjson);
    }

// Method to clear the vendor user state:
    void signOut(){
      state = null;
    }
}

// Provider Definition:

final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
return VendorProvider();
});