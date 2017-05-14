//
//  ConversationTableViewController.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class ConversationTableViewController: UITableViewController {

    // MARK: Properties
    let cellIdentifier = "CommentTableViewCell"
    var prNumber: Int?
    var comments: [Comment]!
    var activityIndicator: ActivityIndicator?

    @IBOutlet weak var emptyLabelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        comments = [Comment]()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        fetchComments()
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
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as? CommentTableViewCell
            else {
                return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        cell.configureCell(commentCell: comment.commentCell())
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationTableViewController {
    fileprivate func fetchComments() {
        guard let number = prNumber else { return }

        comments.removeAll()
        emptyLabelView.isHidden = true
        activityIndicator = ActivityIndicator(title: "Loading Comments", center: view.center)
        view.addSubview(activityIndicator!.getActivityIndicatorView())
        activityIndicator?.startAnimating()

        Comment.getComments(prNumber: number) { response in
            switch response.result {
            case .success:
                if let comments = response.result.value {
                    self.activityIndicator?.stopAnimating()

                    if comments.isEmpty {
                        self.emptyLabelView.isHidden = false
                    } else {
                        self.comments = comments
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
