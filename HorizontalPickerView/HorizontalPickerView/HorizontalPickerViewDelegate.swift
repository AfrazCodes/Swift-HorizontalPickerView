//
//  HorizontalPickerViewDelegate.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import Foundation

/// Delegate to notify of view events
protocol HorizontalPickerViewDelegate: AnyObject {
    /// Notify receiver of selection change from view
    func horizontalPickerView(
        _ picker: HorizontalPickerView,
        selectedItemDidChangeTo indexPath: IndexPath
    )
}
