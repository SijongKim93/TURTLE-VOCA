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
import ProgressHUD

class MyPageViewController: UIViewController {
    
    let myPageData = MyPageData()
    var coreDataManager: CoreDataManager?
    
    //MARK: - Component 호출
    let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "logoresize")
        image.contentMode = .scaleAspectFit
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
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let memoryVocaImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "memoryvoca")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let gamePlayImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "game")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let saveVocaLabel = LabelFactory().makeLabel(title: "저장 된 단어", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let saveVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateSaveVocaCount))개", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 23, textAlignment: .center, isBold: true)
    let memoryVocaLabel = LabelFactory().makeLabel(title: "외운 단어", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let memoryVocaCount = LabelFactory().makeLabel(title: "\(String(describing: updateMemoryVocaCount))", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 23, textAlignment: .center, isBold: true)
    let gamePlayLabel = LabelFactory().makeLabel(title: "게임 진행 수", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 17, textAlignment: .center, isBold: true)
    let gamePlayCount = LabelFactory().makeLabel(title: "0회", color: #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1), size: 23, textAlignment: .center, isBold: true)
    
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
    
    // GameCount
    var gameCount: Int = 0
    
    //MARK: - ViewDidLoad
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
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWordCounts()
        
        //getUserData()
    }
    
    //MARK: - Setup
    func setupUI() {
        view.addSubview(logoImage)
        view.addSubview(profileContainer)
        view.addSubview(allCountStackView)
        
        profileContainer.layer.cornerRadius = 16
        profileContainer.clipsToBounds = true
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(170)
            $0.height.equalTo(90)
        }
        
        profileContainer.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(150)
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
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func reloadTableView() {
        myPageTableView.reloadData()
    }
    
    //MARK: - 단어 갯수 카운트
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
    
    //MARK: - 단어 갯수 업데이트
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

//MARK: - TableView delegate, dataSource
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageData.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    //MARK: - 로그인 여부에 따라 로그인 , 로그아웃 값 저장
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
    
    //MARK: - 테이블 뷰 인덱스 별 호출 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
//        case 0:
//            print(index)
//        case 1:
//            print(index)
//        case 2:
//            print(index)
//        case 3:
//            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//            let alertController = AlertController()
//            
//            if isLoggedIn {
//                let alert = alertController.makeAlertWithCompletion(title: "로그아웃", message: "로그아웃 하시겠습니까?") { [weak self] _ in
//                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
//                    self?.reloadTableView()
//                }
//                present(alert, animated: true, completion: nil)
//            } else {
//                let loginModelVC = LoginModalViewController()
//                loginModelVC.modalPresentationStyle = .custom
//                loginModelVC.transitioningDelegate = self
//                loginModelVC.delegate = self
//                present(loginModelVC, animated: true, completion: nil)
//            }
        case 0:
            CoreDataManager.shared.checkiCloudLoginStatus { loginStatus in
                if loginStatus {
                    ProgressHUD.animate("데이터를 저장하는 중 입니다.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        CoreDataManager.shared.syncData()
                        ProgressHUD.succeed("데이터 저장에 성공했습니다.")
                    }
                } else {
                    ProgressHUD.failed("데이터 저장에 실패했습니다.")
                }
            }
            
        case 1:
            CoreDataManager.shared.checkiCloudLoginStatus { loginStatus in
                if loginStatus {
                    ProgressHUD.animate("데이터를 가져오는 중 입니다.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        CoreDataManager.shared.syncDataFromCloudKit()
                        ProgressHUD.succeed("데이터를 불러오는데 성공했습니다.")
                    }
                } else {
                    ProgressHUD.failed("데이터 불러오기에 실패했습니다.")
                }
            }
        case 2:
            CoreDataManager.shared.checkiCloudLoginStatus { loginStatus in
                if loginStatus {
                    DispatchQueue.main.async{
                        let alert = AlertController().makeAlertWithCompletion(title: "삭제하시겠습니까?", message: "삭제하시면 복구 하실 수 없습니다.") { _ in
                            ProgressHUD.animate("데이터를 삭제합니다.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                CoreDataManager.shared.deleteAllCloudKitData()
                                ProgressHUD.succeed("Cloud 초기화가 완료되었습니다.")
                            }
                        }
                        self.present(alert, animated: true)
                    }
                } else {
                    ProgressHUD.failed("데이터 삭제에 실패했습니다.")
                }
            }
        default :
            return
        }
    }
}

//MARK: - 커스텀 뷰 호출 메서드
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

extension MyPageViewController: SendCount {
    func sendData(count: Int) {
        gameCount = count
        print(gameCount)
        DispatchQueue.main.async {
            self.gamePlayCount.text = "\(self.gameCount)회"
        }
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

