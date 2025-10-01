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
        VStack(spacing: 0) {
            imageSection
            
            textSection
            
            Spacer()
            
            buttonSection
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(ThemeColor.mainColor), lineWidth: 1)
        )
        .cornerRadius(12)
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
                .frame(height: 300)
            
            if let imageData = bookCase.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "book.closed")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .frame(height: 300)
            }
        }
        .frame(maxWidth: .infinity)
        .layoutPriority(1)
    }
    
    // MARK: - Text Section
    private var textSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bookCase.name ?? "이름 없음")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .lineLimit(2)
            
            Text(bookCase.explain ?? "")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
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
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
