import 'package:bubble_salmon/class/user.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/services/auth_service.dart';
import 'package:bubble_salmon/widget/bottom_bar.dart';
import 'package:bubble_salmon/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthRepository authRepository =
      AuthRepository(apiAuthService: ApiAuthService());
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    Map<String, dynamic> response = await authRepository.getUser();
    if (response["status"] == "success") {
      setState(() {
        user = User.fromJson(response["user"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32.0),
                  width: double.infinity,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: user!.imageFileName != null &&
                                  user!.imageRepository != null
                              ? Image.network(
                                  Global.getImagePath(user!.imageRepository!,
                                      user!.imageFileName!),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/img/placeholderColor.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user!.firstname} ${user!.lastname}',
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Téléphone', user!.phone),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Date de naissance',
                      Global.formatDate(user!.birthdate),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Nom d’utilisateur', user!.username),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Date d’inscription',
                      Global.formatDate(user!.createdAt),
                    ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: BottomBar(currentIndex: 2, context: context),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: RichText(
        text: TextSpan(
          text: '$label : ',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
