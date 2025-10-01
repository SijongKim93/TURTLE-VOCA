//
//  WordDetailView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import SwiftUI
import ComposableArchitecture

struct WordDetailView: View {
    let store: StoreOf<WordDetailReducer>
    @Environment(\.dismiss) private var dismiss
    
    // Binding을 WithPerceptionTracking 밖에서 생성
    private var editingWordBinding: Binding<String> {
        Binding(
            get: { store.editingWord },
            set: { store.send(.updateEditingWord($0)) }
        )
    }
    
    private var editingDefinitionBinding: Binding<String> {
        Binding(
            get: { store.editingDefinition },
            set: { store.send(.updateEditingDefinition($0)) }
        )
    }
    
    private var editingDetailBinding: Binding<String> {
        Binding(
            get: { store.editingDetail },
            set: { store.send(.updateEditingDetail($0)) }
        )
    }
    
    private var editingPronunciationBinding: Binding<String> {
        Binding(
            get: { store.editingPronunciation },
            set: { store.send(.updateEditingPronunciation($0)) }
        )
    }
    
    private var editingSynonymBinding: Binding<String> {
        Binding(
            get: { store.editingSynonym },
            set: { store.send(.updateEditingSynonym($0)) }
        )
    }
    
    private var editingAntonymBinding: Binding<String> {
        Binding(
            get: { store.editingAntonym },
            set: { store.send(.updateEditingAntonym($0)) }
        )
    }
    
    var body: some View {
        WithPerceptionTracking {
            let word = store.word
            let isEditing = store.isEditing
            let isLoading = store.isLoading
            let errorMessage = store.errorMessage
            
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        if isEditing {
                            editingView
                        } else {
                            readOnlyView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .navigationTitle("단어 상세")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("닫기") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isEditing {
                            Button("저장") {
                                store.send(.saveChanges)
                            }
                            .disabled(isLoading)
                        } else {
                            Button("수정") {
                                store.send(.editButtonTapped)
                            }
                        }
                    }
                }
                .alert("에러", isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { _ in }
                )) {
                    Button("확인") { }
                } message: {
                    Text(errorMessage ?? "")
                }
            }
        }
    }
    
    // MARK: - Read Only View
    private var readOnlyView: some View {
        WithPerceptionTracking {
            let word = store.word
            
            VStack(spacing: 24) {
                // 단어 정보 카드
                VStack(spacing: 16) {
                    HStack {
                        Text("단어")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        Button(action: {
                            store.send(.toggleMemoryStatus)
                        }) {
                            Image(systemName: word.memory ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(word.memory ? .green : .gray)
                                .font(.title2)
                        }
                    }
                    
                    Text(word.word ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 단어 의미
                if !(word.definition?.isEmpty ?? true) {
                    detailRow(title: "의미", content: word.definition ?? "")
                }
                
                // 상세 설명
                if !(word.detail?.isEmpty ?? true) {
                    detailRow(title: "상세 설명", content: word.detail ?? "")
                }
                
                // 발음
                if !(word.pronunciation?.isEmpty ?? true) {
                    detailRow(title: "발음", content: word.pronunciation ?? "")
                }
                
                // 유의어
                if !(word.synonym?.isEmpty ?? true) {
                    detailRow(title: "유의어", content: word.synonym ?? "")
                }
                
                // 반의어
                if !(word.antonym?.isEmpty ?? true) {
                    detailRow(title: "반의어", content: word.antonym ?? "")
                }
                
                // 암기 상태 정보
                memoryStatusSection
            }
        }
    }
    
    // MARK: - Editing View
    private var editingView: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
                editingField(title: "단어", text: editingWordBinding)
                
                editingField(title: "의미", text: editingDefinitionBinding)
                
                editingField(title: "상세 설명", text: editingDetailBinding)
                
                editingField(title: "발음", text: editingPronunciationBinding)
                
                editingField(title: "유의어", text: editingSynonymBinding)
                
                editingField(title: "반의어", text: editingAntonymBinding)
                
                // 편집 취소 버튼
                Button(action: {
                    store.send(.cancelEdit)
                }) {
                    Text("편집 취소")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Memory Status Section
    private var memoryStatusSection: some View {
        WithPerceptionTracking {
            let word = store.word
            
            VStack(spacing: 12) {
                HStack {
                    Text("암기 상태")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: word.memory ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(word.memory ? .green : .gray)
                        .font(.title2)
                    
                    Text(word.memory ? "암기 완료" : "암기 중")
                        .font(.body)
                        .foregroundColor(word.memory ? .green : .orange)
                    
                    Spacer()
                    
                    Button(action: {
                        store.send(.toggleMemoryStatus)
                    }) {
                        Text(word.memory ? "암기 취소" : "암기 완료")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Helper Views
    private func detailRow(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private func editingField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
}

#Preview {
    WordDetailView(
        store: Store(initialState: WordDetailReducer.State(word: WordEntity())) {
            WordDetailReducer()
        }
    )
}
