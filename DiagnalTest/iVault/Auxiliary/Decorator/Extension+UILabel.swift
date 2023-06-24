//
//  Extension+UILabel.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 23/06/23.
//

/**
 MARK: Importing modules
 */
import UIKit

//extension of UILabel
extension UILabel {
    
    //method for scrolling animation of label
    func startMarqueeLabelAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 10.0, delay: 2.0, options: ([.curveLinear, .repeat]), animations: {() -> Void in
                self.center = CGPoint(x: 0 - self.bounds.size.width / 2, y: self.center.y)
            }, completion:  nil)
        }
    }
    
    //method to check number of lines of a label at runtime
    func countLabelLines() -> Int {
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    //method to check number of if the label is truncated or not at runtime
    func isTruncatedOrNot() -> Bool {
        return self.countLabelLines() > self.numberOfLines
    }
}
