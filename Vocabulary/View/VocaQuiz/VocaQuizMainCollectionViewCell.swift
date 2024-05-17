//
//  VocaQuizMainCollectionViewCell.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class VocaQuizMainCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel = LabelFactory().makeLabel(title: "title", size: 25, isBold: false)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.layer.borderWidth = 0.5
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
