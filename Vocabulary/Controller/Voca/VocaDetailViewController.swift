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

class VocaDetailViewController: UIViewController, UITextFieldDelegate {
    
    var selectedBookCaseName: String?
    var bookCaseData: WordEntity?
    
    //MARK: - Component 호출
    var bookCaseLabel = LabelFactory().makeLabel(title: "", size: 20, textAlignment: .center, isBold: true)
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
    
    var wordTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var definitionTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var pronunciationTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var detailTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var synonymTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var antonymTextField = TextFieldFactory().makeTextField(placeholder: "", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    
    var backButton = UIButton()
    var editSaveButton = UIButton()
    
    
    var isChange = false
    var isEditingMode = false
    
    //MARK: - 단어추가 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        editSaveButton.setTitle("수정", for: .normal)
        editSaveButton.setTitleColor(.black, for: .normal)
        editSaveButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        self.setDelegate()
        self.presentLabel()
        self.setupBookCaseLabel()
        self.configureUI()
        self.makeConstraints()
    }
 
    //MARK: - 선택한 단어 셀의 정보 레이블에 표시
    func presentLabel() {
        word.text = bookCaseData?.word
        definition.text = bookCaseData?.definition
        pronunciation.text = bookCaseData?.pronunciation
        detail.text = bookCaseData?.detail
        synonym.text = bookCaseData?.synonym
        antonym.text = bookCaseData?.antonym
    }
    
    // 여백 탭했을 때 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    //MARK: - 선택한 단어장 이름 가져오기
    func setupBookCaseLabel() {
        bookCaseLabel.text = selectedBookCaseName
    }
    
    //MARK: - 화면 구성
    func configureUI() {
        [bookCaseLabel, backButton, editSaveButton, wordLabel, word, definitionLabel, definition, pronunciationLabel, pronunciation, detailLabel, detail, synonymLabel, synonym, antonymLabel, antonym, wordTextField, definitionTextField, pronunciationTextField, detailTextField, synonymTextField, antonymTextField].forEach {
            self.view.addSubview($0)
        }

        [wordTextField, definitionTextField ,detailTextField, pronunciationTextField, synonymTextField, antonymTextField].forEach {
            $0.isHidden = true
        }
    }
    
    //MARK: - Layout
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
    
    //MARK: - 수정버튼 클릭시 동작
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
    
    //MARK: - TextField Delegate
    func setDelegate() {
        wordTextField.delegate = self
        definitionTextField.delegate = self
        pronunciationTextField.delegate = self
        detailTextField.delegate = self
        synonymTextField.delegate = self
        antonymTextField.delegate = self
    }
    
    //MARK: - 수정버튼 클릭시 레이블 -> 텍스트 필드로 변경
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
        
        isChange = false
        setupTextFieldListeners()
    }
    
    //MARK: - 텍스트 필드 변경사항 감지 및 코어데이터에 수정사항 저장
    func saveChanges() {
        if isChange == true {
            
            CoreDataManager.shared.updateVoca(editedWord: bookCaseData!, word: wordTextField.text!, definition: definitionTextField.text!, detail: detailTextField.text ?? "", pronunciation: pronunciationTextField.text ?? "", synonym: synonymTextField.text ?? "", antonym: antonymTextField.text ?? "", to: selectedBookCaseName!, errorHandler: { _ in
                let alert = AlertController().makeNormalAlert(title: "저장 실패", message: "변경 내용이 저장되지 않았습니다. 다시 시도해주세요.")
                self.present(alert, animated: true, completion: nil)
            })
            
            let alert = AlertController().makeNormalAlert(title: "저장 완료", message: "수정된 내용이 저장되었습니다.")
            self.present(alert, animated: true, completion: nil)
            print("수정된 내용이 저장되었습니다.")
            
        } else {
            
            let alert = AlertController().makeNormalAlert(title: "저장 불가", message: "수정된 내용이 없습니다.")
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //변경사항 레이블로 다시 보여주기
        word.text = wordTextField.text
        definition.text = definitionTextField.text
        pronunciation.text = pronunciationTextField.text
        detail.text = detailTextField.text
        synonym.text = synonymTextField.text
        antonym.text = antonymTextField.text
    }
    
    //MARK: - 변경 사항 저장 후 텍스트 필드 -> 레이블로 변경
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
    
    //MARK: - 텍스트 필드 변경 감지
    func setupTextFieldListeners() {
        wordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        definitionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        pronunciationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        detailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        synonymTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        antonymTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isChange = true
    }
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc func showDict() {
        let url = URL(string: "https://dict.naver.com/")
        UIApplication.shared.open(url!)
    }
    
}


