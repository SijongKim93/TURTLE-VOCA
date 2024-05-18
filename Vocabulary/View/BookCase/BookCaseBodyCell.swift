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
    
    weak var delegate: BookCaseBodyCellDelegate?
    
    var bookCaseData: NSManagedObject?
    
    static let identifier = String(describing: BookCaseBodyCell.self)
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 26
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.menu = createMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.tintColor = .systemGray2
        imgView.backgroundColor = .white
        imgView.image = UIImage(systemName: "photo") // 기본 이미지 설정
        return imgView
    }()
    
    private let nameLabel = LabelFactory().makeLabel(title: "", size: 20, textAlignment: .left, isBold: true)
    private let detailLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let languageLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    private let countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .right, isBold: false)
    
    private lazy var wordStackView: UIStackView = {
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
        
        [menuButton, imageView, nameStackView, wordStackView].forEach {
            cellView.addSubview($0)
        }
        
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(menuButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        wordStackView.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with bookCaseData: NSManagedObject) {
        if let imageData = bookCaseData.value(forKey: "image") as? Data {
            imageView.image = UIImage(data: imageData)
            imageView.contentMode = .scaleToFill
        }
        nameLabel.text = bookCaseData.value(forKey: "name") as? String ?? "코딩 단어장"
        detailLabel.text = bookCaseData.value(forKey: "explain") as? String ?? "Swift 공부"
        let word = bookCaseData.value(forKey: "word") as? String ?? "Swift"
        let meaning = bookCaseData.value(forKey: "meaning") as? String ?? "한국어"
        languageLabel.text = "\(word) / \(meaning)"
    }
    
    private func createMenu() -> UIMenu {
        let editAction = UIAction(title: "수정", image: UIImage(systemName: "square.and.pencil")) { _ in
            // 수정 작업 처리
        }
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.delegate?.didTapDeleteButton(on: self)
        }
        return UIMenu(title: "", children: [editAction, deleteAction])
    }
}

protocol BookCaseBodyCellDelegate: AnyObject {
    func didTapDeleteButton(on cell: BookCaseBodyCell)
}
