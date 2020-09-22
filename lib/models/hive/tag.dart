import 'package:hive/hive.dart';
import 'package:string_similarity/string_similarity.dart';

part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag extends HiveObject {
  @HiveField(0)
  final String label;
  @HiveField(1)
  bool isVisitedByInfected = false;
  @HiveField(2)
  double similarity;

//  final String title;
//  final String subtitle;

  Tag(this.label) {
    similarity = 0.0;
  }

  String get similarityPercentage {
    return '(${(similarity * 100).round()}%)';
  }

  void updateSimilarity(String title, String subtitle) {
    double titleSimilarity = 0;
    double subTitleSimilarity = 0;
    titleSimilarity = checkTitle(title);
    subTitleSimilarity = findStringSimilarity(subtitle);

    similarity = titleSimilarity > subTitleSimilarity
        ? titleSimilarity
        : subTitleSimilarity;
  }

  double checkTitle(String title) {
    List<String> titleTokens = title.split('(');
    if (titleTokens.length == 0)
      return 0.0;
//    if (titleTokens[0].toLowerCase().contains(label.toLowerCase()))
//      return 1.0;
    else {
      List<String> tagTokens = label.split(' ');
      if (tagTokens.length > 1) {
        bool allMatch = true;
        for (String labelToken in tagTokens) {
          if (!titleTokens[0].contains(labelToken)) allMatch = false;
        }
        if (allMatch)
          return 1.0;
        else
          return findStringSimilarity(titleTokens[0]);
      }
      return 0.0;
    }
  }

  double findStringSimilarity(String titleToken) {
    double dice = StringSimilarity.compareTwoStrings(
        titleToken.toLowerCase(), label.toLowerCase());
    return dice;
  }

  @override
  Future<void> save() {
    // TODO: implement save
    return super.save();
  }
}
