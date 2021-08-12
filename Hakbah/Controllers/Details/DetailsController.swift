//
//  DetailsController.swift
//  Hakbah
//

import UIKit

class DetailsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBooksLabel: UILabel!
    var books: [BookModel]?
    var titleValue: String?
    var isOnline: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 300
        self.title = titleValue ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noBooksLabel.isHidden = (books?.count != 0)
    }
}

extension DetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as? BookCell {
            let bookData = books?[indexPath.row]
            cell.configureCell(bookData)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailsController") as? BookDetailsController {
            bookDetailsViewController.presenter.book = books?[indexPath.row]
            bookDetailsViewController.isAvailableOnline = isOnline
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
}
