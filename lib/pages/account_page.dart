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
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final response = await authRepository.getUser();

    setState(() {
      _isLoading = false;
      _user = response["user"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(
                  child:
                      Text("Erreur lors de la récupération des informations."))
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
                              child: _user!.imageFileName != null &&
                                      _user!.imageRepository != null
                                  ? Image.network(
                                      Global.getImagePath(
                                          _user!.imageRepository!,
                                          _user!.imageFileName!),
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
                            '${_user!.firstname} ${_user!.lastname}',
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
                        _buildInfoRow('Téléphone', _user!.phone),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          'Date de naissance',
                          Global.formatDate(_user!.birthdate),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('Nom d’utilisateur', _user!.username),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          'Date d’inscription',
                          Global.formatDate(_user!.createdAt),
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
