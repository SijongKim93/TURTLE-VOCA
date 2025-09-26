//
//  AddBookCaseView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture

struct AddBookCaseView: View {
    let store: StoreOf<BookCaseReducer>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        BookCaseEditView(store: store, isEditing: false)
    }
}

#Preview {
    AddBookCaseView(
        store: Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
    )
}
 
