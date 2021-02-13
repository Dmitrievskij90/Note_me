//
//  WelcomeViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 14.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.image = UIImage(named: "pen")
        welcomeView.contentMode = .scaleAspectFit

    }
    

}
