//
//  BodyView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/13/24.
//

import Foundation
import UIKit
import SnapKit

class BodyView: UIView {
    
    let vocaBookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = .init(width: 300, height: 600)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //CollectionViewCell register 해줘야함
        
        return collectionView
    }()
    
    //응원문구 view
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        [vocaBookCollectionView].forEach {
            addSubview($0)
        }
        
        vocaBookCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            
        }
    }
}
