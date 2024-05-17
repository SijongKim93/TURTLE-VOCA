//
//  BodyCollectionViewCell.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/14/24.
//

import UIKit
import SnapKit
import CoreData

class BookCaseBodyCell: UICollectionViewCell {
    
    static let identifier = String(describing: BookCaseBodyCell.self)
    
    var bookCaseData: NSManagedObject?
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 26
        return view
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.tintColor = .systemGray2
        imgView.backgroundColor = .white
        if let imageData = bookCaseData?.value(forKey: "image") as? Data {
            imgView.image = UIImage(data: imageData)
        } else {
            imgView.image = UIImage(systemName: "photo")
        }
        return imgView
    }()
    
    lazy var nameLabel = LabelFactory().makeLabel(title: bookCaseData?.value(forKey: "name") as? String ?? "코딩 단어장", size: 20, textAlignment: .left, isBold: true)
    lazy var detailLabel = LabelFactory().makeLabel(title: bookCaseData?.value(forKey: "explain") as? String ?? "Swift 공부", size: 15, textAlignment: .left, isBold: false)
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var languageLabel = LabelFactory().makeLabel(title: "\(bookCaseData?.value(forKey: "word") as? String ?? "Swift") / \(bookCaseData?.value(forKey: "meaning") as? String ?? "한국어")", size: 15, textAlignment: .left, isBold: false)
    let countLabel = LabelFactory().makeLabel(title: "단어 개수", size: 15, textAlignment: .right, isBold: false)
    
    lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageLabel, countLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        contentView.addSubview(cellView)
        
        [menuButton, imageView, nameStackView, wordStackView].forEach{
            cellView.addSubview($0)
        }
        
        cellView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        imageView.snp.makeConstraints{
            $0.top.equalTo(menuButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        nameStackView.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        wordStackView.snp.makeConstraints{
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
