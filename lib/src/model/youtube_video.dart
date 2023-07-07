import 'package:youtube_api/src/model/thumbnails.dart';

class YouTubeVideo {
  late Thumbnails thumbnail;
  String? kind;
  String? id;
  String? publishedAt;
  String? channelId;
  String? channelUrl;
  late String title;
  String? description;
  late String channelTitle;
  late String url;
  String? duration;

  YouTubeVideo(dynamic data, {bool getTrendingVideo: false}) {
    thumbnail = Thumbnails.fromMap(data['snippet']['thumbnails']);

    var type = data['kind']?.substring(8) ?? 'channel';

    switch (type) {
      case 'channel':
        kind = data['id']['kind'].substring(8);
        id = data['id'][data['id'].keys.elementAt(1)];
        break;
      case 'video':
        kind = 'video';
        id = data['id'];
        break;
      case 'playlist':
      case 'playlistItem':
        kind = 'video';
        id = data['snippet']['resourceId']['videoId'];
        break;
    }

    if (getTrendingVideo) {
      kind = 'video';
      id = data['id'];
    }

    url = getURL(kind!, id!);
    publishedAt = data['snippet']['publishedAt'];
    channelId = data['snippet']['channelId'];
    channelUrl = "https://www.youtube.com/channel/$channelId";
    title = data['snippet']['title'];
    description = data['snippet']['description'];
    channelTitle = data['snippet']['channelTitle'];
  }

  String getURL(String kind, String id) {
    String baseURL = "https://www.youtube.com/";
    switch (kind) {
      case 'channel':
        return "${baseURL}channel/$id";
      case 'video':
        return "${baseURL}watch?v=$id";
      case 'playlist':
        return "${baseURL}playlist?list=$id";
    }
    return baseURL;
  }
}
