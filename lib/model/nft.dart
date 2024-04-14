class NFT {
  final int id;
  final String name;
  final String description;
  final String imageURI;
  final String position;
  final String contract;

  
  NFT({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURI,
    required this.position,
    required this.contract,
  });
    
  factory NFT.fromJson(Map<String, dynamic> json) {
    

    return switch (json) {
      {
        
          'id': String id,
          'name': String name,
          'description': String description,
          'imageURI': String imageURI,
          'position': String position,
          'contract': String contract,
        
      } =>
        NFT(
          id: int.parse(id),
          name: name,
          description: description,
          imageURI: imageURI,
          position: position,
          contract: contract,
        ),
      _ => throw FormatException('Failed to load nft. $json'),
    };
  }
}

