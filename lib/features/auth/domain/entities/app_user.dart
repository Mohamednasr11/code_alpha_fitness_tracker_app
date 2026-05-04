class AppUser {
  final String id;
  final String email;
  final String? displayImage;
  final String? photoUrl;
  final String? displayName;

  const AppUser({
    required this.id,
    required this.email,
    this.displayImage,
    this.displayName,
    this.photoUrl,
  });
}

class Products {
  final String id;
  final String title;
  final String image;

  const Products({
    required this.title,
    required this.id,
    required this.image
  });
}
