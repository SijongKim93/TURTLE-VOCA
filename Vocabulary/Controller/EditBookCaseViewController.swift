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
