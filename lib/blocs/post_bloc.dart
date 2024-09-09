import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'post_event.dart';
import 'post_state.dart';
import '../../models/post_model.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List<Post> allPosts = (json.decode(response.body) as List).map((data) => Post.fromJson(data)).toList();
        int start = (event.page - 1) * event.postsPerPage;
        int end = start + event.postsPerPage;
        List<Post> paginatedPosts = allPosts.sublist(start, end > allPosts.length ? allPosts.length : end);
        emit(PostLoaded(paginatedPosts, allPosts.length));
      } else {
        emit(PostError("Failed to load posts"));
      }
    } catch (e) {
      emit(PostError("Failed to load posts"));
    }
  }
}
