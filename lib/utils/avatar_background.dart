String getRandomDefaultAvatar(String username) {
  final avatars = [
    'assets/images/male_avatar.svg',
    'assets/images/female_avatar.svg',
  ];

  final hash = username.codeUnits.fold(0, (sum, code) => sum + code);
  final index = hash % avatars.length;

  return avatars[index];
}
