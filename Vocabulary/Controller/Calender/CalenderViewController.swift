//
//  CalenderViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class CalenderViewController: UIViewController {
    
    var selectedDate: DateComponents? = nil
    var filteredWords: [WordEntity] = []
    let coreDataManager = CoreDataManager.shared
    
    //MARK: - Component 호출
    let dateView: UICalendarView = {
        var view = UICalendarView()
        view.calendar = .current
        view.locale = .current
        view.tintColor = ThemeColor.mainColor
        view.fontDesign = .rounded
        return view
    }()
    
    let viewLine: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let upButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let filterButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "filter"), for: .normal)
        return button
    }()
    
    let menuButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(upButton)
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(menuButton)
        
        return stackView
    }()
    
    let dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        buttonAction()
        
        view.backgroundColor = .white
        
        // 처음 캘린더 탭에 들어왔을때 현재 날짜가 활성화 되도록 설정
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        selectedDate = currentDateComponents
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        selectionBehavior.selectedDate = currentDateComponents
        dateView.selectionBehavior = selectionBehavior
        
        fetchWordListAndUpdateCollectionView()
        dateView.reloadDecorations(forDateComponents: [selectedDate!], animated: true)
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedDate == nil {
            let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            selectedDate = currentDate
        }
        
        fetchWordListAndUpdateCollectionView()
        didDismissFilterDetailModal()
        dateView.reloadDecorations(forDateComponents: [selectedDate!], animated: true)
    }
    
    //MARK: - Component Setup
    func setupUI() {
        view.addSubview(dateView)
        view.addSubview(buttonStackView)
        view.addSubview(viewLine)
        view.addSubview(dayCollectionView)
        view.addSubview(emptyStateView)
        
        dateView.delegate = self
        dateView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: dayCollectionView)
        dayCollectionView.register(CalenderCollectionViewCell.self, forCellWithReuseIdentifier: CalenderCollectionViewCell.identifier)
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(435) // 높이 고정
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        dayCollectionView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.edges.equalTo(dayCollectionView)
        }
    }
    //MARK: - 버튼 액션
    func buttonAction() {
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - 업 버튼을 누르면 단어장이 넓게 보이고 다시 누르면 원래 사이즈로 돌아오는 메서드
    @objc func upButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            if self.upButton.isSelected {
                self.dateView.constraints.forEach {
                    if $0.firstAttribute == .height {
                        $0.constant = 435
                    }
                }
                self.upButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            } else {
                self.dateView.constraints.forEach {
                    if $0.firstAttribute == .height {
                        $0.constant = 0
                    }
                }
                self.upButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            }
            self.view.layoutIfNeeded()
            self.upButton.isSelected.toggle()
        }
    }
    
    //MARK: - 필터 버튼 , 메뉴 버튼 클릭 시 커스텀 모달 호출
    @objc func filterButtonTapped() {
        let filterModalVC = FilterDetailModalViewController()
        filterModalVC.delegate = self
        filterModalVC.modalPresentationStyle = .custom
        filterModalVC.transitioningDelegate = self
        present(filterModalVC, animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped() {
        let menuModelVC = MenuDetailModalViewController()
        menuModelVC.delegate = self
        menuModelVC.modalPresentationStyle = .custom
        menuModelVC.transitioningDelegate = self
        present(menuModelVC, animated: true, completion: nil)
    }
    
    //MARK: - CollectionView FlowLayout 설정
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 100)
        return layout
    }
    
    //MARK: - 캘린더에 선택 된 날짜에 저장된 단어데이터 호출 메서드
    func fetchWordListAndUpdateCollectionView() {
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dateToFetch = selectedDate?.date ?? Calendar.current.date(from: currentDate)!
        
        filteredWords = coreDataManager.getWordListFromCoreData(for: dateToFetch)
        
        let filterIndex = fetchFilterIndex()
        
        filteredWords = sortWords(filteredWords, by: filterIndex)
        
        dayCollectionView.reloadData()
        dateView.reloadDecorations(forDateComponents: [selectedDate!], animated: true)
        emptyStateView.isHidden = !filteredWords.isEmpty
    }
    
    //MARK: - 필터 내 선택한 인덱스를 저장하고 이전 선택 값이 없다면 0을 기본으로 가지는 메서드
    func fetchFilterIndex() -> Int {
        if UserDefaults.standard.object(forKey: "SelectedFilterIndex") == nil {
            UserDefaults.standard.set(0, forKey: "SelectedFilterIndex")
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.integer(forKey: "SelectedFilterIndex")
    }
    
    //MARK: - UserDefaults를 통해 저장된 필터 인덱스 값마다 해당하는 필터 옵션을 적용하는 메서드
    func sortWords(_ words: [WordEntity], by filterIndex: Int) -> [WordEntity] {
        switch filterIndex {
        case 0:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.date ?? Date() > word2.date ?? Date()
            }
        case 1:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.date ?? Date() < word2.date ?? Date()
            }
        case 2:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.memory && !word2.memory
            }
        case 3:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return !word1.memory && word2.memory
            }
        case 4:
            return words.shuffled()
        default:
            return words
        }
    }
}

