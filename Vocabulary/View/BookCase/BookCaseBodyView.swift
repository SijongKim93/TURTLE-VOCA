//
//  BookCaseBodyView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/13/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class BookCaseBodyView: UIView {
    
    var bookCaseData: [NSManagedObject] = []
    
    let vocaBookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 13
        layout.sectionInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        layout.itemSize = .init(width: 300, height: 520)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    //응원 문구 ( 랜덤으로 들어가게 하고싶다 )
    let motivationLabel = LabelFactory().makeLabel(title: "응원 문구 !", size: 15, isBold: false)
    
    lazy var wholeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [vocaBookCollectionView, motivationLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        configureUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        
        addSubview(wholeStackView)
        
        wholeStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        vocaBookCollectionView.snp.makeConstraints{
            $0.height.equalTo(520)
        }
    }
    
    func configureUI(){
        
        bookCaseData = CoreDataManager.shared.fetchBookCase()
        
        vocaBookCollectionView.delegate = self
        vocaBookCollectionView.dataSource = self
        
        vocaBookCollectionView.register(BookCaseBodyCell.self, forCellWithReuseIdentifier: BookCaseBodyCell.identifier)
    }
}

extension BookCaseBodyView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookCaseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vocaBookCollectionView.dequeueReusableCell(withReuseIdentifier: BookCaseBodyCell.identifier, for: indexPath) as! BookCaseBodyCell
        let bookCaseData = bookCaseData[indexPath.item]
        cell.bookCaseData = bookCaseData
        
        return cell
    }
}
