//
//  InsertVocaView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import SwiftUI
import ComposableArchitecture

struct InsertVocaView: View {
    let store: StoreOf<AddVocaReducer>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithPerceptionTracking {
            let isEditing = store.wordForm.isEditing
            let isLoading = store.wordForm.isLoading
            let errorMessage = store.wordForm.errorMessage
            
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        wordInputSection
                        translationResultsSection
                        definitionInputSection
                        detailInputSection
                        pronunciationInputSection
                        synonymInputSection
                        antonymInputSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .navigationTitle(isEditing ? "단어 수정" : "단어 추가")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("취소") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("저장") {
                            store.send(.wordForm(.saveWord))
                        }
                        .disabled(!isFormValid() || isLoading)
                    }
                }
            }
            .onAppear {
                store.send(.wordForm(.resetForm))
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
    
    // MARK: - Word Input Section
    private var wordInputSection: some View {
        WithPerceptionTracking {
            let wordInput = store.wordForm.wordInput
            
            VStack(spacing: 8) {
                Text("기억할 단어")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("단어를 입력하세요.(필수)", text: Binding(
                    get: { wordInput },
                    set: { store.send(.wordForm(.wordInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
                .onChange(of: wordInput) { newValue in
                    if !newValue.isEmpty {
                        // 자동 번역은 상위 리듀서에서 처리됨
                    }
                }
            }
        }
    }
    
    // MARK: - Translation Results Section
    private var translationResultsSection: some View {
        WithPerceptionTracking {
            let wordInput = store.wordForm.wordInput
            let isTranslating = store.translation.isTranslating
            let translationResults = store.translation.translationResults
            let translationErrorMessage = store.translation.errorMessage
            
            if !wordInput.isEmpty {
                VStack(spacing: 8) {
                    Text("번역 결과")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if isTranslating {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("번역 중...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    } else if let errorMessage = translationErrorMessage {
                        VStack(spacing: 8) {
                            Text("번역 실패")
                                .font(.subheadline)
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    } else if !translationResults.isEmpty {
                        VStack(spacing: 8) {
                            ForEach(translationResults, id: \.text) { translation in
                                Button(action: {
                                    store.send(.wordForm(.translationSelected(translation.text)))
                                }) {
                                    HStack {
                                        Text(translation.text)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "arrow.down.circle")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Definition Input Section
    private var definitionInputSection: some View {
        WithPerceptionTracking {
            let definitionInput = store.wordForm.definitionInput
            
            VStack(spacing: 8) {
                Text("단어의 뜻")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("단어의 의미를 입력하세요.(필수)", text: Binding(
                    get: { definitionInput },
                    set: { store.send(.wordForm(.definitionInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            }
        }
    }
    
    // MARK: - Detail Input Section
    private var detailInputSection: some View {
        WithPerceptionTracking {
            let detailInput = store.wordForm.detailInput
            
            VStack(spacing: 8) {
                Text("상세 설명")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("나만의 암기 팁을 입력하세요.", text: Binding(
                    get: { detailInput },
                    set: { store.send(.wordForm(.detailInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            }
        }
    }
    
    // MARK: - Pronunciation Input Section
    private var pronunciationInputSection: some View {
        WithPerceptionTracking {
            let pronunciationInput = store.wordForm.pronunciationInput
            
            VStack(spacing: 8) {
                Text("발음")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("발음을 입력하세요.", text: Binding(
                    get: { pronunciationInput },
                    set: { store.send(.wordForm(.pronunciationInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            }
        }
    }
    
    // MARK: - Synonym Input Section
    private var synonymInputSection: some View {
        WithPerceptionTracking {
            let synonymInput = store.wordForm.synonymInput
            
            VStack(spacing: 8) {
                Text("유의어")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("비슷한 의미를 가진 단어를 입력하세요.", text: Binding(
                    get: { synonymInput },
                    set: { store.send(.wordForm(.synonymInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            }
        }
    }
    
    // MARK: - Antonym Input Section
    private var antonymInputSection: some View {
        WithPerceptionTracking {
            let antonymInput = store.wordForm.antonymInput
            
            VStack(spacing: 8) {
                Text("반의어")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("상반된 의미를 가진 단어를 입력하세요.", text: Binding(
                    get: { antonymInput },
                    set: { store.send(.wordForm(.antonymInputChanged($0))) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func isFormValid() -> Bool {
        let wordInput = store.wordForm.wordInput
        let definitionInput = store.wordForm.definitionInput
        return !wordInput.isEmpty && !definitionInput.isEmpty
    }
}
