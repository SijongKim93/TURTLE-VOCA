//
//  CalenderViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class CalenderViewController: UIViewController {
    
    private var hostingController: UIHostingController<CalendarView>?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwiftUIView()
        view.backgroundColor = .white
    }
    
    //MARK: - SwiftUI + TCA 뷰 설정
    func setupSwiftUIView() {
        let store = Store(initialState: CalendarReducer.State()) {
            CalendarReducer()
        } withDependencies: {
            $0.coreDataDependency = .liveValue
        }
        
        // SwiftUI View 생성
        let calendarView = CalendarView(store: store)
        
        // UIHostingController로 래핑
        let hostingController = UIHostingController(rootView: calendarView)
        self.hostingController = hostingController
        
        // Child View Controller로 추가
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Auto Layout 설정
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
