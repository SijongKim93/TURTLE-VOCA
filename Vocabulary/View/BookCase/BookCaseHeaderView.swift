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
    
    // MARK: - Properties
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        if let logoImage = UIImage(named: "turtlevoca") {
            imageView.image = logoImage
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = ThemeColor.mainColor
        return button
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupConstraints(){
        
        addSubview(headerStackView)
        
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(plusButton.snp.width).multipliedBy(2)
            $0.height.equalTo(20)
        }
        
        headerStackView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
    }
    
    //MARK: - Button Action
    
    @objc func plusButtonTapped() {
        let addBookCaseVC = AddBookCaseViewController()
        addBookCaseVC.modalPresentationStyle = .fullScreen
        currentViewController?.present(addBookCaseVC, animated: true, completion: nil)
    }
}
