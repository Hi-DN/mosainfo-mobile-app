
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/streaming_provider.dart';
import 'package:mosainfo_mobile_app/utils/category_enum.dart';
import 'package:provider/provider.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int _selectedCategoryId = 0;

  @override
  Widget build(BuildContext context) {
    return _categoryList();
  }

  Widget _categoryList() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26)),
      ),
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemCount: StreamingCategory.values.length,
        itemBuilder: (context, index) {
          StreamingCategory category = StreamingCategory.values[index];

          return _categoryTile(category);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        }),
    );
  }
  

  Widget _categoryTile(StreamingCategory category) {
    bool isSelected = _selectedCategoryId == category.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;  
          Provider.of<StreamingProvider>(context, listen: false).setSelectedCategoryId(_selectedCategoryId);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSelected ? greyNavy : Colors.black26, width: 2.0),
                color: isSelected ? const Color.fromARGB(147, 127, 137, 170) : Colors.white
              ),
              child: SvgPicture.asset(
                category.iconFile,
                height: 26, width: 26),
            ),
            const SizedBox(height: 5),
            Text(category.name)
          ],
        ),
      ),
    );
  }
}