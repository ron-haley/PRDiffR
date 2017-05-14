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
            let commitVC = storyboard?.instantiateViewController(withIdentifier: "CommitTableViewController") as? CommitTableViewController
        else { return }

        conversationViewController = conversationVC
        commitViewController = commitVC
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func prDetailsChanged(_ sender: Any) {
        switch prDetailsSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedViewController = conversationViewController
        case 1:
            selectedViewController = commitViewController
        case 2:
            break
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

        prTitleLabel.text = prTitle
        prNumberLabel.text = "#\(prNumber)"

        selectedViewController = conversationViewController
    }
}
