// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uip_tv/provider/api_provider.dart';
// import 'package:uip_tv/provider/local_store_provider.dart';


// class MovieDetailsScreen extends StatefulWidget {
//   final int movieId;

//   const MovieDetailsScreen({
//     Key? key,
//     required this.movieId,
//   }) : super(key: key);

//   @override
//   State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
// }

// class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch movie details when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final apiProvider = Provider.of<ApiDataProvider>(context, listen: false);
//       final localStore = Provider.of<LocalStoreProvider>(context, listen: false);
//       apiProvider.fetchMovieWithCast(widget.movieId, context, localStore);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Movie Details'),
//       ),
//       body: Consumer<ApiDataProvider>(
//         builder: (context, provider, child) {
//           if (provider.issDetailsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (provider.errorsDetailsMessage != null) {
//             return Center(child: Text(provider.errorsDetailsMessage!));
//           } else if (provider.movieDetails != null) {
//             final movie = provider.movieDetails!;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Movie poster - use local image if available
//                   if (movie.localPosterPath != null)
//                     Image.file(
//                       File(movie.localPosterPath!),
//                       height: 300,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     )
//                   else if (movie.posterPath.isNotEmpty)
//                     Image.network(
//                       'https://image.tmdb.org/t/p/w500${movie.posterPath}',
//                       height: 300,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     )
//                   else 
//                     Container(
//                       height: 300,
//                       width: double.infinity,
//                       color: Colors.grey,
//                       child: const Icon(Icons.movie, size: 100),
//                     ),
//                   const SizedBox(height: 16),
                  
//                   // Movie title
//                   Text(
//                     movie.originalTitle,
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
                  
//                   // Tagline
//                   if (movie.tagline.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     Text(
//                       movie.tagline,
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
                  
//                   // Release date and runtime
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text('Release: ${movie.releaseDate}'),
//                       const SizedBox(width: 16),
//                       Text('Runtime: ${movie.runtime} min'),
//                     ],
//                   ),
                  
//                   // Overview
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Overview',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(movie.overview),
                  
//                   // Cast
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Cast',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Cast list
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: movie.cast.length,
//                       itemBuilder: (context, index) {
//                         final castMember = movie.cast[index];
//                         return Container(
//                           width: 100,
//                           margin: const EdgeInsets.only(right: 12),
//                           child: Column(
//                             children: [
//                               // Cast profile image - use local image if available
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: castMember.localProfilePath != null
//                                     ? Image.file(
//                                         File(castMember.localProfilePath!),
//                                         height: 80,
//                                         width: 80,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : castMember.profilePath.isNotEmpty
//                                         ? Image.network(
//                                             'https://image.tmdb.org/t/p/w200${castMember.profilePath}',
//                                             height: 80,
//                                             width: 80,
//                                             fit: BoxFit.cover,
//                                           )
//                                         : Container(
//                                             height: 80,
//                                             width: 80,
//                                             color: Colors.grey[300],
//                                             child: const Icon(Icons.person),
//                                           ),
//                               ),
//                               const SizedBox(height: 4),
//                               // Cast name
//                               Text(
//                                 castMember.originalName,
//                                 style: const TextStyle(fontSize: 12),
//                                 maxLines: 2,
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
// }