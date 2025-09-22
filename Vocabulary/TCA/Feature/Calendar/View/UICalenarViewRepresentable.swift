//
//  UICalenarViewRepresentable.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/22/25.
//

import UIKit
import SwiftUI

struct UICalenarViewRepresentable: UIViewRepresentable {
    @Binding var selectedDate: DateComponents?
    let isExpanded: Bool
    let onDateSelected: (DateComponents?) -> Void
    let hasDataForDate: (Date) -> Bool
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.tintColor = ThemeColor.mainColor
        calendarView.fontDesign = .rounded
        calendarView.delegate = context.coordinator
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        selection.selectedDate = selectedDate
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if let selection = uiView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.selectedDate = selectedDate
        }
        
        if let selectedDate = selectedDate {
            uiView.reloadDecorations(forDateComponents: [selectedDate], animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        let parent: UICalenarViewRepresentable
        
        init(_ parent: UICalenarViewRepresentable) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.onDateSelected(dateComponents)
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            if let date = Calendar.current.date(from: dateComponents), parent.hasDataForDate(date) {
                let emojiLabel = UILabel()
                emojiLabel.text = "🐢"
                emojiLabel.textAlignment = .center
                
                let containerView = UIView()
                containerView.addSubview(emojiLabel)
                emojiLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
                ])
                
                return .customView { containerView }
            }
            return nil
        }
    }
}
