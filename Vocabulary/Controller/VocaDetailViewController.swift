//
//  VocaDetailViewController.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/17/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class VocaDetailViewController: UIViewController {
    
    var bookCaseLabel = LabelFactory().makeLabel(title: "선택한 단어장 이름", size: 20, textAlignment: .center, isBold: true)
    var wordLabel = LabelFactory().makeLabel(title: "기억할 단어", size: 15, textAlignment: .left, isBold: true)
    var definitionLabel = LabelFactory().makeLabel(title: "단어의 뜻", size: 15, textAlignment: .left, isBold: true)
    var pronunciationLabel = LabelFactory().makeLabel(title: "발음", size: 15, textAlignment: .left, isBold: true)
    var detailLabel = LabelFactory().makeLabel(title: "상세 설명", size: 15, textAlignment: .left, isBold: true)
    var synonymLabel = LabelFactory().makeLabel(title: "유의어", size: 15, textAlignment: .left, isBold: true)
    var antonymLabel = LabelFactory().makeLabel(title: "반의어", size: 15, textAlignment: .left, isBold: true)
    
    
    var word = LabelFactory().detailTextFieldLabel()
    var definition = LabelFactory().detailTextFieldLabel()
    var pronunciation = LabelFactory().detailTextFieldLabel()
    var detail = LabelFactory().detailTextFieldLabel()
    var synonym = LabelFactory().detailTextFieldLabel()
    var antonym = LabelFactory().detailTextFieldLabel()
    
    var wordTextField = TextFieldFactory().makeTextField(placeholder: "")
    var definitionTextField = TextFieldFactory().makeTextField(placeholder: "")
    var pronunciationTextField = TextFieldFactory().makeTextField(placeholder: "")
    var detailTextField = TextFieldFactory().makeTextField(placeholder: "")
    var synonymTextField = TextFieldFactory().makeTextField(placeholder: "")
    var antonymTextField = TextFieldFactory().makeTextField(placeholder: "")
    
    var backButton = UIButton()
    var editSaveButton = UIButton()
    
    var isEditingMode = false
    var wordEntity: WordEntity?
    
    //단어추가 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        print(wordEntity)
        //코어데이터 작동 확인용

        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
        
        
        
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        editSaveButton.setTitle("수정", for: .normal)
        editSaveButton.setTitleColor(.black, for: .normal)
        editSaveButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        
        self.configureUI()
        self.makeConstraints()
        
        //수정버튼 클릭 후 변경사항이 있을 때만 수정내용 업데이트 하기
        if let wordEntity = wordEntity {
            setupWordEntity(wordEntity)
        }
    }
    
    
    func configureUI() {
        self.view.addSubview(bookCaseLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(editSaveButton)
        self.view.addSubview(wordLabel)
        self.view.addSubview(word)
        self.view.addSubview(definitionLabel)
        self.view.addSubview(definition)
        self.view.addSubview(pronunciationLabel)
        self.view.addSubview(pronunciation)
        self.view.addSubview(detailLabel)
        self.view.addSubview(detail)
        self.view.addSubview(synonymLabel)
        self.view.addSubview(synonym)
        self.view.addSubview(antonymLabel)
        self.view.addSubview(antonym)
        
        wordTextField.isHidden = true
        definitionTextField.isHidden = true
        pronunciationTextField.isHidden = true
        detailTextField.isHidden = true
        synonymTextField.isHidden = true
        antonymTextField.isHidden = true
        
        view.addSubview(wordTextField)
        view.addSubview(definitionTextField)
        view.addSubview(pronunciationTextField)
        view.addSubview(detailTextField)
        view.addSubview(synonymTextField)
        view.addSubview(antonymTextField)
    }
    
    func makeConstraints() {
        
        bookCaseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        editSaveButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        word.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        wordTextField.snp.makeConstraints {
            $0.edges.equalTo(word)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.top.equalTo(word.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        definition.snp.makeConstraints {
            $0.top.equalTo(definitionLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        definitionTextField.snp.makeConstraints {
            $0.edges.equalTo(definition)
        }
        
        pronunciationLabel.snp.makeConstraints {
            $0.top.equalTo(definition.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        pronunciation.snp.makeConstraints {
            $0.top.equalTo(pronunciationLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        pronunciationTextField.snp.makeConstraints {
            $0.edges.equalTo(pronunciation)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(pronunciation.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        detail.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        detailTextField.snp.makeConstraints {
            $0.edges.equalTo(detail)
        }
        
        synonymLabel.snp.makeConstraints {
            $0.top.equalTo(detail.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        synonym.snp.makeConstraints {
            $0.top.equalTo(synonymLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        synonymTextField.snp.makeConstraints {
            $0.edges.equalTo(synonym)
        }
        
        
        antonymLabel.snp.makeConstraints {
            $0.top.equalTo(synonym.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        antonym.snp.makeConstraints {
            $0.top.equalTo(antonymLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        antonymTextField.snp.makeConstraints {
            $0.edges.equalTo(antonym)
        }
    }
    
    @objc func editButtonTapped() {
        isEditingMode.toggle()
        
        if isEditingMode {
            editSaveButton.setTitle("저장", for: .normal)
            showTextFields()
        } else {
            editSaveButton.setTitle("수정", for: .normal)
            saveChanges()
            updateUI()
        }
    }
    
    func showTextFields() {
        word.isHidden = true
        definition.isHidden = true
        pronunciation.isHidden = true
        detail.isHidden = true
        synonym.isHidden = true
        antonym.isHidden = true
        
        wordTextField.isHidden = false
        definitionTextField.isHidden = false
        pronunciationTextField.isHidden = false
        detailTextField.isHidden = false
        synonymTextField.isHidden = false
        antonymTextField.isHidden = false
        
        wordTextField.text = word.text
        definitionTextField.text = definition.text
        pronunciationTextField.text = pronunciation.text
        detailTextField.text = detail.text
        synonymTextField.text = synonym.text
        antonymTextField.text = antonym.text
    }
    
    func saveChanges() {
        guard let wordEntity = wordEntity else { return }
        
        //코어데이터에 변경사항 저장하기
        wordEntity.word = wordTextField.text
        wordEntity.definition = definitionTextField.text
        wordEntity.pronunciation = pronunciationTextField.text
        wordEntity.detail = detailTextField.text
        wordEntity.synonym = synonymTextField.text
        wordEntity.antonym = antonymTextField.text
        
        do {
            try wordEntity.managedObjectContext?.save()
            
            let alert = AlertController().makeNormalAlert(title: "저장 완료", message: "수정된 내용이 저장되었습니다.")
            self.present(alert, animated: true, completion: nil)
            print("수정된 내용이 저장되었습니다.")
            
        } catch {
            let alert = AlertController().makeNormalAlert(title: "저장 실패", message: "변경 내용이 저장되지 않았습니다. 다시 시도해주세요.")
            self.present(alert, animated: true, completion: nil)
            print("수정된 내용이 저장되지 않았습니다.")
        }
        
       //변경사항 레이블로 다시 보여주기
        word.text = wordTextField.text
        definition.text = definitionTextField.text
        pronunciation.text = pronunciationTextField.text
        detail.text = detailTextField.text
        synonym.text = synonymTextField.text
        antonym.text = antonymTextField.text
    }
    
    
    func updateUI() {
        word.isHidden = false
        definition.isHidden = false
        pronunciation.isHidden = false
        detail.isHidden = false
        synonym.isHidden = false
        antonym.isHidden = false
        
        wordTextField.isHidden = true
        definitionTextField.isHidden = true
        pronunciationTextField.isHidden = true
        detailTextField.isHidden = true
        synonymTextField.isHidden = true
        antonymTextField.isHidden = true
    }
    
    func setupWordEntity(_ editedWordEntity: WordEntity) {
        word.text = wordEntity?.word
        definition.text = wordEntity?.definition
        pronunciation.text = wordEntity?.pronunciation
        detail.text = wordEntity?.detail
        synonym.text = wordEntity?.synonym
        antonym.text = wordEntity?.antonym

    }
}
