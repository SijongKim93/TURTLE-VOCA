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
    
    // AppDelegate에 접근하기 위한 프로퍼티
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not accessible.")
        }
        return appDelegate
    }
    
    // CoreData의 관리 객체 컨텍스트
    private var context: NSManagedObjectContext? {
        return appDelegate.persistentContainer.viewContext
    }
    
    var bookCaseName: String?
    var bookCaseData: BookCase?
    
    var bookCaseLabel = LabelFactory().makeLabel(title: "" , size: 20, textAlignment: .center, isBold: true)
    var backButton = UIButton()
    var addVocaButton = UIButton()
    var searchBar = UISearchBar()
    var countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    var wordList: [WordEntity] = []
    var filteredWordList: [WordEntity] = []
    var isFiltering: Bool = false
    var vocaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //단어장 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 단어 추가 버튼 눌렸을 때 단어입력페이지로 이동

    @objc func presentInsertVocaPage() {
        let scrollView = UIScrollView()
        let insertVocaView = InsertVocaViewController(scrollView: scrollView)
        insertVocaView.bookCaseData = self.bookCaseData
        insertVocaView.selectedBookCaseName = self.bookCaseName // 단어장 데이터 전달
        insertVocaView.modalPresentationStyle = .fullScreen
        self.present(insertVocaView, animated: true, completion: nil)
    }

    
    


   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        
        //코어데이터 작동 확인용
        //
        //        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
        //            print("Documents Directory: \(documentsDirectoryURL)")
        //        }
        //

              

        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        self.searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
        
        filteredWordList = wordList
        
        addVocaButton.tintColor = .black
        addVocaButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
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
    
    func configureUI() {
        self.view.addSubview(backButton)
        self.view.addSubview(bookCaseLabel)
        self.view.addSubview(addVocaButton)
        self.view.addSubview(searchBar)
        self.view.addSubview(countLabel)
        self.view.addSubview(vocaCollectionView)
    }
    
    func makeConstraints() {
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        bookCaseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        addVocaButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(addVocaButton.snp.bottom).offset(15)
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
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 100)
        return layout
    }
    
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
            
            CoreDataManager.shared.deleteWord(word: wordToDelete)
            
            vocaCollectionView.deleteItems(at: [indexPath])
            updateCountLabel()
        }
    }
    
    
}

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
            CoreDataManager.shared.deleteWord(word: item)
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
        
        guard let context = context else {
            print("Error: NSManagedObjectContext is nil")
            return
        }
        
        let fetchRequest: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        
        if let word = item.word {
            fetchRequest.predicate = NSPredicate(format: "word == %@", word)
        } else {
            print("Error: item.word is nil")
        }
        
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest)
            if let existingEntity = fetchedEntities.first {
                detailVC.wordEntity = existingEntity
            } else {
                print("코어데이터 Entity를 찾을 수 없습니다.")
            }
            
        } catch {
            print("코어데이터 Entity를 찾을 수 없습니다.")
        }

        
        //           detailVC.word.text = item.word
        //           detailVC.pronunciation.text = item.pronunciation
        //           detailVC.definition.text = item.definition
        //           detailVC.detail.text = item.detail
        //           detailVC.synonym.text = item.synonym
        //           detailVC.antonym.text = item.antonym
        
        //        var wordEntity = WordEntity(context: context!)
        //        wordEntity.word = item.word
        //        wordEntity.pronunciation = item.pronunciation
        //        wordEntity.definition = item.definition
        //        wordEntity.detail = item.detail
        //        wordEntity.synonym = item.synonym
        //        wordEntity.antonym = item.antonym
        //
        //        detailVC.wordEntity = wordEntity
        


        detailVC.selectedBookCaseName = self.bookCaseName

        detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true, completion: nil)
    }
}

