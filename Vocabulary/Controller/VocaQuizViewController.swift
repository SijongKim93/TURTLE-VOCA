//
//  VocaQuizViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class VocaQuizViewController: UIViewController {

    let headerView = QuizHeaderView()
    let bodyView = QuizBodyView()
    
    let testTitle = LabelFactory().makeLabel(title: "normal", size: 40, textAlignment: .center, isBold: false)
    let testTitle1 = LabelFactory().makeLabel(title: "bold", size: 40, textAlignment: .left, isBold: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(testTitle)
        view.addSubview(testTitle1)
        
        testTitle.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
        
        testTitle1.snp.makeConstraints {
            $0.top.equalTo(testTitle.snp.bottom).offset(10)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-200)
        }
        // Do any additional setup after loading the view.
    }
    
    


}
