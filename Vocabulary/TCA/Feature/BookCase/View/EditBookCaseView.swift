//
//  EditBookCaseView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI
import CoreData

struct EditBookCaseView: View {
    let store: StoreOf<BookCaseReducer>
    
    @ObservedObject var bookCase: BookCase
    @Environment(\.dismiss) private var dismiss
    
    @State private var bookCaseName: String
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    init(store: StoreOf<BookCaseReducer>, bookCase: BookCase) {
        self.store = store
        self.bookCase = bookCase
        self._bookCaseName = State(initialValue: bookCase.name ?? "")
        
        if let imageData = bookCase.image {
            self._selectedImage = State(initialValue: UIImage(data: imageData))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 이미지 선택 섹션
                imageSelectionSection
                
                // 이름 입력 섹션
                nameInputSection
                
                Spacer()
                
                // 저장 버튼
                saveButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle("단어장 편집")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    // MARK: - Image Selection Section
    private var imageSelectionSection: some View {
        VStack(spacing: 16) {
            Text("단어장 이미지")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                showingImagePicker = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 120)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                            
                            Text("이미지 선택")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Name Input Section
    private var nameInputSection: some View {
        VStack(spacing: 16) {
            Text("단어장 이름")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("단어장 이름을 입력하세요", text: $bookCaseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            saveBookCase()
        }) {
            Text("저장")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(bookCaseName.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(8)
        }
        .disabled(bookCaseName.isEmpty)
    }
    
    // MARK: - Helper Methods
    private func saveBookCase() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        store.send(.updateBookCase(bookCase, bookCaseName, imageData))
    }
}
