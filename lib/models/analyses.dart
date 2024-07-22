const money = {
  'ginekologiya': '25000',
  'akushersvto': '35000',
  'trimestr': '40000',
};

class Analyses {
  final String name;
  final String path;
  final DateTime registrDate;
  final String type;
  final int cost;

  Analyses({
    required this.cost,
    required this.type,
    required this.name,
    required this.path,
    required this.registrDate,
  });
}
