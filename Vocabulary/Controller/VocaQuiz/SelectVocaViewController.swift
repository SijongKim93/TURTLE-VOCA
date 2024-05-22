//
//  SelectVocaViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/20/24.
//

import UIKit
import SnapKit

class SelectVocaViewController: UIViewController {
    
    var selectHeaderView = SelectHeaderView()
    var selectBodyView = SelectBodyView()
    var selectBottomView = SelectBottomView()

    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            selectHeaderView,
            selectBodyView,
            selectBottomView,
            UIView()
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    var quizCount = 1
    var selectedCategory = ""
    var category = [String]()
    var receivedData: GenQuizModel?
    let alertController = AlertController()
    var checkList = [WordEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 25
        
        layout()
        
        selectBodyView.numberLabel.text = quizCount.stringValue
        setup()
        getCategory()
        if !category.isEmpty {
            selectedCategory = category[0] // picker 움직임이 없을때.
        }
        
    }
    
    func checkDataCount(query: String) -> Int {
        var count = 0
        checkList = CoreDataManager.shared.getSpecificData(query: query, onError: {[unowned self] error in
            let alert = alertController.makeNormalAlert(title: "에러발생", message: "\(error.localizedDescription)가 발생했습니다.")
            self.present(alert, animated: true)
        })
        count = checkList.count
        return count
    }
    
    private func getCategory () {
        category = Array(Set(CoreDataManager.shared.getWordList().map{ $0.bookCaseName! }).sorted(by: <))
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        selectBodyView.snp.makeConstraints {
            $0.top.equalTo(selectHeaderView.snp.bottom)
        }
        
        selectBottomView.snp.makeConstraints {
            $0.top.equalTo(selectBodyView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
