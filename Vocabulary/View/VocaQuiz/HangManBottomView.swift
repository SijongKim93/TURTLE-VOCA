//
//  HangManBottomView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/16/24.
//

import UIKit
import SnapKit

class HangManBottomView: UIView {
    
    
    lazy var buttonA = ButtonFactory().makeButton(title: "A") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonB = ButtonFactory().makeButton(title: "B") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonC = ButtonFactory().makeButton(title: "C") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonD = ButtonFactory().makeButton(title: "D") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonE = ButtonFactory().makeButton(title: "E") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonF = ButtonFactory().makeButton(title: "F") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonG = ButtonFactory().makeButton(title: "G") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var firstHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonA,
            buttonB,
            buttonC,
            buttonD,
            buttonE,
            buttonF,
            buttonG
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var buttonH = ButtonFactory().makeButton(title: "H") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonI = ButtonFactory().makeButton(title: "I") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonJ = ButtonFactory().makeButton(title: "J") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonK = ButtonFactory().makeButton(title: "K") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonL = ButtonFactory().makeButton(title: "L") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonM = ButtonFactory().makeButton(title: "M") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonN = ButtonFactory().makeButton(title: "N") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var secondHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonH,
            buttonI,
            buttonJ,
            buttonK,
            buttonL,
            buttonM,
            buttonN
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var buttonO = ButtonFactory().makeButton(title: "O") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonP = ButtonFactory().makeButton(title: "P") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonQ = ButtonFactory().makeButton(title: "Q") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonR = ButtonFactory().makeButton(title: "R") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonS = ButtonFactory().makeButton(title: "S") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonT = ButtonFactory().makeButton(title: "T") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonU = ButtonFactory().makeButton(title: "U") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var thirdHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonO,
            buttonP,
            buttonQ,
            buttonR,
            buttonS,
            buttonT,
            buttonU
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var buttonV = ButtonFactory().makeButton(title: "V") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonW = ButtonFactory().makeButton(title: "W") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonX = ButtonFactory().makeButton(title: "X") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonY = ButtonFactory().makeButton(title: "Y") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    lazy var buttonZ = ButtonFactory().makeButton(title: "Z") { [weak self] button in
        self?.checkWord(button: button)
    }
    
    
    lazy var forthHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            buttonV,
            buttonW,
            buttonX,
            buttonY,
            buttonZ,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstHStackView,
            secondHStackView,
            thirdHStackView,
            forthHStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        
    }
    
    func checkWord(button: UIButton) {
        guard let currentVC = currentViewController as? HangManGameViewController else { return }
        guard let text = button.currentTitle?.lowercased() else { return }
        if currentVC.answer.contains(text) {
            if currentVC.isGameEnd == false {
                currentVC.guessAnswer(alphabet: Character(text))
                button.isEnabled = false
                button.setTitle("", for: .normal)
                button.backgroundColor = .blue
                button.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
        } else {
            if currentVC.isGameEnd == false {
                button.isEnabled = false
                button.setTitle("", for: .normal)
                button.backgroundColor = .red
                button.setImage(UIImage(systemName: "xmark"), for: .normal)
                currentVC.failCount += 1
                currentVC.updateUI()
            }
        }
    }
    
    deinit {
        vStackView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout () {
        self.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    
}
