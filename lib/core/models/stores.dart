class Stores {
  final String id;
  final String? idd;
  final String nome;
  late final String logo;
  final int adesivos;
  final String address;
  final bool isopen;
  final bool isativo;
  final String? createdAt;
  final String? description;


  Stores({
    required this.id,
     this.idd,
    required this.nome,
    required this.logo,
    required this.adesivos,
    required this.address,
    required this.isopen,
    required this.isativo,
    this.createdAt,
    this.description,
  });
}
