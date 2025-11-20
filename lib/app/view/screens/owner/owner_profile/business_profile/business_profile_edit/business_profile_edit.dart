import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class BusinessProfileEdit extends StatefulWidget {
  final UserRole userRole;
  final OwnerProfileController controller;

  const BusinessProfileEdit(
      {super.key, required this.userRole, required this.controller});

  @override
  State<BusinessProfileEdit> createState() => _BusinessProfileEditState();
}

class _BusinessProfileEditState extends State<BusinessProfileEdit> {
  final List<dynamic> _shopImages = []; // Can be File or String (URL)
  dynamic? _shopLogo; // Can be File or String (URL)
  final List<dynamic> _shopVideos = []; // Can be File or String (URL)

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopBioController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = widget.controller.businessProfileData.value;
    if (data != null) {
      _shopNameController.text = data.shopName;
      _shopBioController.text = data.shopBio;
      _registrationNumberController.text = data.registrationNumber;
      _shopAddressController.text = data.shopAddress;
      _latitudeController.text = data.latitude.toString();
      _longitudeController.text = data.longitude.toString();
      // Add images: if starts with http, treat as URL, else as File
      _shopImages.addAll(data.shopImages
          .map((url) => url.startsWith('http') ? url : File(url)));
      _shopVideos.addAll(data.shopVideo
          .map((url) => url.startsWith('http') ? url : File(url)));
      _shopLogo = (data.shopLogo.isNotEmpty)
          ? (data.shopLogo.startsWith('http')
              ? data.shopLogo
              : File(data.shopLogo))
          : null;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        _shopImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _pickLogo() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _shopLogo = File(picked.path);
      });
    }
  }

  Future<void> _pickVideos() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: true);
    if (result != null) {
      setState(() {
        _shopVideos
            .addAll(result.paths.whereType<String>().map((p) => File(p)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _shopImages.removeAt(index);
    });
  }

  void _removeVideo(int index) {
    setState(() {
      _shopVideos.removeAt(index);
    });
  }

  void _removeLogo() {
    setState(() {
      _shopLogo = null;
    });
  }

  void _saveProfile() async {
    // You may want to add validation here
    widget.controller.shopName.text = _shopNameController.text;
    widget.controller.shopBio.text = _shopBioController.text;
    widget.controller.registrationNumber.text =
        _registrationNumberController.text;
    widget.controller.shopAddress.text = _shopAddressController.text;
    // Parse latitude and longitude safely
    double lat = double.tryParse(_latitudeController.text) ?? 0.0;
    double lng = double.tryParse(_longitudeController.text) ?? 0.0;
    widget.controller.latitude.value = lat;
    widget.controller.longitude.value = lng;
    widget.controller.shopImages.value =
        _shopImages.map((f) => f is File ? f.path : f).toList().cast<String>();
    widget.controller.shopVideo.value =
        _shopVideos.map((f) => f is File ? f.path : f).toList().cast<String>();
    widget.controller.shopLogo.value =
        _shopLogo is File ? _shopLogo.path : (_shopLogo ?? '');
    final bool result = await widget.controller.updateProfessionalProfile();
    if (mounted && result) context.pop();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopBioController.dispose();
    _registrationNumberController.dispose();
    _shopAddressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD0A3),
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Shop Edit Profile",
        iconData: Icons.arrow_back,
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC),
                Color(0xFFE9874E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Shop Pictures",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _shopImages.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      if (index < _shopImages.length) {
                        final img = _shopImages[index];
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: img is File
                                  ? Image.file(
                                      img,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: img,
                                      width: 80,
                                      height: 80,
                                    ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12,
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: buildAddTile(),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add logo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_shopLogo != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _shopLogo is File
                                ? Image.file(
                                    _shopLogo!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    _shopLogo!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _removeLogo,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 10,
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      GestureDetector(
                        onTap: _pickLogo,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Shop Name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _shopNameController,
                  decoration: inputDecoration(hintText: "Enter shop name"),
                ),
                const SizedBox(height: 20),
                const Text("Registration Number"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _registrationNumberController,
                  decoration:
                      inputDecoration(hintText: "Enter registration number"),
                ),
                const SizedBox(height: 20),
                const Text("Shop Address"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _shopAddressController,
                  decoration: inputDecoration(hintText: "Enter shop address"),
                ),
                const SizedBox(height: 20),
                const Text("Barber shop business bio"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _shopBioController,
                  maxLines: 4,
                  decoration:
                      inputDecoration(hintText: "Write your business bio"),
                ),
                // const SizedBox(height: 20),
                // const Text("Latitude"),
                // const SizedBox(height: 8),
                // TextFormField(
                //   controller: _latitudeController,
                //   keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                //   decoration: inputDecoration(hintText: "Enter latitude (e.g. 24.7136)"),
                // ),
                // const SizedBox(height: 20),
                // const Text("Longitude"),
                // const SizedBox(height: 8),
                // TextFormField(
                //   controller: _longitudeController,
                //   keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                //   decoration: inputDecoration(hintText: "Enter longitude (e.g. 46.6753)"),
                // ),
                const SizedBox(height: 20),
                const Text(
                  "Gallery (Videos)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _shopVideos.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      if (index < _shopVideos.length) {
                        return Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.videocam,
                                  size: 40, color: Colors.orange),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeVideo(index),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12,
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                        // Optionally, you can show a video thumbnail for local/remote videos here
                      } else {
                        return GestureDetector(
                          onTap: _pickVideos,
                          child: buildAddTile(icon: Icons.videocam),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: _saveProfile,
                  title: AppStrings.save,
                  fillColor: Colors.black,
                  textColor: Colors.white,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddTile({IconData icon = Icons.add}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.grey),
    );
  }

  InputDecoration inputDecoration({String hintText = ""}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
