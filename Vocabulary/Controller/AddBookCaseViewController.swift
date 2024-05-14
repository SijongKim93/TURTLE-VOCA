//
//  addBookCaseViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class AddBookCaseViewController: UIViewController {
    
    //headerView랑 BodyView 스택 뷰로 감싸기
    let headerView = HeaderView()
    
    let bodyView = BodyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
    }
    
    private func setupConstraints(){
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
        
        headerView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        bodyView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureUI(){
        view.backgroundColor = .white
    }
}
