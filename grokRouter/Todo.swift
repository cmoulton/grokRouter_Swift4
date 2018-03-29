//
//  Todo.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-28.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation

struct Todo: Codable {
  var title: String
  var serverId: Int?
  var userId: Int
  var completed: Bool

  init?(title: String, id: Int?, userId: Int, completedStatus: Bool) {
    self.title = title
    self.serverId = id
    self.userId = userId
    self.completed = completedStatus
  }

  enum CodingKeys: String, CodingKey {
    case title
    case serverId = "id"
    case userId
    case completed
  }

  static let endpointForTodos: String = "https://jsonplaceholder.typicode.com/todos/"

  func description() -> String {
    return "ID: \(self.serverId ?? 0), " +
      "User ID: \(self.userId)" +
      "Title: \(self.title)\n" +
    "Completed: \(self.completed)\n"
  }
}
