//
//  BookCaseView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture

struct BookCaseView: View {
    let store: StoreOf<BookCaseReducer>
    
    var body: some View {
        WithPerceptionTracking {
            let isShowingaddBookCase = store.isShowingAddBookCase
            let isShowingEditBookCase = store.isShowingEditBookCase
            let selectedBookCase = store.selectedBookCase
            
            VStack(spacing: 0) {
                headerSection
                bodySection
            }
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(isPresented: Binding(
                get: { isShowingaddBookCase },
                set: { _ in store.send(.dismissAddBookCase) }
            )) {
                AddBookCaseView(store: store)
            }
            .sheet(isPresented: Binding(
                get: { isShowingEditBookCase },
                set: { _ in store.send(.dismissEditBookCase) }
            )) {
                if let selectedBookCase = selectedBookCase {
                    EditBookCaseView(store: store, bookCase: selectedBookCase)
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text("TurtleVoca")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            HStack {
                Text("단어장")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    store.send(.addBookCaseButtonTapped)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Body Section
    private var bodySection: some View {
        WithPerceptionTracking {
            if store.isLoading {
                loadingView
            } else if store.bookCases.isEmpty {
                emptyView
            } else {
                bookCaseGridView
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("단어장을 불러오는 중...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("단어장이 없습니다")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("새로운 단어장을 만들어보세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                store.send(.addBookCaseButtonTapped)
            }) {
                Text("단어장 만들기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - BookCase Grid View
    private var bookCaseGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(store.bookCases, id: \.objectID) { bookCase in
                    BookCaseCardView(
                        bookCase: bookCase,
                        onTap: {
                            store.send(.bookCaseSelected(bookCase))
                        },
                        onEdit: {
                            store.send(.editBookCaseButtonTapped(bookCase))
                        },
                        onDelete: {
                            store.send(.deleteBookCase(bookCase))
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    BookCaseView(
        store: Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
    )
}
