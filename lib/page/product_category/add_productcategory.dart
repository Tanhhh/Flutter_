import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/repositories/product_category/product_category.dart';

class AddProductCategoryPage extends StatefulWidget {
  @override
  _AddProductCategoryPageState createState() => _AddProductCategoryPageState();
}

class _AddProductCategoryPageState extends State<AddProductCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();
  final ProductCategoryRepository _categoryRepository =
      ProductCategoryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _createdByController,
              decoration: InputDecoration(labelText: 'Created By'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addProductCategory,
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

  void _addProductCategory() {
    final name = _nameController.text.trim();
    final createdBy = _createdByController.text.trim();
    final currentDate = DateTime.now();

    if (name.isNotEmpty && createdBy.isNotEmpty) {
      final category = ProductCategory(
        name: name,
        isActive: true,
        createdBy: createdBy,
        createDate: currentDate,
        updatedDate: currentDate,
        updatedBy: createdBy,
      );

      _categoryRepository.addCategory(category).then((docRef) {
        // Cập nhật ProductCategoryId với document ID mới
        setState(() {
          category.productCategoryId = docRef.id;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product category added successfully!'),
          duration: Duration(seconds: 2),
        ));
        // Navigate back to previous screen or perform any other action
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add product category: $error'),
          duration: Duration(seconds: 2),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter name and created by.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
