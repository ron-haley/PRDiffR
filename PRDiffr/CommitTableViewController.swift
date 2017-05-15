//
//  CommitTableViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class CommitTableViewController: UITableViewController {

    // MARK: Properties
    let cellIdentifier = "CommitTableViewCell"
    var prNumber: Int?
    var commits: [Commit]!
    var activityIndicator: ActivityIndicator?

    @IBOutlet weak var emptyLabelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        commits = [Commit]()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        fetchCommits()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as? CommitTableViewCell
            else {
                return UITableViewCell()
        }
        
        let commit = commits[indexPath.row]
        cell.configureCell(commitCell: commit.commitCell())
        return cell
    }
}

extension CommitTableViewController {
    fileprivate func fetchCommits() {
        guard let number = prNumber else { return }
        
        commits.removeAll()
        emptyLabelView.isHidden = true
        activityIndicator = ActivityIndicator(title: "Loading Commits", center: view.center)
        view.addSubview(activityIndicator!.getActivityIndicatorView())
        activityIndicator?.startAnimating()
        
        Commit.getCommits(prNumber: number) { response in
            switch response.result {
            case .success:
                if let commits = response.result.value {
                    self.activityIndicator?.stopAnimating()

                    if commits.isEmpty {
                        self.emptyLabelView.isHidden = false
                    } else {
                        self.commits = commits
                        self.tableView.reloadData()
                    }
                }
            case .failure:
                self.activityIndicator?.stopAnimating()
                // TODO: Update with error message from response
                let alert = AlertController.alert("", message: "error occurred while fetching data")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
