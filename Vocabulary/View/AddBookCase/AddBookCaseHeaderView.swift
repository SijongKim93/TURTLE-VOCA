//
//  AddBookCaseHeaderView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/14/24.
//

import Foundation
import UIKit
import SnapKit

class AddBookCaseHeaderView: UIView{

    let headerLabel = LabelFactory().makeLabel(title: "단어장 추가", size: 23, isBold: true)
        
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
        
    lazy var hStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, headerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    @objc func backButtonTapped() {
        let currentVC = currentViewController as? AddBookCaseViewController
        currentViewController?.dismiss(animated: true)
    }
}
