import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_library/core/network/network_api.dart';
import 'package:lb_library/core/storage/offline_pdf_storage.dart';
import 'package:lb_library/module/home/service/home_service.dart';
import 'package:lb_library/module/login/model/get_book_list.dart' as book_model;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<FetchBookList>((event, emit) async {
      emit(
        state.copyWith(
          status: BaseStatusEnum.inprogress,
          clearErrorMessage: true,
        ),
      );
      try {
        final response = await HomeService().getBookList();
        emit(
          state.copyWith(
            status: response.isEmpty
                ? BaseStatusEnum.noData
                : BaseStatusEnum.success,
            getBookList: response,
            clearErrorMessage: true,
          ),
        );
      } on NetworkException catch (error) {
        await _emitDownloadedBooksOrFailure(emit, error.message);
      } on FormatException catch (error) {
        await _emitDownloadedBooksOrFailure(
          emit,
          'Could not read the book list: ${error.message}',
        );
      } finally {
        event.completer?.complete();
      }
    });

    on<SearchBooksByName>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });

    on<FilterBooksByCategory>((event, emit) {
      emit(
        state.copyWith(
          selectedCategory: event.category,
          clearSelectedCategory: event.category == null,
        ),
      );
    });
  }

  Future<void> refreshBookList() {
    final completer = Completer<void>();
    add(FetchBookList(completer: completer));
    return completer.future;
  }

  Future<void> _emitDownloadedBooksOrFailure(
    Emitter<HomeState> emit,
    String errorMessage,
  ) async {
    try {
      final books = await OfflinePdfStorage.getDownloadedBooks();
      if (books.isNotEmpty) {
        emit(
          state.copyWith(
            status: BaseStatusEnum.success,
            getBookList: books,
            clearErrorMessage: true,
          ),
        );
        return;
      }
    } on PdfStorageException catch (error) {
      errorMessage = '$errorMessage ${error.message}';
    } on FormatException catch (error) {
      errorMessage = '$errorMessage Download data could not be read: $error';
    }

    emit(
      state.copyWith(
        status: BaseStatusEnum.failure,
        errorMessage: errorMessage,
      ),
    );
  }
}
