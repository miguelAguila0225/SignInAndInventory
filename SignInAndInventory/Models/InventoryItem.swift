//
//  InventoryItem.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import Foundation

public struct InventoryItem: Codable, Equatable, Identifiable {
    public var id: String?
    public var productName: String?
    public var stock: Int?
}
