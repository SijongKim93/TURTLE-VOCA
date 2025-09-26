//
//  AddVocaView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import SwiftUI
import ComposableArchitecture

struct AddVocaView: View {
    let store: StoreOf<AddVocaReducer>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                VStack(spacing: 0) {
                    headerSection
                    bodySection
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        WithPerceptionTracking {
            let bookCaseName = store.bookCaseName
            
            VStack(spacing: 16) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Text(bookCaseName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        store.send(.addWordButtonTapped)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(ThemeColor.mainCgColor))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                searchSection
            }
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        WithPerceptionTracking {
            let searchText = store.searchText
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("단어 검색", text: Binding(
                    get: { searchText },
                    set: { store.send(.searchTextChanged($0)) }
                ))
                .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        store.send(.searchTextChanged(""))
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Body Section
    private var bodySection: some View {
        WithPerceptionTracking {
            let isLoading = store.isLoading
            let filteredWords = store.filteredWords
            let isFiltering = store.isFiltering
            
            if isLoading {
                loadingView
            } else if filteredWords.isEmpty {
                emptyView
            } else {
                wordsListSection
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("단어를 불러오는 중...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        WithPerceptionTracking {
            let isFiltering = store.isFiltering
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: isFiltering ? "magnifyingglass" : "book.closed")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text(isFiltering ? "검색 결과가 없습니다" : "단어가 없습니다")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(isFiltering ? "다른 검색어를 시도해보세요" : "새로운 단어를 추가해보세요")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !isFiltering {
                    Button(action: {
                        store.send(.addWordButtonTapped)
                    }) {
                        Text("단어 추가하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(ThemeColor.mainCgColor))
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Words List Section
    private var wordsListSection: some View {
        WithPerceptionTracking {
            let filteredWords = store.filteredWords
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredWords, id: \.objectID) { word in
                        WordCardView(
                            word: word,
                            onTap: {
                                store.send(.wordSelected(word))
                            },
                            onDelete: {
                                store.send(.deleteWord(word))
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - Word Card View
struct WordCardView: View {
    let word: WordEntity
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(word.word ?? "")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(word.definition ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
                
                VStack(spacing: 8) {
                    if word.memory {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddVocaView(
        store: Store(initialState: AddVocaReducer.State()) {
            AddVocaReducer()
        }
    )
}
