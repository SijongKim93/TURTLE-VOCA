//
//  Picker+Extension.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/21/24.
//

import UIKit

extension SelectVocaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setup () {
        selectBodyView.bookPicker.delegate = self
        selectBodyView.bookPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = category[row]
    }
    
}
