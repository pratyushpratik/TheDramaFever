//
//  VCHome.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 24/06/23.
//

/**
 MARK: Importing modules
 */
import UIKit

/**
 MARK: VCHome
 - Defination of class VCHome.
 */
class VCHome: UIViewController {
    
    @IBAction func btnAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCMovieList") as? VCMovieList else { return }
        vc.backButtonTitle = "Romantic Comedy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
