//
//  PRDiffTableViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit
import Alamofire

class PRDiffTableViewController: UITableViewController {

    // MARK: Properties
    let cellIdentifier = "PRDiffTableViewCell"

    var pullRequest: PullRequest?
    var activityIndicator: ActivityIndicator?
    var diffObjects: [DiffObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        diffObjects = [DiffObject]()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        fetchPRDiffs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return diffObjects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let diffOject = diffObjects[section]
        return diffOject.diffCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as? PRDiffTableViewCell
            else {
                return UITableViewCell()
        }

        let diffObject = diffObjects[indexPath.section]
        cell.configureCell(diffCell: diffObject.diffCells[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let diffObject = diffObjects[section]
        return diffObject.fileName
    }
}

extension PRDiffTableViewController {
    fileprivate func fetchPRDiffs() {
        guard let diffUrl = pullRequest?.diffUrl else { return }

        diffObjects.removeAll()

        activityIndicator = ActivityIndicator(title: "Loading Diffs", center: view.center)
        view.addSubview(activityIndicator!.getActivityIndicatorView())
        activityIndicator?.startAnimating()
        
        Alamofire.request(diffUrl)
            .responseData { response in
                switch response.result {
                case .success:
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        self.activityIndicator?.stopAnimating()
                        var parser = Parser(utf8Text)
                        self.diffObjects = parser.buildDiffObject()
                        
                        self.tableView.reloadData()
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
