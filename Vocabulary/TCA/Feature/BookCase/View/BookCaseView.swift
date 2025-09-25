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
            
            ZStack(alignment: .top) {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    bodySection
                }
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
                Text("TURTLE VOCA")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(ThemeColor.mainCgColor))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
            HStack {
                Text("단어장")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    store.send(.addBookCaseButtonTapped)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(ThemeColor.mainCgColor))
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
            VStack(spacing: 0) {
                bookCaseCardSection
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                motivationSection
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
                    .background(Color(ThemeColor.mainCgColor))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - BookCase Grid View
    private var bookCaseCardSection: some View {
        WithPerceptionTracking {
            if store.bookCases.isEmpty {
                emptyView
            } else {
                bookCaseScrollView
            }
        }
    }
    
    private var bookCaseScrollView: some View {
        GeometryReader { geometry in
            WithPerceptionTracking {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(store.bookCases.enumerated()), id: \.element.objectID) { index, bookCase in
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
                            .frame(width: calculateCardWidth(geometry: geometry))
                        }
                    }
                    .padding(.horizontal, 36)
                }
            }
        }
    }
    
    private var motivationSection: some View {
        WithPerceptionTracking {
            if !store.bookCases.isEmpty {
                VStack {
                    Text(getRandomMotivation())
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
        }
    }
    
    private func calculateCardWidth(geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let padding: CGFloat = 72
        let spacing: CGFloat = 16
        let availableWidth = screenWidth - padding - spacing
        return availableWidth
    }
    
    private func getRandomMotivation() -> String {
        let motivations = [
            "성적이나 결과는 행동이 아니라 습관입니다. \n – 아리스토텔레스",
            "끝날 때까진 항상 불가능해 보입니다. \n – 넬슨 만델라",
            "열심히 하면 할수록 행운도 더 많이 옵니다. \n – 토마스 제퍼슨",
            "산을 옮기는 사람은 작은 돌부터 옮기기 시작한다. \n – 공자"
        ]
        return motivations.randomElement() ?? motivations[0]
    }
}

#Preview {
    BookCaseView(
        store: Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
    )
}
