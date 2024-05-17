//
//  InsertVocaView.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/16/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData



class InsertVocaViewController: UIViewController {
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollView = UIScrollView()
    
    var bookCaseLabel = LabelFactory().makeLabel(title: "선택한 단어장 이름", size: 20, textAlignment: .center, isBold: true)
    var saveVocaButton = UIButton()
    var wordLabel = LabelFactory().makeLabel(title: "기억할 단어", size: 15, textAlignment: .left, isBold: true)
    var wordTextField = TextFieldFactory().makeTextField(placeholder: "단어를 입력하세요.(필수)")
    var definitionLabel = LabelFactory().makeLabel(title: "단어의 뜻", size: 15, textAlignment: .left, isBold: true)
  
    var definitionTextField = TextFieldFactory().makeTextField(placeholder: "단어의 의미를 입력하세요.(필수)")
    var detailLabel = LabelFactory().makeLabel(title: "상세 설명", size: 15, textAlignment: .left, isBold: true)
  
    var detailTextField = TextFieldFactory().makeTextField(placeholder: "나만의 암기 팁을 입력하세요.")
    var pronunciationLabel = LabelFactory().makeLabel(title: "발음", size: 15, textAlignment: .left, isBold: true)
  
    var pronunciationTextField = TextFieldFactory().makeTextField(placeholder: "발음을 입력하세요.")
    var synonymLabel = LabelFactory().makeLabel(title: "유의어", size: 15, textAlignment: .left, isBold: true)
  
    var synonymTextField = TextFieldFactory().makeTextField(placeholder: "비슷한 의미를 가진 단어를 입력하세요.")
    var antonymLabel = LabelFactory().makeLabel(title: "반의어", size: 15, textAlignment: .left, isBold: true)
  
    var antonymTextField = TextFieldFactory().makeTextField(placeholder: "상반된 의미를 가진 단어를 입력하세요.")
    
    
//    vstack에 넣는건 여기서????
    

    //Coredata
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Vocabulary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // 단어 추가 버튼 눌렸을 때 코어데이터에 저장 -> 단어와 단어뜻은 둘 다 입력되어야 저장되도록
    @objc func saveVocaButtonPressed() {
        
       if let word = wordTextField.text, let definition = definitionTextField.text,
          word.isEmpty == false, definition.isEmpty == false {
           
           saveWordToCoreData(word: word, definition: definition, detail: detailTextField.text ?? "", pronunciation: pronunciationTextField.text ?? "", synonym: synonymTextField.text ?? "", antonym: antonymTextField.text ?? "")
           
       } else {
            
           let alert = AlertController().makeNormalAlert(title: "저장 불가", message: "단어와 단어의 뜻은 모두 입력해야 저장이 가능합니다.")
           self.present(alert, animated: true)
           print("단어와 단어의 뜻은 모두 입력해야 저장이 가능합니다.")
         
        }
        
    }
    
    func saveWordToCoreData(word: String, definition: String, detail: String, pronunciation: String, synonym: String, antonym: String) {
        let context = persistentContainer.viewContext
        let newWord = WordEntity(context: context)
        newWord.word = word
        newWord.definition = definition
        newWord.detail = detail
        newWord.pronunciation = pronunciation
        newWord.synonym = synonym
        newWord.antonym = antonym
        newWord.date = Date()
//        newWord.category =

       
            do {
                try context.save()
                
                let alert = AlertController().makeNormalAlert(title: "저장 완료", message: "단어가 저장되었습니다.")
                let confirmButton = UIAlertAction(title: "확인", style: .default) { [weak self] _ in self?.dismiss(animated: true)}
                
                self.present(alert, animated: true)
                alert.addAction(confirmButton)
            
                print("단어가 저장되었습니다.")
               
            } catch {
                
                let alert = AlertController().makeNormalAlert(title: "저장 실패", message: "단어가 저장되지 않았습니다. 다시 시도해주세요.")
                   self.present(alert, animated: true)
                
                print("단어가 저장되지 않았습니다. 다시 시도해주세요.")
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        saveVocaButton.tintColor = .black
        saveVocaButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        saveVocaButton.addTarget(self, action: #selector(saveVocaButtonPressed), for: .touchUpInside)

        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
        
        self.configureUI()
        self.makeConstraints()
    
        
    }
    
    func configureUI() {
        self.view.addSubview(bookCaseLabel)
        self.view.addSubview(saveVocaButton)
        self.view.addSubview(wordLabel)
        self.view.addSubview(wordTextField)
        self.view.addSubview(definitionLabel)
        self.view.addSubview(definitionTextField)
        self.view.addSubview(detailLabel)
        self.view.addSubview(detailTextField)
        self.view.addSubview(pronunciationLabel)
        self.view.addSubview(pronunciationTextField)
        self.view.addSubview(synonymLabel)
        self.view.addSubview(synonymTextField)
        self.view.addSubview(antonymLabel)
        self.view.addSubview(antonymTextField)
    }
    
    
    func makeConstraints() {
        
        bookCaseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        saveVocaButton.snp.makeConstraints {
            $0.top.equalTo(bookCaseLabel.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.top.equalTo(saveVocaButton.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        wordTextField.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.top.equalTo(wordTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        definitionTextField.snp.makeConstraints {
            $0.top.equalTo(definitionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(definitionTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        detailTextField.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        pronunciationLabel.snp.makeConstraints {
            $0.top.equalTo(detailTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        pronunciationTextField.snp.makeConstraints {
            $0.top.equalTo(pronunciationLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        synonymLabel.snp.makeConstraints {
            $0.top.equalTo(pronunciationTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        synonymTextField.snp.makeConstraints {
            $0.top.equalTo(synonymLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        antonymLabel.snp.makeConstraints {
            $0.top.equalTo(synonymTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        antonymTextField.snp.makeConstraints {
            $0.top.equalTo(antonymLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
}

