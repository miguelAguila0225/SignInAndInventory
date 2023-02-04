//
//  AddItemViewController.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import UIKit

public protocol AddProductDelegate {
    func didTapAddProduct(item: InventoryItem)
    func didTapEditProduct(item: InventoryItem)
}
class ItemDetailsViewController: UIViewController {
    
    public static let identifier = String(describing: ItemDetailsViewController.self)
    public var item = InventoryItem()
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var stock: UITextField!
    @IBOutlet weak var addProductButton: UIButton!
    
    let firestoreManager = FirestoreManager()
    var delegate: AddProductDelegate?
    var mode: DetailsMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Item"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    func setupUI() {
        addProductButton.layer.cornerRadius = 10
        productName.autocapitalizationType = .none
        productName.leftViewMode = .always
        productName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        stock.delegate = self
        stock.keyboardType = .numberPad
        stock.leftViewMode = .always
        stock.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        if mode == .edit {
            addProductButton.setTitle("Update Item", for: .normal)
        }
    }
    
    func setupData() {
        if let name = item.productName {
            productName.text = name
        }
        
        if let itemStock = item.stock {
            let stockString = "\(itemStock)"
            stock.text = stockString
        }
    }
    
    @IBAction func didTapAddProduct(_ sender: Any) {
        if mode == .edit {
            self.dismiss(animated: true) {
                if let name = self.productName.text {
                    let updatedItem = self.firestoreManager.updateItem(item: self.item,
                                                                       name: name,
                                                                       stock: self.stock.text )
                    self.delegate?.didTapEditProduct(item: updatedItem )
                } else {
                    self.showAlert(title: "Update Failed", message: "Invalid Item")
                }
                
            }
        } else {
            self.dismiss(animated: true) { [self] in
                var newItem = InventoryItem()
                if let name = self.productName.text, let stock = stock.text {
                    newItem = firestoreManager.createNewItem(name: name, stock: stock)
                    delegate?.didTapAddProduct(item: newItem)
                }
            }
        }
    }
    
}

extension ItemDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = "0123456789"
        let allowedCharacters = CharacterSet(charactersIn: characterSet)
        let typedCharacters = CharacterSet(charactersIn: string)
        let numbers = allowedCharacters.isSuperset(of: typedCharacters)
        return numbers
    }
}
