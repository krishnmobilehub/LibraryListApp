//
//  BookImageCell.swift
//  Hakbah
//

import UIKit

class BookImageCell: UICollectionViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(url: String) {
        if let image = UIImage(named: url) {
            bookImageView?.image = image
        } else if let image = URL(string: url) {
            bookImageView?.setImageFrom(from: image)
        } else {
            bookImageView?.image = UIImage(named: "bookPlaceholder")
        }
    }
}
