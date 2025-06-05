import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../core/network/network_bloc.dart';
import '../../domain/entities/cat.dart';
import '../bloc/cat_list/cat_list_bloc.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';
import '../widgets/cat_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/heart_counter.dart';
import 'liked_cats_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CatListPage extends StatefulWidget {
  const CatListPage({super.key});

  @override
  State<CatListPage> createState() => _CatListPageState();
}

class _CatListPageState extends State<CatListPage> {
  late final CardSwiperController _controller;

  @override
  void initState() {
    super.initState();
    _checkNetworkStatus();
    _controller = CardSwiperController();
  }

  void _checkNetworkStatus() {
    final networkBloc = context.read<NetworkBloc>();
    networkBloc.stream.distinct().listen((isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isConnected
              ? 'Back online'
              : 'No internet connection - using cached data'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
            BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
            )],
          ),
          child: Text(
            'PussyMatch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        actions: [
          BlocBuilder<NetworkBloc, bool>(
            builder: (context, isConnected) {
              return Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: isConnected ? Colors.green : Colors.red,
              );
            },
          ),
          SizedBox(width: 16),
          BlocBuilder<LikedCatsBloc, LikedCatsState>(
            builder: (context, state) {
              final likedCount = state is LikedCatsLoaded ? state.cats.length : 0;
              return Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<LikedCatsBloc>(context),
                          child: const LikedCatsPage(),
                        ),
                      ),
                    );
                  },
                  child: HeartCounter(likedCount: likedCount),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CatListBloc, CatListState>(
        listener: (context, state) {
          if (state is CatListError) {
            _showErrorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CatListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CatListLoaded) {
            return _buildCatSwiper(context, state.cats, state.currentIndex);
          } else if (state is CatListError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCatSwiper(BuildContext context, List<Cat> cats, int currentIndex) {
    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: _controller,
            cardsCount: cats.length,
            cardBuilder: (context, index, _, __) => CatCard(
              cat: cats[index],
              onTap: () => _showCatDetails(context, cats[index]),
            ),
            onSwipe: (prevIndex, currentIndex, direction) {
              if (direction == CardSwiperDirection.right) {
                context.read<LikedCatsBloc>().add(AddLikedCat(cat: cats[prevIndex]));
              }
              context.read<CatListBloc>().add(const CatSwiped());
              return true;
            },
          ),
        ),
        ActionButtons(
          controller: _controller,
          currentIndex: currentIndex,
          cats: cats,
        ),
      ],
    );
  }

  void _showCatDetails(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(cat.breed.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, cat),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: cat.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailCard('Description', cat.breed.description),
                  const SizedBox(height: 16),
                  _buildDetailCard('Temperament', cat.breed.temperament),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailCard(
                          'Life Span',
                          cat.breed.lifeSpan,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailCard(
                          'Origin',
                          cat.breed.origin,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryTag('Adaptability', cat.breed.adaptability),
                      _buildCategoryTag('Affection Level', cat.breed.affectionLevel),
                      _buildCategoryTag('Intelligence', cat.breed.intelligence),
                      _buildCategoryTag('Energy Level', cat.breed.energyLevel),
                      _buildCategoryTag('Health Issues', cat.breed.healthIssues),
                      _buildCategoryTag('Social Needs', cat.breed.socialNeeds),
                    ],
                  ),
                  if (cat.breed.wikipediaUrl.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(cat.breed.wikipediaUrl));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Open Wikipedia',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Cat cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Cat'),
        content: Text('Remove ${cat.breed.name} from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LikedCatsBloc>().add(RemoveLikedCat(catId: cat.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${cat.breed.name}'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      context.read<LikedCatsBloc>().add(AddLikedCat(cat: cat));
                    },
                  ),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category, int score) {
    final tag = _getTagForCategory(category, score);
    final color = _getColorForScore(score);
    final textColor = _getTextColorForScore(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$category: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Text(
            tag,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getTagForCategory(String category, int score) {
    switch (category) {
      case 'Adaptability':
        return ['★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'][score - 1];
      case 'Affection Level':
        return ['★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'][score - 1];
      case 'Intelligence':
        return ['★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'][score - 1];
      case 'Energy Level':
        return ['★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'][score - 1];
      case 'Health Issues':
        return ['★★★★★', '★★★★☆', '★★★☆☆', '★★☆☆☆', '★☆☆☆☆'][5 - score]; // Inverted
      case 'Social Needs':
        return ['★☆☆☆☆', '★★☆☆☆', '★★★☆☆', '★★★★☆', '★★★★★'][score - 1];
      default:
        return List.filled(score, '★').join() + List.filled(5 - score, '☆').join();
    }
  }
  Color _getColorForScore(int score) {
    switch (score) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColorForScore(int score) {
    switch (score) {
      case 1:
        return Colors.red[800]!;
      case 2:
        return Colors.orange[800]!;
      case 3:
        return Colors.yellow[900]!;
      case 4:
        return Colors.green[800]!;
      case 5:
        return Colors.green[900]!;
      default:
        return Colors.black;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
