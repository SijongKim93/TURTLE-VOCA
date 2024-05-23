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
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        let selectedImage = UIImage(systemName: "plus.circle", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.tintColor = ThemeColor.mainColor
        
        return button
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, plusButton])
        stackView.axis = .horizontal
        stackView.spacing = 30
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
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        headerStackView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
    }
    
    //MARK: - Button Action
    
    @objc func plusButtonTapped() {
        let addBookCaseVC = AddBookCaseViewController()
        addBookCaseVC.modalPresentationStyle = .fullScreen
        currentViewController?.present(addBookCaseVC, animated: true, completion: nil)
    }
}
