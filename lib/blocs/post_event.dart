abstract class PostEvent {}

class FetchPosts extends PostEvent {
  final int page;
  final int postsPerPage;

  FetchPosts(this.page, this.postsPerPage);
}
