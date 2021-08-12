//
//  BookDetailsPresenter.swift
//  Hakbah
//

import Foundation
protocol BookDetailsViewProtocol: class {
    func updateItemQuantity()
}

class BookDetailsPresenter {
    weak private var viewDelegate: BookDetailsViewProtocol?
    var book: BookModel?
    
    init(viewDelegate: BookDetailsViewProtocol) {
        self.viewDelegate = viewDelegate
    }
    
    func updateBookCartData() {
        book?.cartQuantity = getBookCartQuantityIfAvailable()
    }
    
    func addItemQuantity() {
        let updatedQuantiry = (book?.cartQuantity ?? 0) + 1
        if updatedQuantiry <= book?.quantity ?? 0 {
            book?.cartQuantity = updatedQuantiry
        }
        self.viewDelegate?.updateItemQuantity()
    }
    
    func removeItemQuantity() {
        let updatedQuantiry = (book?.cartQuantity ?? 0) - 1
        if updatedQuantiry >= 0 {
            book?.cartQuantity = updatedQuantiry
        }
        self.viewDelegate?.updateItemQuantity()
    }
    
    func getBookCartQuantityIfAvailable() -> Int {
        let books = AppManager.shared.getCartData() ?? []
        if let cartData = books.filter({$0.bookId == book?.bookId}).first {
            return cartData.cartQuantity ?? 0
        }
        
        return book?.cartQuantity ?? 0
    }
    
    func addDataToCart() {
        var books = AppManager.shared.getCartData() ?? []
        if let index = books.firstIndex(where: { $0.bookId == book?.bookId }) {
            if books.count > index, let updateData = book {
                books[index] = updateData
            }
        } else {
            if let updateData = book {
                books.append(updateData)
            }
        }
        
        AppManager.shared.saveCartData(booksData: books)
        self.viewDelegate?.updateItemQuantity()
    }
    
}
