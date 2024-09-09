import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_task/blocs/post_bloc.dart';
import 'package:frontend_task/blocs/post_event.dart';
import 'package:frontend_task/blocs/post_state.dart';

class PostTableScreen extends StatefulWidget {
  @override
  _PostTableScreenState createState() => _PostTableScreenState();
}

class _PostTableScreenState extends State<PostTableScreen> {
  int currentPage = 1;
  int postsPerPage = 5;
  final TextEditingController _controller = TextEditingController(text: "5");

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => PostBloc()..add(FetchPosts(currentPage, postsPerPage)),
      child: Scaffold(
        appBar: AppBar(title: Text("Posts Table")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("show"),
                  SizedBox(width: 10),
                  SizedBox(
                    height: height * 0.05,
                    width: width * 0.1,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onSubmitted: (value) {
                        int newValue = int.tryParse(value) ?? postsPerPage;
                        setState(() {
                          postsPerPage = newValue;
                          currentPage = 1;
                        });
                        context
                            .read<PostBloc>()
                            .add(FetchPosts(currentPage, postsPerPage));
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("entries"),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    int totalPages = (state.totalPosts / postsPerPage).ceil();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('TITLE')),
                                DataColumn(label: Text('BODY')),
                              ],
                              rows: state.posts.map((post) {
                                return DataRow(cells: [
                                  DataCell(Text(post.id.toString())),
                                  DataCell(Text(post.title)),
                                  DataCell(Text(post.body)),
                                ]);
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: width,
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: currentPage > 1
                                          ? () {
                                              setState(() {
                                                currentPage--;
                                              });
                                              context.read<PostBloc>().add(
                                                  FetchPosts(currentPage,
                                                      postsPerPage));
                                            }
                                          : null,
                                      child: Icon(Icons.arrow_back),
                                    ),
                                    ..._buildPageButtons(totalPages),
                                    TextButton(
                                      onPressed: currentPage < totalPages
                                          ? () {
                                              setState(() {
                                                currentPage++;
                                              });
                                              context.read<PostBloc>().add(
                                                  FetchPosts(currentPage,
                                                      postsPerPage));
                                            }
                                          : null,
                                      child: Icon(Icons.arrow_forward),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PostError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text("No data"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons(int totalPages) {
    List<Widget> pageButtons = [];

    int lastPage = totalPages;
    int secondLastPage = totalPages - 1;

    int startPage = currentPage;
    int endPage = currentPage + 1;

    if (endPage >= secondLastPage) {
      startPage = secondLastPage - 2;
      endPage = secondLastPage-1;
    }

    if (startPage < 1) {
      startPage = 1;
    }

    if(startPage > secondLastPage-3){
        pageButtons.add(Text("..."));
      }

    for (int i = startPage; i <= endPage; i++) {
      
      pageButtons.add(_buildPageButton(i));
    }

    
    if (endPage < secondLastPage) {
      if (endPage < secondLastPage - 1) {
        pageButtons.add(Text("..."));
      }
      pageButtons.add(_buildPageButton(secondLastPage));
      pageButtons.add(_buildPageButton(lastPage));
    }
    print('start page $startPage endPage $endPage lastPage $lastPage secondLastPage $secondLastPage');

    return pageButtons;
  }

  Widget _buildPageButton(int pageNumber) {
    return TextButton(
      onPressed: () {
        setState(() {
          currentPage = pageNumber;
        });
        context.read<PostBloc>().add(FetchPosts(currentPage, postsPerPage));
      },
      child: Text(
        pageNumber.toString(),
        style: TextStyle(
          fontWeight:
              currentPage == pageNumber ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
