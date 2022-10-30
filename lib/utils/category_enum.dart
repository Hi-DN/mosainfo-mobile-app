enum StreamingCategory {
  defaultCategory(0, "기본", "assets/images/video-player.svg"),
  eating(1, "먹방", "assets/images/drink-tea.svg"),
  daily(2, "일상", "assets/images/rock-on.svg"),
  trip(3, "여행", "assets/images/air-balloon.svg"),
  movie(4, "영화", "assets/images/video-camera.svg"),
  music(5, "음악", "assets/images/cd-music.svg"),
  drinking(6, "술방", "assets/images/drink-cocktail.svg"),
  unboxing(7, "언박싱", "assets/images/diamond.svg"),
  study(8, "공부", "assets/images/ipad.svg"),
  shopping(9, "쇼핑", "assets/images/shopping-cart.svg"),
  etc(10, "기타", "assets/images/comment.svg");

  const StreamingCategory(this.id, this.name, this.iconFile);

  final int id;
  final String name;
  final String iconFile;

  static String getIconFileById(int id) {
    return StreamingCategory.values[id].iconFile;
  }
}
