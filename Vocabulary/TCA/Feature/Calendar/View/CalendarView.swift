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
            let isShowingFilterModal = store.isShowingFilterModal
            let isShowingMenuModal = store.isShowingMenuModal
            
            VStack(spacing: 0) {
                calendarSection
                buttonSection
                
                Divider()
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                
                wordListSection
            }
            .background(Color.white)
            .ignoresSafeArea(.all, edges: .top)
            .onAppear {
                store.send(.fetchWordsForSelectedDate)
                store.send(.loadFilterIndex)
                store.send(.loadDatesWithData)
            }
            .sheet(isPresented: Binding(
                get: { isShowingFilterModal },
                set: { _ in store.send(.filterModalDismissed) }
            )) {
                FilterModeView(store: store)
                    .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: Binding(
                get: { isShowingMenuModal },
                set: { _ in store.send(.menuModalDismissed) }
            )) {
                MenuView(store: store)
                    .presentationDetents([.fraction(0.3)])
            }
        }
    }
    
    private var calendarSection: some View {
        WithPerceptionTracking {
            let selectedDate = store.selectedDate
            let isExpanded = store.isCalendarExpanded
            let datesWithData = store.datesWithData
            
            return UICalendarViewRepresentable(
                selectedDate: Binding(
                    get: { selectedDate },
                    set: { store.send(.dateSelected($0)) }
                ),
                isExpanded: isExpanded,
                onDateSelected: { dateComponents in
                    store.send(.dateSelected(dateComponents))
                },
                hasDataForDate: { date in
                    let dateString = DateFormatter.yyyyMMdd.string(from: date)
                    return datesWithData.contains(dateString)
                }
            )
            .frame(height: isExpanded ? 435 : 0)
            .clipped()
            .animation(.easeInOut(duration: 0.3), value: isExpanded)
            .padding(.horizontal, 10)
            .padding(.top, 44)
        }
    }
    
    private var buttonSection: some View {
        WithPerceptionTracking {
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
    }
    
    private var wordListSection: some View {
        WithPerceptionTracking {
            let isEmpty = store.isEmpty
            let filteredWords = store.filteredWords
            
            return ZStack {
                if isEmpty {
                    EmptyCalendarStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(filteredWords, id: \.objectID) { word in
                                WordRowView(store: store, word: word)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView(
        store: Store(initialState: CalendarReducer.State()) {
            CalendarReducer()
        } withDependencies: {
            $0.coreDataDependency = CoreDataDependency.previewValue
        }
    )
}
