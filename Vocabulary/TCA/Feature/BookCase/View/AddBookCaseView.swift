//
//  AddBookCaseView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

struct AddBookCaseView: View {
    let store: StoreOf<BookCaseReducer>
    @Environment(\.dismiss) private var dismiss
    
    @State private var bookCaseName = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
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
            .navigationTitle("새 단어장")
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
        store.send(.createBookCase(bookCaseName, imageData))
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
    AddBookCaseView(
        store: Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
    )
}
