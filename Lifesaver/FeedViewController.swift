//
//  FeedViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import Parse

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var dogTypeArray = [String]()
    var dogProblemArray = [String]()
    var dogObjectIdArray = [String]()
    var choosenID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Combo-Regular", size: 30)!]
        navigationController?.navigationBar.topItem?.title = "Lifesaver"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(accountButton))
        
        getDataFromParse()
    }
    func getDataFromParse() {
        let query = PFQuery(className: "DogInfo")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else {
                if objects != nil {
                    self.dogTypeArray.removeAll()
                    self.dogProblemArray.removeAll()
                    for object in objects! {
                        if let type = object.object(forKey: "dog_type") as? String {
                            if let problem = object.object(forKey: "dog_problem") as? String {
                                if let id = object.objectId {
                                    self.dogObjectIdArray.append(id)
                                    self.dogTypeArray.append(type)
                                    self.dogProblemArray.append(problem)
                                }
                                
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var  content = cell.defaultContentConfiguration()
        content.text = dogTypeArray[indexPath.row]
        content.secondaryText = dogProblemArray[indexPath.row]
        cell.contentConfiguration = content
        return cell

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenID = dogObjectIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.chosenID = choosenID
        }
    }
    
    
    
    @objc func accountButton () {
        performSegue(withIdentifier: "toAccountVC", sender: nil)
    }
    
    @objc func addButton () {
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }

    
}
