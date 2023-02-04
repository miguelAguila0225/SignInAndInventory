//
//  InventoryViewController.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import UIKit

public enum DetailsMode: Int {
    case add
    case edit
}

class InventoryViewController: UIViewController {
    
    public static let identifier = String(describing: InventoryViewController.self)
    let firebaseAuthManager = FirebaseAuthenticationManager()
    let firestoreManager = FirestoreManager()
    var inventoryItems = [InventoryItem]()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Inventory
        self.navigationController?.navigationBar.isOpaque = true
    }
    
    func getAllInventoryItems() {
        firestoreManager.retrieveAllItems {items, error in
            guard let items = items, error == nil else {
                self.showAlert(title: RetrieveErrorTitle,
                               message: error ?? RetrieveError)
                return
            }
            DispatchQueue.main.async {
                self.inventoryItems = items
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupBarButtonItems()
        setupTableView()
        setupTableViewCell()
    }
    
    func setupBarButtonItems() {
        let signOutButton = makeBarButtonItem(with: SignOut,
                                              style: .plain)
        signOutButton.target = self
        signOutButton.action = #selector(signOut)
        self.navigationItem.leftBarButtonItem = signOutButton
        
        let addItemButton = makeBarButtonItem(with: AddItem,
                                              style: .plain)
        addItemButton.target = self
        addItemButton.action = #selector(didTapAddItem)
        self.navigationItem.rightBarButtonItem = addItemButton
    }
    
    func setupTableView() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
    }
    
    func setupTableViewCell() {
        let nibName = UINib(nibName: InventoryTableViewCell.nibName(), bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: InventoryTableViewCell.identifier)
    }
    
    func makeBarButtonItem(with title: String, style: UIBarButtonItem.Style) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title,
                                     style: style,
                                     target: nil,
                                     action: nil)
        return button
    }
    
    @objc func signOut() {
        firebaseAuthManager.signOutUser { success, error in
            if success == true {
                self.dismiss(animated: true)
            } else {
                self.showAlert(title: SignOutErrorTitle,
                               message: error ?? SignOutError)
            }
        }
    }
    
    @objc func didTapAddItem() {
        presentItemDetailsView(item: nil,
                               delegate: self,
                               mode: .add)
    }
    
    func presentItemDetailsView(item: InventoryItem?, delegate: AddProductDelegate, mode: DetailsMode) {
        let storyboard = UIStoryboard(name: Main, bundle: Bundle.main)
        guard let addItemViewController = storyboard.instantiateViewController(withIdentifier: ItemDetailsViewController.identifier) as? ItemDetailsViewController else { return }
        addItemViewController.delegate = delegate
        addItemViewController.mode = mode
        
        if let item = item {
            addItemViewController.item = item
        }
        let addItemNavigationController = UINavigationController()
        addItemNavigationController.viewControllers = [addItemViewController]
        
        if let sheet = addItemNavigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        DispatchQueue.main.async {
            self.navigationController?.present(addItemNavigationController, animated: true)
        }
    }
}

extension InventoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InventoryTableViewCell.identifier) as! InventoryTableViewCell
        cell.configure(item: self.inventoryItems[indexPath.row],
                       delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension InventoryViewController: AddProductDelegate {
    func didTapAddProduct(item: InventoryItem) {
        let isDuplicate = firestoreManager.isDuplicate(item: item, inventoryItems: inventoryItems)
        if isDuplicate != true {
            firestoreManager.saveItem(item: item,
                                      mode: .add,
                                      completion: { error in
                guard error == nil else {
                    self.showAlert(title: AddProductErrorTitle,
                                   message: error ?? AddProductError)
                    return
                }
                self.getAllInventoryItems()
            })
            
        } else {
            showAlert(title: DuplicateErrorTitle,
                      message: DuplicateErrorTitle)
        }
    }
    
    func didTapEditProduct(item: InventoryItem) {
        firestoreManager.saveItem(item: item, mode: .edit, completion: { error in
            guard error == nil else {
                self.showAlert(title: UpdateErrorTitle,
                               message: error ?? UpdateError)
                return
            }
            self.getAllInventoryItems()
        })
    }
}

extension InventoryViewController: InventoryCellDelegate {
    func didTapEdit(selectedItem: InventoryItem?) {
        self.presentItemDetailsView(item: selectedItem,
                                    delegate: self,
                                    mode: .edit)
    }
    
    func didTapDelete(selectedItem: InventoryItem?) {
        firestoreManager.deleteItem(item: selectedItem) { error in
            guard error == nil else {
                self.showAlert(title: DeleteErrorTitle,
                               message: error ?? DeleteError)
                return
            }
            self.getAllInventoryItems()
        }
    }
}
