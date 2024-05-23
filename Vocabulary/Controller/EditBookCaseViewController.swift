//
//  EditBookCaseViewController.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/18/24.
//

import UIKit
import SnapKit
import CoreData
import PhotosUI

class EditBookCaseViewController: UIViewController, EditBookCaseBodyViewDelegate {
    
    func editButtonTapped() {
        let alertController = AlertController().makeAlertWithCompletion(title: "수정 완료", message: "단어장이 수정되었습니다.") { _ in
            NotificationCenter.default.post(name: NSNotification.Name("didBookCase"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func editErrorAlert() {
        let alertController = AlertController().makeNormalAlert(title: "에러", message: "단어장 수정에 실패했습니다.")
        present(alertController, animated: true, completion: nil)
    }
    
    var bookCaseData: NSManagedObject?

    let headerView = EditBookCaseHeaderView()
    let bodyView = EditBookCaseBodyView()
    
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
        bodyView.bookCaseData = bookCaseData
    }
    
    private func setupConstraints(){
        view.addSubview(wholeStackView)
        
        wholeStackView.snp.makeConstraints{
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func didSelectImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //텍스트 필드 입력 시 키보드가 가리지 않게
    func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let activeField = UIResponder.findFirstResponder() as? UIView
        
        guard let activeField = activeField else { return }
        
        let fieldFrame = activeField.convert(activeField.bounds, to: view)
        let fieldBottom = fieldFrame.origin.y + fieldFrame.size.height
        
        let overlap = fieldBottom - (view.frame.height - keyboardHeight) + 20
        if overlap > 0 {
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y = -overlap
            }
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = 0
        }
    }
}

extension EditBookCaseViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.bodyView.setImage(image)
                    }
                }
            }
        }
    }
}
