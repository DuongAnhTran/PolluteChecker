//
//  SearchPickerView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 29/9/2025.
//

import Foundation

import SwiftUI

struct SearchPickerView: View {
    @Binding var selectedCat: SearchCategory
    
    var body: some View {
        Picker("Category", selection: $selectedCat) {
            ForEach(SearchCategory.allCases) { category in
                Text(category.rawValue).tag(category)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
