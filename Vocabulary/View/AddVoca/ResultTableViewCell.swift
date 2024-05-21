//
//  ResultTableViewCell.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/21/24.
//

import UIKit
import SnapKit

class ResultTableViewCell: UITableViewCell {

    lazy var wordLabel = LabelFactory().makeLabel(title: "Category", size: 20, isBold: true)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(wordLabel)
        
        wordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

    }

}
