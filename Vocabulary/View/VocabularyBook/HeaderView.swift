//
//  HeaderView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/13/24.
//

import Foundation
import UIKit
import SnapKit

class HeaderView: UIView {
    
    let headerStackView: UIStackView = {
        
        let headerLabel = LabelFactory().makeLabel(title: "거북이의 단어장", size: 23, isBold: true)
        
        let plusButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            button.tintColor = .black
            return button
        }()
        
        let stackView = UIStackView(arrangedSubviews: [headerLabel, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 150 // 음.. 먼가 다른 방법으로 간격 줘야할 거 같다..
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        
        addSubview(headerStackView)
        
        headerStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
}
