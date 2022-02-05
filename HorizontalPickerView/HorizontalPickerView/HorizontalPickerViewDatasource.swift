//
//  HorizontalPickerViewDatasource.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import Foundation

/// PickerView dataSource to provide data
protocol HorizontalPickerViewDatasource: AnyObject {
    /// Number of rows to render
    /// - Returns: Row count
    func numberOfRows() -> Int

    /// Number of items to render in each row
    /// - Returns: Item count
    func numberOfItems(in picker: HorizontalPickerView, for row: Int) -> Int

    /// Attributed title to render in a given item at `IndexPath`
    /// - Returns: Attributed String
    func horizontalPickerView(
        _ picker: HorizontalPickerView,
        attributedTitleAt indexPath: IndexPath
    ) -> NSAttributedString?
}
