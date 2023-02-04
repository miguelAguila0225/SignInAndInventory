//
//  InventoryTableViewCell.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import UIKit

public protocol InventoryCellDelegate {
    func didTapEdit(selectedItem: InventoryItem?)
    func didTapDelete(selectedItem: InventoryItem?)
}
class InventoryTableViewCell: UITableViewCell {

    class func nibName() -> String {
        return String(describing: InventoryTableViewCell.self)
    }
    public static let identifier = String(describing: InventoryTableViewCell.self)
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    var delegate: InventoryCellDelegate?
    var selectedItem: InventoryItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(item: InventoryItem, delegate: InventoryCellDelegate) {
        updateData(delegate: delegate, item: item)
        updateUI(item: item)
    }
    
    fileprivate func updateData(delegate: InventoryCellDelegate, item: InventoryItem) {
        self.delegate = delegate
        self.selectedItem = item
    }
    
    fileprivate func updateUI(item: InventoryItem) {
        productName.text = ProductTitle + (item.productName ?? EmptyString)
        let stockString = "\(item.stock ?? 0)"
        stock.text = StockTitle + stockString
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        delegate?.didTapEdit(selectedItem: selectedItem)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        delegate?.didTapDelete(selectedItem: selectedItem)
    }
}
