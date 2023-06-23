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
    @IBOutlet private weak var constraintTrailingLblName: NSLayoutConstraint!
    
    //storage slots
    var model: ResponseModelMovieList.Page.ContentItems.Content? {
        didSet {
            lblName.text = model?.name
            if lblName.isTruncatedOrNot() {
                constraintTrailingLblName.isActive = false
                lblName.startMarqueeLabelAnimation()
            } else {
                constraintTrailingLblName.isActive = true
            }
            imgView.image = UIImage(named: model?.posterImage ?? "placeholder_for_missing_posters") ?? UIImage(named: "placeholder_for_missing_posters")
        }
    }
}
