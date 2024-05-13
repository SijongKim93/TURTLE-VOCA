//
//  GamePageBottomView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class GamePageBottomView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.itemSize = .init(width: 350, height: 60)
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GamePageCollectionViewCell.self, forCellWithReuseIdentifier: "GamePageCollectionViewCell")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
        }
    }
    
}
