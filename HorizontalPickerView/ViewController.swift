//
//  ViewController.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import UIKit

/// Example usage
class ViewController: UIViewController {

    /// Picker View
    private let picker = HorizontalPickerView()

    private var data = [[String]]()

    private let style: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        // setup view
        view.backgroundColor = .systemBackground
        picker.datasource = self
        picker.delegate = self
        view.addSubview(picker)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        picker.frame = CGRect(x: 0, y: 0, width: view.width, height: 223)
        picker.center = view.center
    }

    /// Sets up data
    private func setUpData() {
        for _ in 0..<3 {
            var row = [String]()
            let rand = Int.random(in: 10...40)
            for j in 1..<rand {
                row.append("Item \(j)")
            }
            data.append(row)
        }
    }
}

// MARK: - HorizontalPickerViewDatasource

extension ViewController: HorizontalPickerViewDatasource {
    func numberOfRows() -> Int {
        data.count
    }

    func numberOfItems(in picker: HorizontalPickerView, for row: Int) -> Int {
        data[row].count
    }

    func horizontalPickerView(_ picker: HorizontalPickerView, attributedTitleAt indexPath: IndexPath) -> NSAttributedString? {
        let title = data[indexPath.section][indexPath.row]
        return NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .kern: NSNumber(value: 3),
            .paragraphStyle: style
        ])
    }
}

// MARK: - HorizontalPickerViewDelegate

extension ViewController: HorizontalPickerViewDelegate {
    func horizontalPickerView(_ picker: HorizontalPickerView, selectedItemDidChangeTo indexPath: IndexPath) {
        print("Selected item: \(indexPath.row) in row: \(indexPath.section)")
    }
}
