//
//  BookCaseViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class BookCaseViewController: UIViewController{
    
    let headerView = BookCaseHeaderView()
    let bodyView = BookCaseBodyView()
    
    lazy var wholeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, bodyView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didAddBookCase), name: NSNotification.Name("didAddBookCase"), object: nil)
    }
    
    private func setupConstraints() {
        view.addSubview(wholeStackView)
        
        wholeStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func didAddBookCase() {
        bodyView.configureUI()
    }
}
