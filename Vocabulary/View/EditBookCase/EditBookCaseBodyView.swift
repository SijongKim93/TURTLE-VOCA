//
//  EditBookCaseBodyView.swift
//  Vocabulary
//
//  Created by Luz on 5/18/24.
//

import UIKit
import SnapKit
import CoreData

class EditBookCaseBodyView: UIView {
    
    let coreDataManager = CoreDataManager.shared
    
    var bookCaseData: NSManagedObject? {
        didSet {
            setupTextFieldData()
        }
    }
    
    weak var delegate: EditBookCaseBodyViewDelegate?
    
    //imageStackView
    let backImgLabel = LabelFactory().makeLabel(title: "배경 이미지", size: 18, textAlignment: .left, isBold: true)
    
    let backImgView: UIImageView = {
        let backImgView = UIImageView()
        backImgView.image = UIImage(systemName: "plus")
        backImgView.contentMode = .center
        backImgView.tintColor = ThemeColor.mainColor
        backImgView.layer.borderColor = ThemeColor.mainCgColor
        backImgView.layer.borderWidth = 2
        backImgView.layer.cornerRadius = 10
        return backImgView
    }()
    
    lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backImgLabel, backImgView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //nameStackView
    let nameLabel = LabelFactory().makeLabel(title: "단어장 이름", size: 18, textAlignment: .left, isBold: true)
    let nameTextField = TextFieldFactory().makeTextField(placeholder: "단어장 이름을 입력하세요")
    let nameCountLabel = LabelFactory().makeLabel(title: "0/10", size: 13, textAlignment: .right, isBold: false)
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, nameCountLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //explainStackView
    let explainLabel = LabelFactory().makeLabel(title: "단어장 간단 설명", size: 18, textAlignment: .left, isBold: true)
    let explainTextField = TextFieldFactory().makeTextField(placeholder: "단어장에 대한 간단한 설명을 적어주세요")
    let explainCountLabel = LabelFactory().makeLabel(title: "0/15", size: 13, textAlignment: .right, isBold: false)
    
    lazy var explainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [explainLabel, explainTextField, explainCountLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //languageStackView
    let languageLabel = LabelFactory().makeLabel(title: "언어 (단어 & 의미)", size: 18, textAlignment: .left, isBold: true)
    let wordTextField = TextFieldFactory().makeTextField(placeholder: "단어")
    let meaningTextField = TextFieldFactory().makeTextField(placeholder: "의미")
    
    // 단어 & 의미 스택뷰
    lazy var wmStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [wordTextField, meaningTextField])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var languageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageLabel, wmStackView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //editButton
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("단어장 수정", for: .normal)
        button.backgroundColor = ThemeColor.mainColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupConstraints()
        configureUI()
        setupImageViewGesture()
        setupTextFieldData()
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        [imageStackView, nameStackView, explainStackView, languageStackView, editButton].forEach{
            addSubview($0)
        }
        
        imageStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(230)
        }
        
        nameStackView.snp.makeConstraints{
            $0.top.equalTo(imageStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        explainStackView.snp.makeConstraints{
            $0.top.equalTo(nameStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        languageStackView.snp.makeConstraints{
            $0.top.equalTo(explainStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        editButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        //이미지 뷰 크기 조절
        backImgView.snp.makeConstraints{
            $0.height.equalTo(150)
            $0.width.equalTo(120)
        }
        
        //버튼 크기 늘리기
        editButton.snp.makeConstraints{
            $0.height.equalTo(50)
        }
    }
    
    func configureUI(){
        backImgView.layer.cornerRadius = 10
        backImgView.layer.masksToBounds = true
    }
    
    private func setupImageViewGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        backImgView.isUserInteractionEnabled = true
        backImgView.addGestureRecognizer(tapGesture)
    }
    
    func setImage(_ image: UIImage) {
        backImgView.image = image
        backImgView.contentMode = .scaleToFill
    }
    
    @objc private func imageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didSelectImage()
    }
    
    func setupTextFieldData() {
        guard let data = bookCaseData else {
            print("Error: No data")
            return
        }
        nameTextField.text = data.value(forKey: "name") as? String ?? ""
        explainTextField.text = data.value(forKey: "explain") as? String ?? ""
        wordTextField.text = data.value(forKey: "word") as? String ?? ""
        meaningTextField.text = data.value(forKey: "meaning") as? String ?? ""
        if let imageData = data.value(forKey: "image") as? Data {
            print("Image data loaded successfully")
            let image = UIImage(data: imageData)
            setImage(image ?? UIImage(systemName: "photo")!)
        } else {
            print("Error: Failed to load image data")
        }
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        var isValid = true // 텍스트 필드가 채워져 있는지 확인하는 변수
        if nameTextField.text?.isEmpty ?? true {
            shakeTextField(nameTextField)
            isValid = false
        }
        if wordTextField.text?.isEmpty ?? true {
            shakeTextField(wordTextField)
            isValid = false
        }
        if meaningTextField.text?.isEmpty ?? true {
            shakeTextField(meaningTextField)
            isValid = false
        }
        
        if isValid {
            guard let name = nameTextField.text,
                  let explain = explainTextField.text,
                  let word = wordTextField.text,
                  let meaning = meaningTextField.text,
                  let image = backImgView.image?.jpegData(compressionQuality: 1.0),
                  let data = bookCaseData else {
                return
            }
            
            coreDataManager.updateBookCase(data as! BookCase, name: name, explain: explain, word: word, meaning: meaning, image: image, errorHandler: { _ in
                self.delegate?.editErrorAlert()
            })
            delegate?.editButtonTapped()
        }
    }
    
    func shakeTextField(_ textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
    }
}

protocol EditBookCaseBodyViewDelegate: AnyObject {
    func editButtonTapped()
    func didSelectImage()
    func editErrorAlert()
}
