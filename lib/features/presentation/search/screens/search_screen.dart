import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_empty_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../controller/search_provider.dart';
import '../widgets/search_input_field.dart';
import '../widgets/popular_searches.dart';
import '../widgets/search_results_grid.dart';
import '../widgets/shimmer/popular_searches_shimmer.dart';
import '../widgets/shimmer/search_results_shimmer.dart';
import '../widgets/shimmer/search_suggestions_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollControllerForSearchResults = ScrollController();
  bool _isSearchActive = false;
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();
    _scrollControllerForSearchResults.addListener(_searchScrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SearchProvider>(context, listen: false);
      provider.clearFilteredProducts();
      provider.fetchFilteredProducts(refresh: true, name: '');
      provider.fetchSearchSuggestions(''); // Fetch initial search suggestions
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollControllerForSearchResults.removeListener(_searchScrollListener);
    _scrollControllerForSearchResults.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _searchScrollListener() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (_scrollControllerForSearchResults.position.pixels >=
        _scrollControllerForSearchResults.position.maxScrollExtent - 200) {
      // TODO: Replace with actual provider field checks for pagination
      // if (searchProvider.hasMoreSearchResults && !searchProvider.isPaginatingSearchResults) {
      //   searchProvider.fetchFilteredProducts(name: _searchController.text, refresh: false);
      // }
    }
  }

  void _performSearch(String query) {
    setState(() {
      _isSearchActive = query.isNotEmpty;
    });

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (query.isNotEmpty) {
      if (_scrollControllerForSearchResults.hasClients) {
         _scrollControllerForSearchResults.jumpTo(0.0);
      }
      searchProvider.fetchFilteredProducts(refresh: true, name: query);
    } else {
      searchProvider.clearFilteredProducts();
      searchProvider.fetchFilteredProducts(refresh: true, name: '');
    }
  }

  void _debounceSearch(String query) {
    // Cancel previous timer if it's still active
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    
    // Set a new timer for 1 second
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _performSearch(query);
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearchActive = false;
    });
    
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppTheme.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        scrolledUnderElevation: 0,
        leading: const CustomBackButton(),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return Column(
            children: [
              FadeIn(
                duration: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: SearchInputField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _isSearchActive = value.isNotEmpty;
                          });
                          searchProvider.onSearchQueryChanged(value);
                          if (value.isEmpty) {
                            searchProvider.clearFilteredProducts();
                            searchProvider.fetchFilteredProducts(
                              refresh: true,
                              name: '',
                            );
                          } else {
                            // Use debounce for search while typing
                            _debounceSearch(value);
                          }
                        },
                        onSubmitted: (query) {
                          // Cancel any pending debounce timer
                          if (_debounceTimer?.isActive ?? false) {
                            _debounceTimer!.cancel();
                          }
                          // Immediately perform search on submit
                          _performSearch(query);
                        },
                        onClear: _clearSearch,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isSearchActive
                    ? _buildSearchResults(searchProvider)
                    : _buildInitialView(searchProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchProvider searchProvider) {
    final bool isLoadingInitially = searchProvider.filteredProductsState == LoadingState.loading &&
                                 searchProvider.filteredProducts.isEmpty;

    if (isLoadingInitially) {
      return const SearchResultsShimmer();
    }

    const String errorMessage = ""; // searchProvider.filteredProductsError;
    if (searchProvider.filteredProductsState == LoadingState.error && searchProvider.filteredProducts.isEmpty) {
        return Center(
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(errorMessage.isNotEmpty
                          ? errorMessage
                          : 'error_loading_products'.tr(context)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () => _performSearch(_searchController.text),
                          child: Text('retry'.tr(context)),
                      ),
                  ],
              ),
            ),
        );
    }

    if (searchProvider.filteredProducts.isEmpty) {
      return FadeIn(
        duration: const Duration(milliseconds: 400),
        child: const CustomEmptyWidget(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: SearchResultsGrid(
              searchQuery: _searchController.text,
              scrollController: _scrollControllerForSearchResults,
            ),
          ),
        ),
        // TODO: Uncomment and use your actual pagination loading state from SearchProvider
        // if (searchProvider.isPaginatingSearchResults ?? false) 
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 16.0),
        //     child: Text(
        //       'loading_more_products'.tr(context),
        //       style: context.titleSmall?.copyWith(color: AppTheme.accentColor),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildSearchSuggestionsWidget(SearchProvider searchProvider) {
    bool isLoadingSuggestions = searchProvider.suggestionState == LoadingState.loading; 
    
    if (isLoadingSuggestions) {
      return const SearchSuggestionsShimmer();
    }
    
    final suggestions = searchProvider.suggestions;

    if (suggestions.isEmpty && !isLoadingSuggestions) {
      return const SizedBox.shrink();
    }

    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'search_suggestions'.tr(context),
              style: context.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: suggestions.map((suggestion) { 
                return InkWell(
                  onTap: () {
                    _searchController.text = suggestion.query; 
                    _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _searchController.text.length),
                    );
                    _performSearch(suggestion.query); 
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                  child: Chip(
                    label: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         const Icon(Icons.refresh,color: AppTheme.primaryColor, size: 16),
                         const SizedBox(width: 4),
                         Text(suggestion.query,style: context.titleSmall),
                       ],
                     ),
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red, width: 0.002),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView(SearchProvider searchProvider) {
    final bool isLoadingPopular = 
        searchProvider.filteredProductsState == LoadingState.loading && searchProvider.filteredProducts.isEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchSuggestionsWidget(searchProvider),
          const SizedBox(height: 16),
          isLoadingPopular
              ? const PopularSearchesShimmer()
              : FadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: PopularSearches(
                    popularProducts: searchProvider.filteredProducts,
                  ),
                ),
          if (!isLoadingPopular && searchProvider.filteredProducts.isEmpty)
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: CustomEmptyWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
