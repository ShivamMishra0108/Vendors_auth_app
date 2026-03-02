import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vendor_app/controller/category_controller.dart';
import 'package:vendor_app/controller/subCategory_controller.dart';
import 'package:vendor_app/controller/product_controller.dart';
import 'package:vendor_app/models/category.dart';
import 'package:vendor_app/models/subCategory.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final ProductController productController = ProductController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String productName;
  late String description;
  late int price;
  late int quantity;

  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;

  Category? selectedCategory;
  Subcategory? selectedSubCategory;

  List<Uint8List> _images = [];

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true, // important for web
    );

    if (result != null && result.files.isNotEmpty) {
      List<Uint8List> pickedImages = [];
      for (var file in result.files) {
        if (file.bytes != null) {
          pickedImages.add(file.bytes!);
        }
      }

      if (pickedImages.isNotEmpty) {
        setState(() {
          _images = pickedImages;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No valid images selected")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE PICKER CONTAINER
            Center(
              child: Container(
                width: 150,
                height: 150,
                color: Colors.black,
                child: _images.isEmpty
                    ? Center(
                        child: Text(
                          "Pick Product Images",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GridView.builder(
                        itemCount: _images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return Image.memory(
                            _images[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: pickImages,
                child: Text("Select Images"),
              ),
            ),
            SizedBox(height: 20),

            // CATEGORY DROPDOWN
            FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final categories = snapshot.data!;
                return DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  hint: Text("Select Category"),
                  items: categories
                      .map(
                        (cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      selectedSubCategory = null;
                      futureSubcategories = SubcategoryController()
                          .getSubCategoryByCategory(value!.name);
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a category" : null,
                );
              },
            ),
            SizedBox(height: 10),

            // SUBCATEGORY DROPDOWN
            if (selectedCategory != null)
              FutureBuilder<List<Subcategory>>(
                future: futureSubcategories,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final subs = snapshot.data!;
                  if (subs.isEmpty) return Text("No subcategories found");

                  return DropdownButtonFormField<Subcategory>(
                    value: selectedSubCategory,
                    hint: Text("Select Subcategory"),
                    items: subs
                        .map(
                          (sub) => DropdownMenuItem(
                            value: sub,
                            child: Text(sub.subCategoryName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Please select a subcategory" : null,
                  );
                },
              ),

            SizedBox(height: 10),

            // PRODUCT DETAILS
            TextFormField(
              decoration: InputDecoration(labelText: "Product Name"),
              onChanged: (value) => productName = value,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter product name" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) => price = int.tryParse(value) ?? 0,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter price" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              onChanged: (value) => quantity = int.tryParse(value) ?? 0,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter quantity" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 3,
              onChanged: (value) => description = value,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter description" : null,
            ),
            SizedBox(height: 20),

            // SAVE BUTTON
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (_images.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Pick at least one image")),
                    );
                    return;
                  }

                  await productController.uploadProduct(
                    productName: productName,
                    productPrice: price,
                    quantity: quantity,
                    description: description,
                    category: selectedCategory!.name,
                    subCategory: selectedSubCategory!.subCategoryName,
                    vendorId: "yourVendorId",
                    fullName: "shivam",
                    pickedImages: _images,
                    context: context,
                  );

                  setState(() {
                    _images.clear();
                    _formKey.currentState!.reset();
                    selectedCategory = null;
                    selectedSubCategory = null;
                  });
                },
                child: Text("Save Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
