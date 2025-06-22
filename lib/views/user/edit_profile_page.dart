import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import './../../models/models.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final UserController userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = MaskedTextController(
    mask: '(00)00000-0000',
    text: '41999999999',
  );
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final usuario = userController.user.value;

    _usernameController.text = usuario?.username ?? '';
    _emailController.text = usuario?.email ?? '';
    _firstnameController.text = usuario?.name.firstname ?? '';
    _lastnameController.text = usuario?.name.lastname ?? '';
    _phoneController.text = usuario?.phone ?? '';

    _cityController.text = usuario?.address.city ?? '';
    _streetController.text = usuario?.address.street ?? '';
    _numberController.text = usuario?.address.number.toString() ?? '';
    _zipcodeController.text = usuario?.address.zipcode ?? '';
    _latController.text = usuario?.address.geolocation.lat ?? '';
    _longController.text = usuario?.address.geolocation.long ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipcodeController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, Widget icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      prefixIcon: icon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      hintStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          elevation: 2,
          backgroundColor: const Color.fromARGB(255, 15, 3, 88),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Perfil', icon: Icon(Icons.person)),
              Tab(text: 'Endereço', icon: Icon(Icons.location_on)),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [_buildProfileTab(), _buildAddressTab()],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'Salvar Alterações',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 15, 3, 88),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: _saveProfile,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Informações Pessoais',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _firstnameController,
          decoration: _inputDecoration(
            'Primeiro Nome',
            const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe seu primeiro nome';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _lastnameController,
          decoration: _inputDecoration(
            'Sobrenome',
            const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe seu sobrenome';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration(
            'Telefone',
            const Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe seu telefone';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Informações da Conta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _usernameController,
          decoration: _inputDecoration(
            'Username',
            const Icon(Icons.account_circle_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o nome de usuário';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _emailController,
          decoration: _inputDecoration(
            'Email',
            const Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o e-mail';
            }
            if (!GetUtils.isEmail(value.trim())) {
              return 'E-mail inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAddressTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Endereço',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _cityController,
          decoration: _inputDecoration(
            'Cidade',
            const Icon(Icons.location_city),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a cidade';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _streetController,
          decoration: _inputDecoration('Rua', const Icon(Icons.streetview)),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a rua';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _numberController,
          decoration: _inputDecoration('Número', const Icon(Icons.numbers)),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o número';
            }
            if (int.tryParse(value.trim()) == null) {
              return 'Número inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _zipcodeController,
          decoration: _inputDecoration(
            'CEP',
            const Icon(Icons.local_post_office),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o CEP';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Geolocalização',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _latController,
          decoration: _inputDecoration(
            'Latitude',
            const Icon(Icons.my_location),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a latitude';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: _longController,
          decoration: _inputDecoration(
            'Longitude',
            const Icon(Icons.my_location),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a longitude';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      // Formulário inválido
      return;
    }

    final updatedUser = userController.user.value!.copyWith(
      username: _usernameController.text.trim(),
      password: userController.user.value!.password, // Mantém a senha atual
      email: _emailController.text.trim(),
      name: NameModel(
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
      ),
      phone: _phoneController.text.trim(),
      address: AddressModel(
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        number: int.tryParse(_numberController.text.trim()) ?? 0,
        zipcode: _zipcodeController.text.trim(),
        geolocation: GeolocationModel(
          lat: _latController.text.trim(),
          long: _longController.text.trim(),
        ),
      ),
    );

    final success = await userController.updateUserReturningSuccess(
      updatedUser,
    );

    if (success) {
      Get.snackbar(
        'Perfil Atualizado',
        'Suas informações foram atualizadas com sucesso!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      await Future.delayed(const Duration(seconds: 1));
      Get.until((route) => Get.currentRoute == '/');
    } else {
      Get.snackbar(
        'Erro',
        userController.erro.value.isNotEmpty
            ? userController.erro.value
            : 'Falha ao atualizar perfil.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
