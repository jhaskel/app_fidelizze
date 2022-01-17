class CardList {
  final String id;
  final String store;
  final String code;
  final String createdAt;
  final String cliente;
  final String? nomeCliente;
  final int? quant;

  CardList({
    required this.id,
    required this.store,
    required this.code,
    required this.createdAt,
    required this.cliente,
    this.nomeCliente,
    this.quant,
  });

}
