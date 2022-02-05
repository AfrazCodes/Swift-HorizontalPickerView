//
//  File.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import Foundation
import UIKit

// Helpers

extension UIView {
    /// Add multiple subviews
    /// - Parameter views: Varidic views
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    /// Top bound of view frame
    var top: CGFloat {
        frame.origin.y
    }

    /// Bottom bound of view frame
    var bottom: CGFloat {
        top + height
    }

    /// Left bound of view frame
    var left: CGFloat {
        frame.origin.x
    }

    /// Right bound of view frame
    var right: CGFloat {
        left + width
    }

    /// Width of view frame
    var width: CGFloat {
        frame.size.width
    }

    /// Height of view frame
    var height: CGFloat {
        frame.size.height
    }
}
