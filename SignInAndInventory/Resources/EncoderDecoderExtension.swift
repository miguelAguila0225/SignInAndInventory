//
//  EncoderDecoderExtension.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import Foundation
import UIKit
import FirebaseFirestore

public class EncoderHelper {
    func encodeItem(inputItem: InventoryItem) -> [String: Any]
    {
        do{
            let encodedData = try JSONEncoder().encode(inputItem)
            guard let encodedPlayer = try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] else{
                print(SerializationError)
                return [:]
            }
            return encodedPlayer
        }
        catch{
            print(EncodeError)
            return [:]
        }
    }
}

