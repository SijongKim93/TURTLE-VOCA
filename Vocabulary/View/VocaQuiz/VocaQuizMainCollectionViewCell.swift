//
//  VocaQuizMainCollectionViewCell.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class VocaQuizMainCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel = LabelFactory().makeLabel(title: "title",color: ThemeColor.mainColor, size: 20, isBold: true)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        addShadow()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.layer.borderWidth = 2
        self.layer.borderColor = ThemeColor.mainColor.cgColor
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
