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
import Combine
import CombineCocoa

class InsertVocaViewController: UIViewController {
    
    var selectedBookCaseName: String?
    var bookCaseData: BookCase?
    
    //스크롤 뷰 삽입
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Component 호출
    var scrollView = UIScrollView()
    var backButton = UIButton()
    
    //단어 추가 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var bookCaseLabel = LabelFactory().makeLabel(title: "", size: 20, textAlignment: .center, isBold: true)
    var saveVocaButton = UIButton()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, bookCaseLabel, saveVocaButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    var wordLabel = LabelFactory().makeLabel(title: "기억할 단어", size: 15, textAlignment: .left, isBold: true)
    var wordTextField = TextFieldFactory().makeTextField(placeholder: "단어를 입력하세요.(필수)", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    
    lazy var resultTable: UITableView = {
        let table = UITableView()
        table.register(ResultTableViewCell.self, forCellReuseIdentifier: Constants.resultCell)
        table.didSelectRowPublisher.sink { [weak self] indexPath in
            self?.definitionTextField.text = self?.result[0].text
        }.store(in: &cancellables)
        return table
    }()
    
    var definitionLabel = LabelFactory().makeLabel(title: "단어의 뜻", size: 15, textAlignment: .left, isBold: true)
    
    var definitionTextField = TextFieldFactory().makeTextField(placeholder: "단어의 의미를 입력하세요.(필수)", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var detailLabel = LabelFactory().makeLabel(title: "상세 설명", size: 15, textAlignment: .left, isBold: true)
    
    var detailTextField = TextFieldFactory().makeTextField(placeholder: "나만의 암기 팁을 입력하세요.", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var pronunciationLabel = LabelFactory().makeLabel(title: "발음", size: 15, textAlignment: .left, isBold: true)
    
    var pronunciationTextField = TextFieldFactory().makeTextField(placeholder: "발음을 입력하세요.", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var synonymLabel = LabelFactory().makeLabel(title: "유의어", size: 15, textAlignment: .left, isBold: true)
    
    var synonymTextField = TextFieldFactory().makeTextField(placeholder: "비슷한 의미를 가진 단어를 입력하세요.", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    var antonymLabel = LabelFactory().makeLabel(title: "반의어", size: 15, textAlignment: .left, isBold: true)
    
    var antonymTextField = TextFieldFactory().makeTextField(placeholder: "상반된 의미를 가진 단어를 입력하세요.", action: #selector(doneButtonTapped), dictAction: #selector(showDict))
    
    
    let networkManager = NetworkManager()
    @Published var result = [Translation]()
    private var cancellables = Set<AnyCancellable>()
    
    var tableDatasource: UITableViewDiffableDataSource<DiffableSectionModel, Translation>?
    var tableSnapshot: NSDiffableDataSourceSnapshot<DiffableSectionModel, Translation>?
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        saveVocaButton.setTitle("저장", for: .normal)
        saveVocaButton.setTitleColor(.black, for: .normal)
        saveVocaButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        saveVocaButton.addTarget(self, action: #selector(saveVocaButtonPressed), for: .touchUpInside)
        
        self.setupBookCaseLabel()
        self.configureUI()
        self.configureDiffableDataSource()
        self.makeConstraints()
        self.observe()
        self.bind()
        
        setupKeyboardEvent()
    }
    
    // 여백 탭했을 때 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    //MARK: - 선택한 단어장 이름 가져오기
    func setupBookCaseLabel() {
        bookCaseLabel.text = selectedBookCaseName
    }
    
    //MARK: - 단어 텍스트필드 API호출 결과값 적용
    func bind() {
        $result
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.configureSnapshot()
            }.store(in: &cancellables)
    }
    
    func observe() {
        wordTextField.textPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.networkManager.fetchRequest(query: value)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            return
                        case .failure(_):
                            return
                        }
                    }, receiveValue: { documents in
                        self!.result = documents
                    }).store(in: &self!.cancellables)
            }.store(in: &cancellables)
    }
    
    //MARK: - 화면 구성
    func configureUI() {
        [headerStackView, wordLabel, wordTextField, resultTable, definitionLabel, definitionTextField, detailLabel, detailTextField, pronunciationLabel, pronunciationTextField, synonymLabel, synonymTextField, antonymLabel, antonymTextField].forEach {
            self.view.addSubview( $0 )
        }
    }
    
    //MARK: - Layout
    func makeConstraints() {
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        wordTextField.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        resultTable.snp.makeConstraints {
            $0.top.equalTo(wordTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(60)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.top.equalTo(resultTable.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        definitionTextField.snp.makeConstraints {
            $0.top.equalTo(definitionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(definitionTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        detailTextField.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        pronunciationLabel.snp.makeConstraints {
            $0.top.equalTo(detailTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        pronunciationTextField.snp.makeConstraints {
            $0.top.equalTo(pronunciationLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        synonymLabel.snp.makeConstraints {
            $0.top.equalTo(pronunciationTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        synonymTextField.snp.makeConstraints {
            $0.top.equalTo(synonymLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        antonymLabel.snp.makeConstraints {
            $0.top.equalTo(synonymTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        antonymTextField.snp.makeConstraints {
            $0.top.equalTo(antonymLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    //MARK: - 단어 추가 버튼 눌렀을 때 코어데이터에 저장(단어와 단어뜻은 필수 입력)
    @objc func saveVocaButtonPressed() {
        
        if let word = wordTextField.text, let definition = definitionTextField.text,
           word.isEmpty == false, definition.isEmpty == false {
            
            CoreDataManager.shared.saveWord(word: word, definition: definition, detail: detailTextField.text ?? "", pronunciation: pronunciationTextField.text ?? "", synonym: synonymTextField.text ?? "", antonym: antonymTextField.text ?? "", to: bookCaseData!, to: selectedBookCaseName!, errorHandler: {_ in
                let alert = AlertController().makeNormalAlert(title: "오류", message: "단어가 저장되지 않았습니다.")
                self.present(alert, animated: true)
            })
            
            let alert = AlertController().makeAlertWithCompletion(title: "저장 완료", message: "단어가 저장되었습니다.") { [weak self] _ in
                self?.dismiss(animated: true)
            }
            
            self.present(alert, animated: true)
            
        } else {
            
            let alert = AlertController().makeNormalAlert(title: "저장 불가", message: "단어와 단어의 뜻은 모두 입력해야 저장이 가능합니다.")
            self.present(alert, animated: true)
            
        }
    }
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc func showDict() {
        let url = URL(string: "https://dict.naver.com/")
        UIApplication.shared.open(url!)
    }
    
}

// MARK: - Diffable DataSource 적용
extension InsertVocaViewController {
    func configureDiffableDataSource () {
        tableDatasource = UITableViewDiffableDataSource(tableView: resultTable, cellProvider: { tableView, indexPath, model in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resultCell, for: indexPath) as! ResultTableViewCell
            
            
            cell.wordLabel.text = model.text
            cell.selectionStyle = .none
            
            return cell
        })
    }
    
    func configureSnapshot() {
        tableSnapshot = NSDiffableDataSourceSnapshot<DiffableSectionModel, Translation>()
        tableSnapshot?.deleteAllItems()
        tableSnapshot?.appendSections([.requestResult])
        tableSnapshot?.appendItems(result)
        
        tableDatasource?.apply(tableSnapshot!,animatingDifferences: true)
    }
    
}
