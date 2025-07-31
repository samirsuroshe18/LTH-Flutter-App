part of 'notice_bloc.dart';

@immutable
sealed class NoticeState{}

final class NoticeInitial extends NoticeState{}

/// Create notice
final class NoticeBoardCreateNoticeLoading extends NoticeState{}

final class NoticeBoardCreateNoticeSuccess extends NoticeState{
  final Notice response;
  NoticeBoardCreateNoticeSuccess({required this.response});
}

final class NoticeBoardCreateNoticeFailure extends NoticeState{
  final String message;
  final int? status;

  NoticeBoardCreateNoticeFailure( {required this.message, this.status});
}

/// get all notice
final class NoticeBoardGetAllNoticesLoading extends NoticeState{}

final class NoticeBoardGetAllNoticesSuccess extends NoticeState{
  final NoticeBoardModel response;
  NoticeBoardGetAllNoticesSuccess({required this.response});
}

final class NoticeBoardGetAllNoticesFailure extends NoticeState{
  final String message;
  final int? status;

  NoticeBoardGetAllNoticesFailure({required this.message, this.status});
}

/// Update notice
final class NoticeBoardUpdateNoticeLoading extends NoticeState{}

final class NoticeBoardUpdateNoticeSuccess extends NoticeState{
  final Notice response;
  NoticeBoardUpdateNoticeSuccess({required this.response});
}

final class NoticeBoardUpdateNoticeFailure extends NoticeState{
  final String message;
  final int? status;

  NoticeBoardUpdateNoticeFailure({required this.message, this.status});
}

/// delete notice
final class NoticeBoardDeleteNoticeLoading extends NoticeState{}

final class NoticeBoardDeleteNoticeSuccess extends NoticeState{
  final Notice response;
  NoticeBoardDeleteNoticeSuccess({required this.response});
}

final class NoticeBoardDeleteNoticeFailure extends NoticeState{
  final String message;
  final int? status;

  NoticeBoardDeleteNoticeFailure({required this.message, this.status});
}