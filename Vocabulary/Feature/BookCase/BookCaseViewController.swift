//
//  BookCaseViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class BookCaseViewController: UIViewController {
    
    private var hostingController: UIHostingController<BookCaseView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let store = Store(initialState: BookCaseReducer.State()) {
            BookCaseReducer()
        }
        
        let bookCaseView = BookCaseView(store: store)
        hostingController = UIHostingController(rootView: bookCaseView)
        
        guard let hostingController = hostingController else { return }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
