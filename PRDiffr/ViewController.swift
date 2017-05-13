//
//  ViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/11/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PullRequest.getPullRequests { response in
            switch response.result {
            case .success:
                if let pullRequests = response.result.value {
                    for pullRequest in pullRequests {
                        print("title: \(pullRequest.title!)")
                        print("body:  \(pullRequest.body!)")
                        print("number: \(pullRequest.number!)")
                        print("id: \(pullRequest.id!)")
                        print("created_at: \(pullRequest.createdAt)")
                    }
                }
            case .failure:
                print("Failed request")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

