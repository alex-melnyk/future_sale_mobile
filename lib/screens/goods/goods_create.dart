import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  final _priceController = TextEditingController();
  final _images = List<Asset>.generate(8, (index) => null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add new'),
      ),
      body: ScreenContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
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
        vertical: 8.0,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: imagesList,
      ),
    );
  }

  Widget _buildImagePreview(int index, Asset image) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      onTap: _handleAddImagePressed,
      splashColor: theme.primaryColor.withOpacity(0.25),
      highlightColor: theme.primaryColor.withOpacity(0.15),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(const Radius.circular(7.0)),
          ),
          child: FutureBuilder<ByteData>(
            future: image != null ? image.getByteData(quality: 25) : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Image(
                  image: MemoryImage(snapshot.data.buffer.asUint8List()),
                  fit: BoxFit.cover,
                );
              }

              return Center(
                child: index < 7
                    ? Icon(
                        MaterialCommunityIcons.image,
                        color: theme.primaryColor,
                      )
                    : Icon(
                        MaterialCommunityIcons.plus,
                        color: theme.primaryColor,
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
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              _titleController,
              label: 'Title',
              placeholder: 'Title of the product',
              maxLength: 100,
            ),
            _buildTextField(
              _descriptionController,
              label: 'Description',
              placeholder: 'Describe what you want to sell',
              maxLength: 500,
              maxLines: 5,
            ),
            _buildTextField(
              _priceController,
              label: 'Price',
              prefixText: '\$ ',
              placeholder: '199.99',
              maxLength: 7,
              textInputType: TextInputType.numberWithOptions(
                // signed: true,
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
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          hintText: placeholder,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: prefixText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: theme.primaryColor,
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.0,
              color: theme.primaryColor,
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          ),
        ),
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: textInputType,
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

  @override
  void dispose() {
    super.dispose();
  }
}
