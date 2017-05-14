//
//  PRViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class PRViewController: UIViewController {

    // MARK: Properties
    let cellIdentifier = "PRTableViewCell"
    var pullRequests: [PullRequest]!
    var pullRequestState: PullRequest.State!
    var selectedPullRequest: PullRequest?

    @IBOutlet weak var prTableView: UITableView!
    @IBOutlet weak var prStatusSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Pull Requests"

        prTableView.delegate = self
        prTableView.dataSource = self

        pullRequests = [PullRequest]()
        pullRequestState = .open
        fetchPullRequests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PRDetailsSegue" {
            if let pullRequest = selectedPullRequest,
                let prDetailsViewController = segue.destination as? PRDetailsViewController {
                prDetailsViewController.pullRequest = pullRequest
            }
        }
    }

    @IBAction func prStatusChanged(_ sender: Any) {
        switch prStatusSegmentedControl.selectedSegmentIndex {
        case 0:
            pullRequestState = .open
            fetchPullRequests()
        case 1:
            pullRequestState = .close
            fetchPullRequests()
        case 2:
            pullRequestState = .all
            fetchPullRequests()
        default: break
        }
    }
}

extension PRViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pullRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as? PRTableViewCell
            else {
                return UITableViewCell()
        }
        
        let pullRequest = pullRequests[indexPath.row]
        cell.configureCell(cell: pullRequest.prCell())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPullRequest = pullRequests[indexPath.row]
        performSegue(withIdentifier: "PRDetailsSegue", sender: self)
    }
}

// MARK: PRViewController private methods

extension PRViewController {
    
    fileprivate func fetchPullRequests() {
        let parameters: [String: Any] = ["state": pullRequestState.rawValue]
        pullRequests.removeAll()
        PullRequest.getPullRequests(parameters: parameters) { response in
            switch response.result {
            case .success:
                if let pullRequests = response.result.value {
                    self.pullRequests = pullRequests
                    self.prTableView.reloadData()
                }
            case .failure:
                print("error occurred while fetching data")
            }
        }
    }
}
