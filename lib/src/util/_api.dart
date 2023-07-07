class ApiHelper {
  String? key;
  int? maxResults;
  String? order;
  String? safeSearch;
  String? type;
  String? videoDuration;
  String? nextPageToken;
  String? prevPageToken;
  String? query;
  String? channelId;
  String? playlistId;
  Map<String, dynamic>? options;
  String? regionCode;
  static String baseURL = 'www.googleapis.com';

  ApiHelper({this.key, this.type, this.maxResults, this.query});

  Uri trendingUri({required String regionCode}) {
    this.regionCode = regionCode;
    final options = getTrendingOption(regionCode);
    Uri url = new Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

  Uri searchUri(
    String query, {
    String? type,
    String? regionCode,
    required String videoDuration,
    required String order,
  }) {
    this.query = query;
    this.type = type ?? this.type;
    this.channelId = null;
    final options = {
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}",
      "order": order,
      "videoDuration": videoDuration,
    };
    if (regionCode != null) options['regionCode'] = regionCode;
    print(options);
    Uri url = new Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri channelUri(String playlistId, String? order) {
    this.order = order ?? 'date';
    this.channelId = playlistId;
    final options = getChannelOption(playlistId, this.order!);
    Uri url = new Uri.https(baseURL, "youtube/v3/playlists", options);
    return url;
  }

  Uri playlistUri(String playlistId, String? order) {
    this.order = order ?? 'date';
    this.playlistId = playlistId;
    final options = getPlaylistOption(playlistId, this.order!);
    Uri url = new Uri.https(baseURL, "youtube/v3/playlistItems", options);
    return url;
  }

  Uri videoUri(List<String> videoId) {
    int length = videoId.length;
    String videoIds = videoId.join(',');
    var options = getVideoOption(videoIds, length);
    Uri url = new Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

//  For Getting Getting Next Page
  Uri nextPageUri(bool getTrending) {
    Uri url;
    if (getTrending) {
      var options = this.getTrendingPageOption("pageToken", nextPageToken!);
      url = new Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      var options = this.channelId == null
          ? getOptions("pageToken", nextPageToken!)
          : getChannelPageOption(channelId!, "pageToken", nextPageToken!);
      url = new Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

//  For Getting Getting Previous Page
  Uri prevPageUri(bool getTrending) {
    Uri url;
    if (getTrending) {
      var options = this.getTrendingPageOption("pageToken", prevPageToken!);
      url = new Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      final options = this.channelId == null
          ? getOptions("pageToken", prevPageToken!)
          : getChannelPageOption(channelId!, "pageToken", prevPageToken!);
      url = new Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

  Map<String, dynamic> getTrendingOption(String regionCode) {
    this.regionCode = regionCode;
    Map<String, dynamic> options = {
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "${this.maxResults}",
      "regionCode": "${this.regionCode}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getTrendingPageOption(String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "${this.maxResults}",
      "regionCode": "${this.regionCode}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getOptions(String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Map<String, dynamic> getOption() {
    Map<String, dynamic> options = {
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Map<String, dynamic> getChannelOption(String channelId, String order) {
    Map<String, dynamic> options = {
      'channelId': channelId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getChannelPageOption(
      String channelId, String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      'channelId': channelId,
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getPlaylistOption(String playlistId, String order) {
    Map<String, dynamic> options = {
      'playlistId': playlistId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getVideoOption(String videoIds, int length) {
    Map<String, dynamic> options = {
      "part": "contentDetails",
      "id": videoIds,
      "maxResults": "$length",
      "key": "${this.key}",
    };
    return options;
  }

  void setNextPageToken(String token) => this.nextPageToken = token;
  void setPrevPageToken(String token) => this.prevPageToken = token;
}
