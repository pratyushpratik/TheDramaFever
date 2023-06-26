//
//  Extension+UIBarButtonItem.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 24/06/23.
//

/**
 MARK: Importing modules
 */
import UIKit

//extension of UIBarButtonItem
extension UIBarButtonItem {

    //method for setting up bar button with constraints
    static func setupBarButton(_ target: Any?, action: Selector, imageName: String, size: CGSize = CGSize(width: 16, height: 16), tintColor: UIColor?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.tintColor = tintColor
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        return menuBarItem
    }
}
