class Contract {
  final int id;
  final String address;
  final String owner;
  final String community;
  final String communitySymbol;
  final bool isPublic;
  final bool isOpen;
  final int h3Price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Contract({
    required this.id,
    required this.address,
    required this.owner,
    required this.community,
    required this.communitySymbol,
    required this.isPublic,
    required this.isOpen,
    required this.h3Price,
    required this.createdAt,
    required this.updatedAt,
  });
    
  factory Contract.fromJson(Map<String, dynamic> json) {
    

    return switch (json) {
      {
        'contract': {
          'id': String id,
          'address': String address,
          'owner': String owner,
          'community': String community,
          'communitySymbol': String communitySymbol,
          'isPublic': bool isPublic,
          'isOpen': bool isOpen,
          'h3Price': int h3Price,
          'createdAt': String createdAt,
          'updatedAt': String updatedAt,
        }
      } =>
        Contract(
          id: int.parse(id),
          address: address,
          owner: owner,
          community: community,
          communitySymbol: communitySymbol,
          isPublic: isPublic,
          isOpen: isOpen,
          h3Price: h3Price,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
        ),
      _ => throw FormatException('Failed to load contract. $json'),
    };
  }
}

