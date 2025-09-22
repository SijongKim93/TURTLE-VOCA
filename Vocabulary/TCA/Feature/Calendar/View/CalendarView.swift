//
//  CalendarView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/20/25.
//

import ComposableArchitecture
import SwiftUI
import UIKit
import AVFoundation

struct CalendarView: View {
    let store: StoreOf<CalendarReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                calendarSection
                buttonSection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var calendarSection: some View {
        return UICalendarViewRepresentable(
            selectedDate: Binding(
                get: { store.selectedDate },
                set: { store.send(.dateSelected($0)) }
            ),
            isExpanded: store.isCalendarExpanded,
            onDateSelected: { dateComponents in
                store.send(.dateSelected(dateComponents))
            },
            hasDataForDate: { date in
                return true
            }
        )
        .frame(height: store.isCalendarExpanded ? 435 : 0)
        .clipped()
        .animation(.easeInOut(duration: 0.3), value: store.isCalendarExpanded)
        .padding(.horizontal, 10)
        .padding(.top, 44)
    }
    
    private var buttonSection: some View {
        let isExpanded = store.isCalendarExpanded
        
        return HStack {
            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    store.send(.upButtonTapped)
                } label: {
                    Image(systemName: isExpanded ? "arrow.up" : "arrow.down")
                        .foregroundColor(.black)
                }
                
                Button {
                    store.send(.filterButtonTapped)
                } label: {
                    Image("filter")
                }

                Button {
                    store.send(.menuButtonTapped)
                } label: {
                    Image("menu")
                }
            }
            .padding(.trailing, 10)
        }
        .padding(.vertical, 5)
    }
    
    private var wordListSection: some View {
        let isEmpty = store.isEmpty
        
        return ZStack {
            if isEmpty {
                
            }
        }
    }
}
