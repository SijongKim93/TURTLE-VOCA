//
//  AddBookCaseViewController.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/14/24.
//

import UIKit
import SnapKit
import CoreData
import PhotosUI

class AddBookCaseViewController: UIViewController {
    
    var bookCaseData: NSManagedObject?
    
    let headerView = AddBookCaseHeaderView()
    let bodyView = AddBookCaseBodyView()
    
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
        
        setupKeyboardEvent()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func setupConstraints(){
        view.addSubview(wholeStackView)
        
        wholeStackView.snp.makeConstraints{
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

//MARK: - AddBookCaseBodyView에서 프로토콜 호출

extension AddBookCaseViewController: AddBookCaseBodyViewDelegate {
    // 저장 완료 시 alert
    func addButtonTapped() {
        let alertController = AlertController().makeAlertWithCompletion(title: "저장 완료", message: "단어장이 저장되었습니다.") { _ in
            NotificationCenter.default.post(name: NSNotification.Name("didBookCase"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // 에러 시 alert
    func errorAlert() {
        let alertController = AlertController().makeNormalAlert(title: "에러", message: "단어장 저장에 실패했습니다.")
        present(alertController, animated: true, completion: nil)
    }
    
    //이미지 선택시 PHPicker present
    func didSelectImage() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.presentPHPicker()
                case .denied, .restricted:
                    self?.showPhotoLibraryAccessDeniedAlert()
                case .notDetermined:
                    self?.didSelectImage()
                @unknown default:
                    break
                }
            }
        }
    }

    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    private func showPhotoLibraryAccessDeniedAlert() {
        let alert = UIAlertController(title: "사진 접근 권한이 없습니다",
                                      message: "설정에서 사진 접근 권한을 허용해주세요.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
}

//MARK: - PHPicker extension

extension AddBookCaseViewController: PHPickerViewControllerDelegate {
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
