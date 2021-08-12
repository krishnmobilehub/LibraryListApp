//
//  HomePresenter.swift
//  Hakbah
//

import Foundation
protocol HomeViewProtocol: class {
    func finishGettingBookDataWithSuccess()
    func finishGettingBookDataWithFail(_ message: String)
}

class HomePresenter {
    weak private var viewDelegate: HomeViewProtocol?
    var libraries: [LibraryList]?
    
    init(viewDelegate: HomeViewProtocol) {
        self.viewDelegate = viewDelegate
    }
    
    func getBooksData() {
        AppManager.shared.getAllBooks { (success, result) in
            if success {
                self.libraries = (result as? LibraryModel)?.libraries
                self.viewDelegate?.finishGettingBookDataWithSuccess()
            } else {
                self.viewDelegate?.finishGettingBookDataWithFail((result as? String) ?? "Something went wrong")
            }
        }
    }
    
    func updateLibraryList() {
        let cartData = AppManager.shared.getCartData()
        for library in self.libraries ?? [] {
            for book in library.books ?? [] {
                if let index = cartData?.firstIndex(where: { $0.bookId == book.bookId }) {
                    if cartData?.count ?? 0 > index {
                        book.cartQuantity = cartData?[index].cartQuantity
                    }
                } else {
                    book.cartQuantity = 0
                }
            }
        }
    }
}
