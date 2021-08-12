//
//  CartController.swift
//  Hakbah
//

import UIKit

class CartController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBooksLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    var books: [BookModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 300
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateListUI()
    }
    
    private func updateListUI() {
        self.noBooksLabel.isHidden = ((books?.count ?? 0) != 0)
        self.bottomView.isHidden = ((books?.count ?? 0) == 0)
        self.tableView.reloadData()
        
        var total: Double = 0.0
        for book in books ?? [] {
            total += Double(book.cartQuantity ?? 0) * (book.price ?? 0.0)
        }
        totalValueLabel.text = "\(total)"
    }
    
    @IBAction func checkoutClicked(_ sender: Any) {
        let errorAlert = UIAlertController(title: Alert.title, message: Alert.comingSoon, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: Alert.ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell {
            let bookData = books?[indexPath.row]
            cell.configureCell(bookData)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailsController") as? BookDetailsController {
            bookDetailsViewController.presenter.book = books?[indexPath.row]
            bookDetailsViewController.isFromCart = true
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if books?.count ?? 0 > indexPath.row {
                books?.remove(at: indexPath.row)
                updateListUI()
                AppManager.shared.saveCartData(booksData: books ?? [])
            } else {
                AppManager.shared.removeCartData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
