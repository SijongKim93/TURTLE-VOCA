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
        bodyView.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bodyView.selectInitialCell()
        bodyView.configureUI()
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
        addVocaVC.bookCaseData = bookCase
        addVocaVC.bookCaseName = bookCase.name
        addVocaVC.modalPresentationStyle = .fullScreen
        present(addVocaVC, animated: true)
    }
    
    func deleteErrorAlert() {
        let alertController = AlertController().makeNormalAlert(title: "에러", message: "단어장 삭제에 실패했습니다.")
        present(alertController, animated: true)
    }
    
    func fetchErrorAlert() {
        let alertController = AlertController().makeNormalAlert(title: "에러", message: "단어장 불러오기에 실패했습니다.")
        present(alertController, animated: true)
    }
}
