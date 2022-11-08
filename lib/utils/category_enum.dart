enum StreamingCategory {
  all(0, "전체", "assets/images/off-grid.svg"),
  defaultCategory(1, "기본", "assets/images/video-player.svg"),
  eating(2, "먹방", "assets/images/drink-tea.svg"),
  daily(3, "일상", "assets/images/rock-on.svg"),
  trip(4, "여행", "assets/images/air-balloon.svg"),
  movie(5, "영화", "assets/images/video-camera.svg"),
  music(6, "음악", "assets/images/cd-music.svg"),
  drinking(7, "술방", "assets/images/drink-cocktail.svg"),
  unboxing(8, "언박싱", "assets/images/diamond.svg"),
  study(9, "공부", "assets/images/ipad.svg"),
  shopping(10, "쇼핑", "assets/images/shopping-cart.svg"),
  etc(11, "기타", "assets/images/comment.svg");

  const StreamingCategory(this.id, this.name, this.iconFile);

  final int id;
  final String name;
  final String iconFile;

  static String getIconFileById(int id) {
    return StreamingCategory.values[id].iconFile;
  }
}
