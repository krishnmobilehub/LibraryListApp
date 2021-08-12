//
//  HomeController.swift
//  Hakbah
//

import UIKit
import CoreLocation
import MapKit

class HomeController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartBarButtonItem: UIBarButtonItem!
    lazy var presenter = HomePresenter(viewDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.getBooksData()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 300
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cartData = AppManager.shared.getCartData()?.count ?? 0
        if cartData > 0 {
            cartBarButtonItem.setBadge(text: "\(cartData)")
        } else {
            cartBarButtonItem.setBadge(text: "", andColor: .clear )
        }
        presenter.updateLibraryList()
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        if let cartViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartController") as? CartController {
            cartViewController.books = AppManager.shared.getCartData()
            self.navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
}

extension HomeController: HomeViewProtocol {
    func finishGettingBookDataWithSuccess() {
        self.tableView.reloadData()
    }
    
    func finishGettingBookDataWithFail(_ message: String) {
        let errorAlert = UIAlertController(title: Alert.error, message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: Alert.ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.libraries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryCell") as? LibraryCell {
            let libraryData = presenter.libraries?[indexPath.row]
            cell.configureCell(libraryData)
            cell.locationButtonClikcedCompletion = {
                if let lat = libraryData?.gps?.lat, let long = libraryData?.gps?.long, lat != 0.0, long != 0.0 {
                    let coordinate = CLLocationCoordinate2DMake(lat, long)
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                    mapItem.name = libraryData?.name ?? ""
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsController") as? DetailsController {
            detailsViewController.books = presenter.libraries?[indexPath.row].books
            detailsViewController.titleValue = presenter.libraries?[indexPath.row].name ?? ""
            detailsViewController.isOnline = presenter.libraries?[indexPath.row].type == .online
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
