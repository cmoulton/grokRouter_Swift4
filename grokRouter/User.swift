//
//  User.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-29.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation

struct User {
  let id: Int?
  let name: String
  var email: String
  let city: String
  let zipcode: String

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case address
  }

  enum AddressKeys: String, CodingKey {
    case city
    case zipcode
  }

  // MARK: URLs
  static func endpointForID(_ id: Int) -> String {
    return "https://jsonplaceholder.typicode.com/users/\(id)"
  }
}

extension User: Decodable {
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let id = try values.decodeIfPresent(Int.self, forKey: .id)
    let name = try values.decode(String.self, forKey: .name)
    let email = try values.decode(String.self, forKey: .email)

    let addressValues = try values.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
    let city = try addressValues.decode(String.self, forKey: .city)
    let zipcode = try addressValues.decode(String.self, forKey: .zipcode)

    self.init(id: id, name: name, email: email, city: city, zipcode: zipcode)
  }
}

extension User: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(email, forKey: .email)
  }
}
