

import 'package:shop/utils/utils.dart';

class Users {
  final String id;
  final String nome;
  final String role;
  final String email;

  Users({
    required this.id,
    required this.nome,
    required this.email,
    required this.role,

  });


  bool isAdmin() {
    return role != null && role.contains(Role.admin);
  }

  bool isGerente() {
    return role != null && role.contains(Role.gerente);
  }

  bool isCliente() {
    return role != null && role.contains(Role.cliente);
  }

}
