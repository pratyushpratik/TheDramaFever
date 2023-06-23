//
//  CVCMovieList.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 22/06/23.
//

/**
 MARK: Importing modules
 */
import UIKit

/**
 MARK: CVCMovieList
 - Defination of class CVCMovieList.
 */
class CVCMovieList: UICollectionViewCell {

    //outlets
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var constraintTrailingLblName: NSLayoutConstraint?
    
    //storage slots
    var model: ResponseModelContent? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.lblName.text = self.model?.name
                if self.lblName.isTruncatedOrNot() {
                    self.constraintTrailingLblName?.isActive = false
                    self.lblName.startMarqueeLabelAnimation()
                } else {
                    self.constraintTrailingLblName?.isActive = true
                }
                self.imgView.image = UIImage(named: self.model?.posterImage ?? "placeholder_for_missing_posters") ?? UIImage(named: "placeholder_for_missing_posters")
            }
        }
    }
}
