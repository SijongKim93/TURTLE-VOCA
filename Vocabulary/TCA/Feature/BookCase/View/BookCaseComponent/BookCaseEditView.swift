//
//  BookCaseFormView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI
import CoreData

struct BookCaseEditView: View {
    let store: StoreOf<BookCaseReducer>
    let isEditing: Bool
    let existingBookCase: BookCase?
    @Environment(\.dismiss) private var dismiss
    
    @State private var bookCaseName = ""
    @State private var bookCaseDescription = ""
    @State private var wordText = ""
    @State private var meaningText = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    init(store: StoreOf<BookCaseReducer>, isEditing: Bool = false, existingBookCase: BookCase? = nil) {
        self.store = store
        self.isEditing = isEditing
        self.existingBookCase = existingBookCase
        
        if isEditing, let bookCase = existingBookCase {
            self._bookCaseName = State(initialValue: bookCase.name ?? "")
            self._bookCaseDescription = State(initialValue: bookCase.explain ?? "")
            self._wordText = State(initialValue: bookCase.word ?? "")
            self._meaningText = State(initialValue: bookCase.meaning ?? "")
            
            if let imageData = bookCase.image {
                self._selectedImage = State(initialValue: UIImage(data: imageData))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                imageSelectionSection
                inputSection
                
                Spacer()
                
                saveButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .navigationTitle(isEditing ? "단어장 편집" : "새 단어장")
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
                        .frame(height: 300)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
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
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 5) {
                Text("단어장 이름")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("단어장 이름을 입력하세요", text: $bookCaseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
            }
            
            VStack(spacing: 5) {
                Text("단어장 간단 설명")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("단어장에 대한 간단한 설명을 작성해주세요.", text: $bookCaseDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
            }
            
            VStack(spacing: 5) {
                Text("영어 (단어 & 의미)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 5) {
                    TextField("언어", text: $wordText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    
                    TextField("의미", text: $meaningText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
            }
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
                .background(isFormValid ? Color(ThemeColor.mainCgColor) : Color.gray)
                .cornerRadius(8)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Helper Methods
    private var isFormValid: Bool {
        return !bookCaseName.isEmpty && !wordText.isEmpty && !meaningText.isEmpty
    }
    
    private func saveBookCase() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if isEditing, let bookCase = existingBookCase {
            store.send(.updateBookCase(bookCase, bookCaseName, imageData, bookCaseDescription.isEmpty ? nil : bookCaseDescription, wordText, meaningText))
        } else {
            store.send(.createBookCase(
                bookCaseName,
                imageData,
                bookCaseDescription.isEmpty ? nil : bookCaseDescription,
                wordText,
                meaningText
            ))
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

#Preview {
    BookCaseEditView(
        store: Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
    )
}
