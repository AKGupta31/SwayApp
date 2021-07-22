//
//  SearchPlannerVC.swift
//  Sway
//
//  Created by Admin on 20/07/21.
//

import UIKit
import ViewControllerDescribable

class SearchPlannerVC: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    var searchHistory:[String]!
    @IBOutlet weak var tableViewPreviousSearches: UITableView!
    var searchAction:((_ searchString:String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        searchHistory =  SwayUserDefaults.shared.searchList
        searchField.delegate = self
        searchField.returnKeyType = .search
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearAllSearches(_ sender: UIButton) {
        searchHistory.removeAll()
        tableViewPreviousSearches.reloadData()
        SwayUserDefaults.shared.searchList = self.searchHistory
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        
    }
}

extension SearchPlannerVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,text.isEmpty == false {
            searchAction?(text)
            searchHistory.append(text)
            SwayUserDefaults.shared.searchList = self.searchHistory
        }else {
            searchAction?("")
        }
        self.navigationController?.popViewController(animated: true)
        
        return true
    }
}

extension SearchPlannerVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count > 3 ? 3 : searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell") as! SearchHistoryCell
        cell.lblTitle.text = searchHistory[indexPath.row]
        cell.selectionStyle = .none
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(crossSearchHistoryItem(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = searchHistory[indexPath.row]
        searchAction?(text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func crossSearchHistoryItem(_ sender:UIButton) {
        searchHistory.remove(at: sender.tag)
        tableViewPreviousSearches.reloadData()
        SwayUserDefaults.shared.searchList = self.searchHistory
    }
    
}


extension SearchPlannerVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.planner
    }
}