//MARK: - 메뉴 버튼을 누르면 호출되는 프로토콜 필수 메서드
extension CalenderViewController: MenuDetailModalDelegate {
    //MARK: - 캘린더에서 선택되어 있는 날짜를 바탕으로 해당 하는 날짜의 memory 여부를 모두 true로 변경하는 메서드
    func markWordsAsLearned() {
        let date: Date
        if let selectedDate = selectedDate {
            date = Calendar.current.date(from: selectedDate)!
        } else {
            date = Date()
        }
        
        let wordsForDate = coreDataManager.getWordListFromCoreData(for: date)
        
        for word in wordsForDate {
            coreDataManager.updateWordMemoryStatus(word: word, memory: true)
        }
        fetchWordListAndUpdateCollectionView()
    }
    
    //MARK: - 캘린더에서 선택되어 있는 날짜를 바탕으로 해당하는 날짜의 모든 단어를 지우는 메서드
    func deleteAllWords() {
        let date: Date
        if let selectedDate = selectedDate {
            date = Calendar.current.date(from: selectedDate)!
        } else {
            date = Date()
        }
        
        let wordsForDate = coreDataManager.getWordListFromCoreData(for: date)
        
        for word in wordsForDate {
            coreDataManager.deleteWord(word)
        }
        fetchWordListAndUpdateCollectionView()
        dateView.reloadDecorations(forDateComponents: [selectedDate!], animated: true)
    }
}

//MARK: - 단어를 표시하는 CollectionView Delegate, DateSource 설정
extension CalenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.identifier, for: indexPath) as? CalenderCollectionViewCell else { fatalError("컬렉션 뷰 오류") }
        
        let word = filteredWords[indexPath.row]
        cell.configure(with: word)
        cell.learnedButton.tag = indexPath.row
        cell.learnedButton.addTarget(self, action: #selector(learnedButtonTapped(_:)), for: .touchUpInside)
        cell.learnedButton.isSelected = word.memory
        
        return cell
    }
    
    //MARK: - 외웠음을 표시하는 버튼을 눌렀을 경우 해당하는 단어의 memory 상태를 변경하는 메서드
    @objc func learnedButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let word = filteredWords[index]
        let newLearnStatus = !word.memory
        coreDataManager.updateWordMemoryStatus(word: word, memory: newLearnStatus)
        
        sender.isSelected = newLearnStatus
    }
}


extension CalenderViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    //MARK: -  캘린더 날짜가 선택되었을때 해당 날짜를 바탕으로 하단 CollectionView 내 단어 데이터 띄우기 , 데이터가 없다면 View를 띄워 없다는 내용 안내
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents
        
        if let date = dateComponents?.date {
            filteredWords = coreDataManager.getWordListFromCoreData(for: date)
            let filterIndex = fetchFilterIndex()
            filteredWords = sortWords(filteredWords, by: filterIndex)
            dayCollectionView.reloadData()
            emptyStateView.isHidden = !filteredWords.isEmpty
        }
    }
    
    //MARK: -  특정 날짜 내 데이터가 있다면 DateComponent 데코레이션
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let date = Calendar.current.date(from: dateComponents), coreDataManager.hasData(for: date) {
            let emojiLabel = UILabel()
            emojiLabel.text = "🐢"
            emojiLabel.textAlignment = .center
            
            let containerView = UIView()
            containerView.addSubview(emojiLabel)
            emojiLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            return .customView { containerView }
        }
        return nil
    }
    
    //MARK: -  선택한 날짜 selectedDate 저장 및 해당하는 컬렉션 뷰 리로드
    func calendarView(_ calendarView: UICalendarView, didSelect dateComponents: DateComponents?) {
        selectedDate = dateComponents
        fetchWordListAndUpdateCollectionView()
    }
}

//MARK: - 필터 설정 후 필터창 내려간 뒤 변경된 데이터 정렬로 리로드
extension CalenderViewController: FilterDetailModalDelegate {
    func didDismissFilterDetailModal() {
        fetchWordListAndUpdateCollectionView()
    }
}

protocol FilterDetailModalDelegate: AnyObject {
    func didDismissFilterDetailModal()
}

//MARK: - 커스텀 뷰 특정 값을 가지고 띄워질 수 있도록 화면 전환 커스텀#imageLiteral(resourceName: "simulator_screenshot_72AF9C95-E8A6-4544-9F75-712FB2057D0F.png")
extension CalenderViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if let filterModalViewController = presented as? FilterDetailModalViewController {
            return FilterPresentationController(presentedViewController: filterModalViewController, presenting: presenting)
        } else if let menuModalViewController = presented as? MenuDetailModalViewController {
            return MenuPresentationController(presentedViewController: menuModalViewController, presenting: presenting)
        } else {
            return nil
        }
    }
}




