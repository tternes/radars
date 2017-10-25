//
//  ViewController.swift
//  ReviewPromptBug
//
//  Created by Thaddeus Ternes on 10/24/17.
//  Copyright © 2017 Evening Indie. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // An asynchronous process completes, which causes the review prompt to display
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            print("displaying the first review prompt")
            SKStoreReviewController.requestReview()
        }

        // Then later, another process causes the prompt to be requested again
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0) {
            print("displaying the second review prompt")
            SKStoreReviewController.requestReview()
        }
        
        // Confirm multiple prompts are displayed by having to tap
        // "Not Now" twice to dismiss the prompt
    }
}

