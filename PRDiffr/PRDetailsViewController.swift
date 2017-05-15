//
//  PRDetailsViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class PRDetailsViewController: UIViewController {

    // MARK: Properties
    var pullRequest: PullRequest?
    var conversationViewController: ConversationTableViewController!
    var commitViewController: CommitTableViewController!
    var diffViewController: PRDiffTableViewController!

    var selectedViewController: UITableViewController? {
        didSet {
            removeViewFromContainer(oldValue)
            addViewToContainer()
        }
    }

    @IBOutlet weak var prTitleLabel: UILabel!
    @IBOutlet weak var prNumberLabel: UILabel!
    @IBOutlet weak var prDetailsContainerView: UIView!
    @IBOutlet weak var prDetailsSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard
            let conversationVC = storyboard?.instantiateViewController(withIdentifier: "ConversationTableViewController") as? ConversationTableViewController,
            let commitVC = storyboard?.instantiateViewController(withIdentifier: "CommitTableViewController") as? CommitTableViewController,
            let diffVC = storyboard?.instantiateViewController(withIdentifier: "PRDiffTableViewController") as? PRDiffTableViewController
        else { return }

        conversationViewController = conversationVC
        commitViewController = commitVC
        diffViewController = diffVC

        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func prDetailsChanged(_ sender: Any) {
        switch prDetailsSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedViewController = diffViewController
        case 1:
            selectedViewController = commitViewController
        case 2:
            selectedViewController = conversationViewController
        default:
            break
        }
    }
}

// MARK: PRDetailsViewController private methods
extension PRDetailsViewController {

    fileprivate func addViewToContainer() {
        if let vc = selectedViewController {
            addChildViewController(vc)
            vc.view.frame = prDetailsContainerView.bounds
            prDetailsContainerView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }

    fileprivate func removeViewFromContainer(_ viewController: UITableViewController?) {
        if let vc = viewController {
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }

    fileprivate func setupView() {
        guard
            let pullRequest = pullRequest,
            let prNumber = pullRequest.number,
            let prTitle = pullRequest.title
        else { return }
        
        title = "#\(prNumber)"

        conversationViewController.prNumber = prNumber
        commitViewController.prNumber = prNumber
        diffViewController.pullRequest = pullRequest

        prTitleLabel.text = prTitle
        prNumberLabel.text = "#\(prNumber)"

        selectedViewController = diffViewController
    }
}
