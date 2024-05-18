//
//  MyPageViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import PhotosUI

class MyPageViewController: UIViewController {
    
    let myPageData = MyPageData()
    var coreDataManager: CoreDataManager?
    
    let profileContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 변경", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1499286592, green: 0.3536310196, blue: 0.2331167161, alpha: 1), for: .normal)
        return button
    }()
    
    let mailLabel = LabelFactory().makeLabel(title: "rlatlwhd456@naver.com", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: false)
    let subLabel = LabelFactory().makeLabel(title: "김시종", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: false)
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(mailLabel)
        stackView.addArrangedSubview(subLabel)
        return stackView
    }()
    
    let memoryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0).cgColor
        return view
    }()
    
    let saveVocaImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "savevoca")
        return image
    }()
    
    let memoryVocaImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "memoryvoca")
        return image
    }()
    
    let gamePlayImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "game")
        return image
    }()
    
    let saveVocaLabel = LabelFactory().makeLabel(title: "저장 된 단어", size: 17, textAlignment: .center, isBold: true)
    let saveVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateSaveVocaCount))개", size: 25, textAlignment: .center, isBold: true)
    let memoryVocaLabel = LabelFactory().makeLabel(title: "외운 단어", size: 17, textAlignment: .center, isBold: true)
    let memoryVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateMemoryVocaCount))", size: 25, textAlignment: .center, isBold: true)
    let gamePlayLabel = LabelFactory().makeLabel(title: "게임 진행 수", size: 17, textAlignment: .center, isBold: true)
    let gamePlayCount = LabelFactory().makeLabel(title: "3회", size: 25, textAlignment: .center, isBold: true)
    
    lazy var saveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(saveVocaImage)
        stackView.addArrangedSubview(saveVocaLabel)
        stackView.addArrangedSubview(saveVocaCount)
        return stackView
    }()
    
    lazy var memoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(memoryVocaImage)
        stackView.addArrangedSubview(memoryVocaLabel)
        stackView.addArrangedSubview(memoryVocaCount)
        return stackView
    }()
    
    lazy var gameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(gamePlayImage)
        stackView.addArrangedSubview(gamePlayLabel)
        stackView.addArrangedSubview(gamePlayCount)
        return stackView
    }()
    
    lazy var allCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(saveStackView)
        stackView.addArrangedSubview(memoryStackView)
        stackView.addArrangedSubview(gameStackView)
        
        return stackView
    }()
    
    let myPageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tableView.layer.borderWidth = 1
        tableView.backgroundColor = #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1)
        tableView.layer.borderColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0).cgColor
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        coreDataManager = CoreDataManager.shared
        setupUI()
        setupTableView()
        updateSaveVocaCount()
        updateMemoryVocaCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWordCounts()
    }
        
    func setupUI() {
        view.addSubview(profileContainer)
        view.addSubview(profileImage)
        view.addSubview(changeImageButton)
        view.addSubview(profileStackView)
        view.addSubview(memoryContainer)
        view.addSubview(allCountStackView)

        profileContainer.layer.cornerRadius = 16
        profileContainer.clipsToBounds = true
        
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        
        memoryContainer.layer.cornerRadius = 16
        memoryContainer.clipsToBounds = true
        
        changeImageButton.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
        
        profileContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(220)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(profileContainer.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        changeImageButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(changeImageButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        memoryContainer.snp.makeConstraints {
            $0.top.equalTo(profileContainer.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(150)
        }
        
        allCountStackView.snp.makeConstraints {
            $0.top.equalTo(memoryContainer.snp.top).offset(10)
            $0.leading.trailing.bottom.equalTo(memoryContainer).inset(10)
        }
    }
    
    func setupTableView() {
        view.addSubview(myPageTableView)
        
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
        myPageTableView.layer.cornerRadius = 16
        myPageTableView.clipsToBounds = true
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(memoryContainer.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    @objc func changeImageTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 사용
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func updateSaveVocaCount() {
        if let count = coreDataManager?.getSavedWordCount() {
            saveVocaCount.text = "\(count)개"
        } else {
            saveVocaCount.text = "0개" // 만약 coreDataManager가 nil이면 기본값으로 0개 설정
        }
    }
    
    func updateMemoryVocaCount() {
        if let count = coreDataManager?.getLearnedWordCount() {
            memoryVocaCount.text = "\(count)개"
        } else {
            memoryVocaCount.text = "0개" // 만약 coreDataManager가 nil이면 기본값으로 0개 설정
        }
    }
    
    func updateWordCounts() {
        if let coreDataManager = coreDataManager {
            let savedWordCount = coreDataManager.getSavedWordCount()
            let learnedWordCount = coreDataManager.getLearnedWordCount()
            
            DispatchQueue.main.async { [weak self] in
                self?.saveVocaCount.text = "\(savedWordCount)개"
                self?.memoryVocaCount.text = "\(learnedWordCount)개"
            }
        }
    }
}

extension MyPageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.profileImage.image = image
                    }
                }
            }
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageData.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { fatalError("마이 페이지 테이블 뷰 에러")}
        
        let item = myPageData.items[indexPath.row]
        cell.configure(with: item.title, systemImageName: item.imageName)
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1)
        
        return cell
    }
}

