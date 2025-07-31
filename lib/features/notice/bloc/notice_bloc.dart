import 'dart:io';

import 'package:complaint_portal/features/notice/models/notice_board_model.dart';
import 'package:complaint_portal/utils/api_error.dart';
import 'package:flutter/material.dart';
import 'package:complaint_portal/features/notice/repository/notice_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _noticeRepository;

  NoticeBloc({required NoticeRepository noticeRepository}): _noticeRepository = noticeRepository, super(NoticeInitial()){
    on<NoticeBoardCreateNotice>((event, emit) async {
      emit(NoticeBoardCreateNoticeLoading());
      try{

        final Notice response = await _noticeRepository.createNotice(title: event.title, description: event.description, file: event.file);
        emit(NoticeBoardCreateNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardCreateNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardCreateNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardGetAllNotices>((event, emit) async {
      emit(NoticeBoardGetAllNoticesLoading());
      try{
        final NoticeBoardModel response = await _noticeRepository.getAllNotices(queryParams: event.queryParams);
        emit(NoticeBoardGetAllNoticesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardGetAllNoticesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardGetAllNoticesFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardUpdateNotice>((event, emit) async {
      emit(NoticeBoardUpdateNoticeLoading());
      try{
        final Notice response = await _noticeRepository.updateNotice(id: event.id, title: event.title, description: event.description, file: event.file, image: event.image);
        emit(NoticeBoardUpdateNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardUpdateNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardUpdateNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardDeleteNotice>((event, emit) async {
      emit(NoticeBoardDeleteNoticeLoading());
      try{
        final Notice response = await _noticeRepository.deleteNotice(id: event.id);
        emit(NoticeBoardDeleteNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardDeleteNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardDeleteNoticeFailure(message: e.toString()));
        }
      }
    });
  }
}