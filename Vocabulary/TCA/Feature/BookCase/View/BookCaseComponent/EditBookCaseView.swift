//
//  EditBookCaseView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import SwiftUI
import ComposableArchitecture
import CoreData

struct EditBookCaseView: View {
    let store: StoreOf<BookCaseReducer>
    @ObservedObject var bookCase: BookCase
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        BookCaseEditView(store: store, isEditing: true, existingBookCase: bookCase)
    }
}
