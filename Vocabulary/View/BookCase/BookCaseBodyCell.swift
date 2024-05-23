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
    
    //MARK: - Properties

    weak var delegateDelete: DeleteBookCaseBodyCellDelegate?
    weak var delagateEdit: EditBookCaseBodyCellDelegate?
    
    var bookCaseData: NSManagedObject?
    
    //MARK: - UIElements

    static let identifier = String(describing: BookCaseBodyCell.self)
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = ThemeColor.mainCgColor
        view.layer.borderWidth = 2.5
        view.layer.cornerRadius = 43
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.menu = createMenu()
        button.tintColor = ThemeColor.mainColor
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "") // 기본 이미지 설정
        return imgView
    }()
    
    private let nameLabel = LabelFactory().makeLabel(title: "", size: 20, textAlignment: .left, isBold: true)
    private let detailLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let languageLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup

    private func setupConstraints() {
        contentView.addSubview(cellView)
        
        [menuButton, imageView, nameStackView, languageLabel].forEach {
            cellView.addSubview($0)
        }
        
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.trailing.equalToSuperview().inset(32)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(menuButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        languageLabel.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(with bookCaseData: NSManagedObject) {
        self.bookCaseData = bookCaseData
        if let imageData = bookCaseData.value(forKey: "image") as? Data {
            imageView.image = UIImage(data: imageData)
            imageView.layer.cornerRadius = 30
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
        nameLabel.text = bookCaseData.value(forKey: "name") as? String ?? ""
        detailLabel.text = bookCaseData.value(forKey: "explain") as? String ?? ""
        let word = bookCaseData.value(forKey: "word") as? String ?? ""
        let meaning = bookCaseData.value(forKey: "meaning") as? String ?? ""
        languageLabel.text = "\(word) / \(meaning)"
    }
    
    //MARK: - UIMenu
    
    private func createMenu() -> UIMenu {
        let editAction = UIAction(title: "수정", image: UIImage(systemName: "square.and.pencil")) { [self] _ in
            self.delagateEdit?.didTapEditButton(on: self, with: bookCaseData!)
        }
        
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.delegateDelete?.didTapDeleteButton(on: self)
        }
        
        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        return menu
    }
}

//MARK: - UIMenu 삭제/수정 클릭 시 BookCaseBodyView

protocol DeleteBookCaseBodyCellDelegate: AnyObject {
    func didTapDeleteButton(on cell: BookCaseBodyCell)
}

protocol EditBookCaseBodyCellDelegate: AnyObject {
    func didTapEditButton(on cell: BookCaseBodyCell, with bookCaseData: NSManagedObject)
}
