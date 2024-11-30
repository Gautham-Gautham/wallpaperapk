class Photo {
  final String id;
  final String description;
  final String userName;
  final String regularUrl;
  final String fullUrl;
  final int width;
  final int height;
  final UnsplashUrls urls;
  final UnsplashUser user;

  Photo({
    required this.id,
    required this.description,
    required this.userName,
    required this.regularUrl,
    required this.fullUrl,
    required this.width,
    required this.height,
    required this.urls,
    required this.user,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      description: json['description'] ?? json['alt_description'] ?? '',
      userName: json['user']['username'],
      regularUrl: json['urls']['regular'],
      fullUrl: json['urls']['full'],
      width: json['width'],
      height: json['height'],
      urls: UnsplashUrls.fromJson(json['urls']),
      user: UnsplashUser.fromJson(json['user']),
    );
  }
}

class UnsplashUrls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  UnsplashUrls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });

  factory UnsplashUrls.fromJson(Map<String, dynamic> json) {
    return UnsplashUrls(
      raw: json['raw'],
      full: json['full'],
      regular: json['regular'],
      small: json['small'],
      thumb: json['thumb'],
    );
  }
}

class UnsplashUser {
  final String id;
  final String username;
  final String name;
  final UnsplashUserProfileImage profileImage;

  UnsplashUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profileImage,
  });

  factory UnsplashUser.fromJson(Map<String, dynamic> json) {
    return UnsplashUser(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      profileImage: UnsplashUserProfileImage.fromJson(json['profile_image']),
    );
  }
}

class UnsplashUserProfileImage {
  final String small;
  final String medium;
  final String large;

  UnsplashUserProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory UnsplashUserProfileImage.fromJson(Map<String, dynamic> json) {
    return UnsplashUserProfileImage(
      small: json['small'],
      medium: json['medium'],
      large: json['large'],
    );
  }
}
