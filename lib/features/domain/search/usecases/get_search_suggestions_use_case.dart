import '../../../data/search/models/search_suggestion_model.dart';
import '../repositories/search_repository.dart';

class GetSearchSuggestionsUseCase {
  final SearchRepository searchRepository;

  GetSearchSuggestionsUseCase(this.searchRepository);

  Future<List<SearchSuggestion>> call(String query) async {
    return await searchRepository.getSearchSuggestions(query);
  }
}