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
import KakaoSDKAuth
import KakaoSDKUser

class LoginModalViewController: UIViewController {
    
    weak var delegate: LoginModalViewControllerDelegate?
    
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
    
    lazy var appleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "kakaologin") {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = #colorLiteral(red: 0.9969366193, green: 0.8984512687, blue: 0.006965545472, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let alertController = AlertController()
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleBtn.addTarget(self, action: #selector(handleAppleIDRequest), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubview(topStackView)
        view.addSubview(viewLine)
        view.addSubview(appleBtn)
        view.addSubview(kakaoLoginButton)
        
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleBtn.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Login with KakaoTalk succeeded.")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.dismiss(animated: true) {
                        self.delegate?.loginStatusDidChange()
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Login with KakaoAccount succeeded.")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.dismiss(animated: true) {
                        self.delegate?.loginStatusDidChange()
                    }
                }
            }
        }
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
//           saveLoginStatus()    //로그인 여부 저장
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
