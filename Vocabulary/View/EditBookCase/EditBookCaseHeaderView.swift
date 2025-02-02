//
//  EditBookCaseHeaderView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/18/24.
//

import Foundation
import UIKit
import SnapKit

class EditBookCaseHeaderView: UIView {

    let headerLabel = LabelFactory().makeLabel(title: "단어장 수정", size: 23, isBold: true)
        
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
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup

    func setupConstraints() {
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    //MARK: - Button Action

    @objc func backButtonTapped() {
        currentViewController?.dismiss(animated: true)
    }
}
