class NFT {
  final int id;
  final String name;
  final String description;
  final String imageURI;
  final String position;
  final String contract;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  NFT({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURI,
    required this.position,
    required this.contract,
    required this.createdAt,
    required this.updatedAt,
  });
    
  factory NFT.fromJson(Map<String, dynamic> json) {
    

    return switch (json) {
      {
        'contract': {
          'id': String id,
          'name': String name,
          'description': String description,
          'imageURI': String imageURI,
          'position': String position,
          'contract': String contract,
          'createdAt': String createdAt,
          'updatedAt': String updatedAt,
        }
      } =>
        NFT(
          id: int.parse(id),
          name: name,
          description: description,
          imageURI: imageURI,
          position: position,
          contract: contract,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
        ),
      _ => throw FormatException('Failed to load nft. $json'),
    };
  }
}

