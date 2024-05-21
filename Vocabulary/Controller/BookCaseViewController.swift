//
//  BookCaseViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class BookCaseViewController: UIViewController{
    
    let headerView = BookCaseHeaderView()
    let bodyView = BookCaseBodyView()
    
    lazy var wholeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, bodyView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = -30
        return stackView
    }()
        
    let networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBookCase), name: NSNotification.Name("didBookCase"), object: nil)
        
        bodyView.delagateEdit = self
        bodyView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bodyView.selectInitialCell()
    }
    
    private func setupConstraints() {
        view.addSubview(wholeStackView)
        
        wholeStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // 단어장 추가 시 컬렉션 뷰 reload
    @objc func didBookCase() {
        bodyView.configureUI()
    }
}

extension BookCaseViewController: EditBookCaseBodyCellDelegate {
    func didTapEditButton(on cell: BookCaseBodyCell, with bookCaseData: NSManagedObject) {
        let editBookCaseVC = EditBookCaseViewController()
        editBookCaseVC.bookCaseData = bookCaseData
        present(editBookCaseVC, animated: true, completion: nil)
    }
}


extension BookCaseViewController: BookCaseBodyViewDelegate {
    func didSelectBookCase(_ bookCase: NSManagedObject) {
        guard let bookCase = bookCase as? BookCase else {
            print("Error: Failed NSManagedObject to BookCase")
            return
        }
        
        let addVocaVC = AddVocaViewController()
        addVocaVC.bookCase = bookCase
        addVocaVC.modalPresentationStyle = .fullScreen
        present(addVocaVC, animated: true)
        //navigationController?.pushViewController(addVocaVC, animated: true)
    }
}
