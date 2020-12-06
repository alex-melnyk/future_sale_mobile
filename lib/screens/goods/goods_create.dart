import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/modals/modals.dart' show showCategoriesModal;
import 'package:future_sale/utils/palette.dart';
import 'package:future_sale/widgets/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class GoodsCreate extends StatefulWidget {
  @override
  _GoodsCreateState createState() => _GoodsCreateState();
}

class _GoodsCreateState extends State<GoodsCreate> {
  final _uuid = Uuid();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _images = List<Asset>.generate(8, (index) => null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add new'),
      ),
      body: ScreenContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImagesGrid(),
              _buildForm(),
              RaisedButton.icon(
                color: theme.primaryColor,
                textColor: Colors.white,
                onPressed: _handleUploadPressed,
                icon: Icon(MaterialCommunityIcons.shopping),
                label: Text('Place Good'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesGrid() {
    final imagesList = _images
        .asMap()
        .map((key, value) => MapEntry(key, _buildImagePreview(key, value)))
        .values
        .toList(growable: false);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      child: GridView.count(
        crossAxisCount: 3,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: imagesList,
      ),
    );
  }

  Widget _buildImagePreview(int index, Asset image) {
    final theme = Theme.of(context);

    final lastItem = index >= 7;

    return InkWell(
      borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      onTap: _handleAddImagePressed,
      splashColor: theme.primaryColor.withOpacity(0.25),
      highlightColor: theme.primaryColor.withOpacity(0.15),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: lastItem ? Colors.white : Palette.primaryColor,
            borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
              ),
            ],
          ),
          child: FutureBuilder<ByteData>(
            future: image != null ? image.getByteData(quality: 25) : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Image(
                  image: MemoryImage(snapshot.data.buffer.asUint8List()),
                  fit: BoxFit.cover,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Center(
                child: lastItem
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MaterialCommunityIcons.camera,
                            color: Palette.secondaryColor,
                            size: 48,
                          ),
                          Text(
                            'Add photos',
                            style: theme.textTheme.subtitle1.copyWith(
                              height: 1.5,
                              color: Palette.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '4 of 20',
                            style: theme.textTheme.subtitle2.copyWith(
                              height: 1.5,
                              color: Palette.primaryColor,
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        MaterialCommunityIcons.image,
                        color: Colors.white,
                        size: 64,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              _titleController,
              label: 'Title*',
              placeholder: 'E.g iPhone 8',
              maxLength: 100,
              maxLines: 1,
              helperText: 'Indicate brand, model',
            ),
            _buildTextField(
              _descriptionController,
              label: 'Description*',
              placeholder: 'Input text',
              maxLength: 500,
              maxLines: 5,
              helperText: 'Add product features',
            ),
            _buildTextField(
              _categoryController,
              disabled: true,
              label: 'Category*',
              suffixIcon: Icon(MaterialCommunityIcons.chevron_down),
              onPressed: _handleCategoriesPressed,
            ),
            _buildTextField(
              _priceController,
              label: 'Price',
              prefixText: '\$ ',
              placeholder: '199.99',
              textInputType: TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String label,
    String placeholder,
    int maxLength,
    int maxLines,
    TextInputType textInputType,
    String prefixText,
    String helperText,
    Widget suffixIcon,
    VoidCallback onPressed,
    bool disabled = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: InkWell(
        onTap: onPressed,
        child: TextField(
          enabled: !disabled,
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            helperText: helperText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixText: prefixText,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: Palette.primaryColor,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: Palette.primaryColor,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: Palette.secondaryColor,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
            ),
          ),
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: textInputType,
        ),
      ),
    );
  }

  void _handleAddImagePressed() async {
    final imagesList = await MultiImagePicker.pickImages(
      maxImages: 8,
      enableCamera: true,
    );

    setState(() {
      _images.setRange(0, imagesList.length, imagesList);
    });
  }

  void _handleUploadPressed() async {
    final preparedImages = _images.where((e) => e != null).map((e) {
      final uuid = _uuid.v4();
      final name = e.name;
      final fileName = '$uuid-$name';

      return <String, dynamic>{
        'asset': e,
        'name': fileName,
      };
    });

    final uploadFiles = preparedImages.map((e) {
      return Future(() async {
        final asset = e['asset'] as Asset;
        final fileName = e['name'] as String;
        final image = await asset.getByteData(quality: 50);

        try {
          await FirebaseStorage.instance.ref('/images/$fileName').putData(image.buffer.asUint8List());
        } on FirebaseException catch (e) {
          print(e);
        }

        return fileName;
      });
    });

    final fileNameList = await Future.wait(uploadFiles);

    final goods = FirebaseFirestore.instance.collection('goods');
    await goods.add(<String, dynamic>{
      'cost': double.tryParse(_priceController.text) ?? 0.0,
      'name': _titleController.text,
      'desciption': _descriptionController.text,
      'images': fileNameList,
    });

    Navigator.of(context).pop();
  }

  void _handleCategoriesPressed() async {
    final category = await showCategoriesModal(context);

    if (category != null) {
      setState(() {
        _categoryController.text = category;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
