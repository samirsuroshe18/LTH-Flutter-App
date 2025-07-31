part of 'notice_bloc.dart';

@immutable
sealed class NoticeEvent {}

final class NoticeBoardCreateNotice extends NoticeEvent{
  final String title;
  final String description;
  final File? file;

  NoticeBoardCreateNotice({required this.title, required this.description, this.file});
}

final class NoticeBoardGetAllNotices extends NoticeEvent{
  final Map<String, dynamic> queryParams;

  NoticeBoardGetAllNotices({required this.queryParams});
}

final class NoticeBoardUpdateNotice extends NoticeEvent{
  final String id;
  final String title;
  final String description;
  final File? file;
  final String? image;

  NoticeBoardUpdateNotice({required this.id, required this.title, required this.description, this.file, this.image});
}

final class NoticeBoardDeleteNotice extends NoticeEvent{
  final String id;

  NoticeBoardDeleteNotice({required this.id});
}