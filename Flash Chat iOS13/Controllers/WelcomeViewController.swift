//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel //install from cocoapods

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel! //change the UILabel to this label that we installed
    
    override func viewWillAppear(_ animated: Bool) { //codes that run JUST before everything shows up on screen
        super.viewWillAppear(animated) //If you override the lifecycle method like viewDidLoad, we must always write the super before writing our own code. This is due to inheritance from UIViewController
        navigationController?.isNavigationBarHidden = true //to hide the nav bar on the welcome screen, which is link to this WelcomeViewController.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false //But we want the nav bar on the other screens. Hence we will set it to appear right after this screen disappear and before the next screen shows up.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using cocoapods libraries to do the text animation
        titleLabel.text = K.appName
        
        
        //typing animation to show the app name upon loading up
//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            print("-")
//            print(0.1 * charIndex)
//            print(letter)
//            //A timer is used to execute the append function after some delay to mimick the typing animation.
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
//                self.titleLabel.text?.append(letter) //show the letter one by one after 0.1sec
//                //inside a closure (anonmous function), we must always add the self keyword
//            }
//            charIndex += 1 // to set up the delay based on the index of each letter in the string.
//        }

    }
    

}
