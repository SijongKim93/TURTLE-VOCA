//
//  AddBookCaseViewController.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/14/24.
//

import UIKit
import SnapKit

class AddBookCaseViewController: UIViewController, AddBookCaseBodyViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let headerView = AddBookCaseHeaderView()
    let bodyView = AddBookCaseBodyView()
    
    weak var delegate: AddBookCaseViewControllerDelegate?
    
    lazy var wholeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, bodyView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupConstraints()
        bodyView.delegate = self
    }
    
    private func setupConstraints(){
        [wholeStackView].forEach{
            view.addSubview($0)
        }
        
        wholeStackView.snp.makeConstraints{
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func didSelectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            bodyView.setImage(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func addButtonTapped() {
        let alertController = AlertController().makeAlertWithCompletion(title: "저장 완료", message: "단어장이 저장되었습니다.") { _ in
            self.delegate?.didAddBookCase()
            self.dismiss(animated: true, completion: nil)
        }
        present(alertController, animated: true, completion: nil)
    }
}

protocol AddBookCaseViewControllerDelegate: AnyObject {
    func didAddBookCase()
}
