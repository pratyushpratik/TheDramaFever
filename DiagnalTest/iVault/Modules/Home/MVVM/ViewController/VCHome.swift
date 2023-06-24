//
//  VCHome.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 24/06/23.
//

import UIKit

class VCHome: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCMovieList") as? VCMovieList else { return }
        vc.backButtonTitle = "Romantic Comedy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
