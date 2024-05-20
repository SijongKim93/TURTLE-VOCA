//
//  BookCaseHeaderView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/13/24.
//

import Foundation
import UIKit
import SnapKit

class BookCaseHeaderView: UIView {
    
    weak var delegate: BookCaseHeaderViewDelegate?
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        if let logoImage = UIImage(named: "logo resize") {
            imageView.image = logoImage
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
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
        
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(plusButton.snp.width).multipliedBy(3)
            $0.height.equalTo(60)
        }
        
        headerStackView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    @objc func plusButtonTapped() {
        let addVocaBookVC = AddBookCaseViewController()
        addVocaBookVC.modalPresentationStyle = .fullScreen
        currentViewController?.present(addVocaBookVC, animated: true, completion: nil)
    }
}

protocol BookCaseHeaderViewDelegate: AnyObject {
    func didTapPlusButton()
}
