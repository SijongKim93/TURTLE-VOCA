//
//  MyPageViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class MyPageViewController: UIViewController {
    
    private var hostingController: UIHostingController<MyPageView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    func setupSwiftUIView() {
        let store = Store(initialState: MyPageReducer.State()) {
            MyPageReducer()
        } withDependencies: {
            $0.coreDataDependency = .liveValue
        }
        
        let myPageView = MyPageView(store: store)
        let hostingController = UIHostingController(rootView: myPageView)
        self.hostingController = hostingController
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SendCount Protocol (게임 카운트 업데이트용)
extension MyPageViewController: SendCount {
    func sendData(count: Int) {
        hostingController?.rootView.store.send(.updateGameCount(count))
    }
}
