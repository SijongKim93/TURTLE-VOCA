//
//  LoginViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/18/24.
//

import UIKit
import SnapKit
import AuthenticationServices
import CryptoKit

class LoginModalViewController: UIViewController {
    
    lazy var appleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    
    let filterMainLabel = LabelFactory().makeLabel(title: "소셜 로그인", size: 23, textAlignment: .left, isBold: true)
    
    let xButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            filterMainLabel,
            xButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LoginDetailTableViewCell.self, forCellReuseIdentifier: LoginDetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let labels = ["카카오 로그인"]
    let alertController = AlertController()
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleBtn.addTarget(self, action: #selector(handleAppleIDRequest), for: .touchUpInside)
        
        setupUI()
    }
    
    func setupUI() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubview(topStackView)
        view.addSubview(viewLine)
        view.addSubview(appleBtn)
        view.addSubview(menuTableView)
        
        xButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        appleBtn.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(115)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(appleBtn.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension LoginModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoginDetailTableViewCell.identifier, for: indexPath) as? LoginDetailTableViewCell else { fatalError("테이블 뷰 오류")}
        
        cell.label.text = labels[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - Apple Signin

extension LoginModalViewController: ASAuthorizationControllerDelegate {
    
    @objc func handleAppleIDRequest() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        let alert = alertController.makeNormalAlert(title: "에러발생", message: "로그인 할 수 없습니다.")
        
        self.present(alert, animated: true)
    }
    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            
//            guard let nonce = currentNonce else {
//                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                return
//            }
//            
//            guard let token = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token")
//                return
//            }
//            
//            guard let tokenString = String(data: token, encoding:  .utf8) else {
//                print("Unable to serialize token string from data: \(token.debugDescription)")
//                return
//            }
//            
//            let oAuthCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
//            
//            Auth.auth().signIn(with: oAuthCredential) { [weak self] (result, error) in
//                
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                
//                self?.dismiss(animated: true)
//                
//            }
//        }
//        
//        
//    }
    
    
    // MARK: - from Firebase Docs
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}
