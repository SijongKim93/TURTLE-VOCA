//
//  ViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class AddVocaViewController: UIViewController {
    
    var bookCaseName: String?
    var bookCaseData: BookCase?
   
    //MARK: - Component 호출
    var bookCaseLabel = LabelFactory().makeLabel(title: "" , size: 20, textAlignment: .center, isBold: true)
    var backButton = UIButton()
    var addVocaButton = UIButton()
    var searchBar = UISearchBar()
    var countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    var wordList: [WordEntity] = []
    var filteredWordList: [WordEntity] = []
    var isFiltering: Bool = false
    var vocaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, bookCaseLabel, addVocaButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    //단어장 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 단어 추가 버튼 눌렸을 때 단어입력페이지로 이동
    @objc func presentInsertVocaPage() {
        let scrollView = UIScrollView()
        let insertVocaView = InsertVocaViewController(scrollView: scrollView)
        insertVocaView.bookCaseData = self.bookCaseData
        insertVocaView.selectedBookCaseName = self.bookCaseName
        insertVocaView.modalPresentationStyle = .fullScreen
        self.present(insertVocaView, animated: true, completion: nil)
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        self.searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
        
        filteredWordList = wordList
        
        addVocaButton.tintColor = .black
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        addVocaButton.setImage(image, for: .normal)
        addVocaButton.addTarget(self, action: #selector(presentInsertVocaPage), for: .touchUpInside)

        setupBookCaseLabel()
        updateCountLabel()
        
        vocaCollectionView.dataSource = self
        vocaCollectionView.delegate = self
        vocaCollectionView.register(VocaCollectionViewCell.self, forCellWithReuseIdentifier: VocaCollectionViewCell.identifier)
        vocaCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: vocaCollectionView)
        
        self.configureUI()
        self.makeConstraints()
        
        getData()
    }
    
    // 여백 탭했을 때 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //코어데이터 불러오기
    func getData() {
        guard let bookCaseName = bookCaseName else {
            wordList = []
            filteredWordList = wordList
            vocaCollectionView.reloadData()
            updateCountLabel()
            return
        }
        
        wordList = CoreDataManager.shared.getSpecificData(query: bookCaseName) {error in
            let alert = AlertController().makeNormalAlert(title: "오류", message: "단어장을 가져오지 못했습니다. 다시 시도해주세요.")
            self.present(alert, animated: true, completion: nil)
            print("Failed to fetch words: \(error)")
        }
        filteredWordList = wordList
        vocaCollectionView.reloadData()
        updateCountLabel()
    }
    
    func setupBookCaseLabel() {
        bookCaseLabel.text = bookCaseName
    }
    
    func updateCountLabel() {
        countLabel.text = "총 \(wordList.count)단어"
    }
    
    //MARK: - 화면 구성
    func configureUI() {
        self.view.addSubview(headerStackView)
        self.view.addSubview(searchBar)
        self.view.addSubview(countLabel)
        self.view.addSubview(vocaCollectionView)
    }
    
    //MARK: - Layout
    func makeConstraints() {
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        
        addVocaButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        vocaCollectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - WordList CollectionView FlowLayout
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 100)
        return layout
    }
    
    //MARK: - CollectionView Cell SwipeGesture
    func configureCollectionView() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        vocaCollectionView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        
        let point = gesture.location(in: vocaCollectionView)
        if let indexPath = vocaCollectionView.indexPathForItem(at: point) {
            let wordToDelete = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
            
            if isFiltering {
                filteredWordList.remove(at: indexPath.row)
            }
            wordList.remove(at: indexPath.row)
            
            CoreDataManager.shared.deleteWord(word: wordToDelete) { [weak self] error in
                guard let self = self else { return }
                let alert = AlertController().makeNormalAlert(title: "삭제 불가", message: "단어가 삭제되지 않았습니다. 다시 시도해주세요.")
                self.present(alert, animated: true)
            }
            
            vocaCollectionView.deleteItems(at: [indexPath])
            updateCountLabel()
        }
    }
    
    
}

//MARK: - SearchBar Delegate
extension AddVocaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
            filteredWordList = wordList
        } else {
            isFiltering = true
            filteredWordList = wordList.filter { wordEntity in
                let wordMatch = wordEntity.word?.localizedCaseInsensitiveContains(searchText) ?? false
                let definitionMatch = wordEntity.definition?.localizedCaseInsensitiveContains(searchText) ?? false
                return wordMatch || definitionMatch
            }
        }
        vocaCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredWordList = wordList
        vocaCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}

//MARK: - CollectionView Delegate, DataSource
extension AddVocaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredWordList.count : wordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocaCollectionViewCell.identifier, for: indexPath) as? VocaCollectionViewCell else { fatalError("컬렉션 뷰 오류")}
        
        
        let item = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
        
        cell.configure(with: item)
        
        cell.deleteAction = { [weak self] in
            guard let self = self else { return }
            if self.isFiltering {
                self.filteredWordList.remove(at: indexPath.row)
            } else {
                self.wordList.remove(at: indexPath.row)
            }
            CoreDataManager.shared.deleteWord(word: item, errorHandler: { _ in
                let alert = AlertController().makeNormalAlert(title: "삭제 실패", message: "단어가 삭제되지 않았습니다. 다시 시도해주세요.")
                self.present(alert, animated: true, completion: nil)
            })
            collectionView.deleteItems(at: [indexPath])
            self.updateCountLabel()
        }
        
        cell.memorizeAction = { [weak self] isSelected in
            guard self != nil else { return }
            item.memory = isSelected
            CoreDataManager.shared.updateWordMemoryStatus(word: item, memory: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = VocaDetailViewController()
        let item = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
        

        detailVC.selectedBookCaseName = item.bookCaseName
        detailVC.bookCaseData = item

        detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true, completion: nil)
    }
}

