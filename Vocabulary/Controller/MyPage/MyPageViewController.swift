//
//  MyPageViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import PhotosUI
import AuthenticationServices
import CloudKit

class MyPageViewController: UIViewController {
    
    let myPageData = MyPageData()
    var coreDataManager: CoreDataManager?
    
    let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "logoresize")
        return image
    }()
    
    let profileContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
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
    
    let saveVocaLabel = LabelFactory().makeLabel(title: "저장 된 단어", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let saveVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateSaveVocaCount))개", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 25, textAlignment: .center, isBold: true)
    let memoryVocaLabel = LabelFactory().makeLabel(title: "외운 단어", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let memoryVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateMemoryVocaCount))", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 25, textAlignment: .center, isBold: true)
    let gamePlayLabel = LabelFactory().makeLabel(title: "게임 진행 수", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let gamePlayCount = LabelFactory().makeLabel(title: "3회", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 25, textAlignment: .center, isBold: true)
    
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
        stackView.spacing = 25
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
        tableView.backgroundColor = .white
        tableView.layer.borderColor = ThemeColor.mainColor.cgColor
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
        //getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWordCounts()
        //getUserData()
    }
    
    func setupUI() {
        view.addSubview(logoImage)
        view.addSubview(profileContainer)
        view.addSubview(allCountStackView)
        
        profileContainer.layer.cornerRadius = 16
        profileContainer.clipsToBounds = true
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(170)
            $0.height.equalTo(90)
        }
        
        profileContainer.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(180)
        }
        
        allCountStackView.snp.makeConstraints {
            $0.top.equalTo(profileContainer.snp.top).offset(20)
            $0.bottom.equalTo(profileContainer.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTableView() {
        view.addSubview(myPageTableView)
        
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
        myPageTableView.layer.cornerRadius = 16
        myPageTableView.clipsToBounds = true
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(profileContainer.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func reloadTableView() {
        myPageTableView.reloadData()
    }
    
    func updateSaveVocaCount() {
        if let count = coreDataManager?.getSavedWordCount() {
            saveVocaCount.text = "\(count)개"
        } else {
            saveVocaCount.text = "0개"
        }
    }
    
    func updateMemoryVocaCount() {
        if let count = coreDataManager?.getLearnedWordCount() {
            memoryVocaCount.text = "\(count)개"
        } else {
            memoryVocaCount.text = "0개"
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

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageData.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { fatalError("마이 페이지 테이블 뷰 에러")}
        
        var item = myPageData.items[indexPath.row]
        cell.configure(with: item.title, systemImageName: item.imageName)
        
        if indexPath.row == 3 {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            item = isLoggedIn ? ("로그아웃", "lock.open") : ("로그인", "lock")
            cell.configure(with: item.title, systemImageName: item.imageName)
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            print(index)
        case 1:
            print(index)
        case 2:
            print(index)
        case 3:
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            let alertController = AlertController()
            
            if isLoggedIn {
                let alert = alertController.makeAlertWithCompletion(title: "로그아웃", message: "로그아웃 하시겠습니까?") { [weak self] _ in
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    self?.reloadTableView()
                }
                present(alert, animated: true, completion: nil)
            } else {
                let loginModelVC = LoginModalViewController()
                loginModelVC.modalPresentationStyle = .custom
                loginModelVC.transitioningDelegate = self
                loginModelVC.delegate = self
                present(loginModelVC, animated: true, completion: nil)
            }
        case 4:
            CoreDataManager.shared.syncData()
        case 5:
            DispatchQueue.main.async {
                CoreDataManager.shared.syncDataFromCloudKit()
            }
        default :
            return
        }
    }
}

extension MyPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if let loginPresentationController = presented as? LoginModalViewController {
            return LoginPresentationController(presentedViewController: loginPresentationController, presenting: presenting)
        } else {
            return nil
        }
    }
}

protocol LoginModalViewControllerDelegate: AnyObject {
    func loginStatusDidChange()
}

extension MyPageViewController: LoginModalViewControllerDelegate {
    func loginStatusDidChange() {
        reloadTableView()
    }
}

//extension MyPageViewController {
//
//    func getUserData() {
//        if let user = Auth.auth().currentUser {
//            let uid = user.uid
//            let email = user.email
//
//            DispatchQueue.main.async{ [weak self] in
//                self?.subLabel.text = uid
//                self?.mailLabel.text = email
//            }
//
//        }
//    }
//}

