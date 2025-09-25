//
//  BookCaseCardView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import CoreData

struct BookCaseCardView: View {
    @ObservedObject var bookCase: BookCase
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 12) {
            // 이미지 섹션
            imageSection
            
            // 텍스트 섹션
            textSection
            
            // 버튼 섹션
            buttonSection
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            Button(action: onEdit) {
                Label("편집", systemImage: "pencil")
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Label("삭제", systemImage: "trash")
            }
        }
        .alert("단어장 삭제", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("'\(bookCase.name ?? "")' 단어장을 삭제하시겠습니까?")
        }
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 80)
            
            if let imageData = bookCase.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "book.closed")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - Text Section
    private var textSection: some View {
        VStack(spacing: 4) {
            Text(bookCase.name ?? "이름 없음")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        HStack(spacing: 8) {
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
