//
//  User.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-29.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation

struct Address: Codable {
  let city: String
  let zipcode: String
}

struct User: Codable {
  let id: Int?
  let name: String
  let email: String
  let address: Address

  // MARK: URLs
  static func endpointForID(_ id: Int) -> String {
    return "https://jsonplaceholder.typicode.com/users/\(id)"
  }
}
