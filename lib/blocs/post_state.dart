import 'package:frontend_task/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final int totalPosts;

  PostLoaded(this.posts, this.totalPosts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
