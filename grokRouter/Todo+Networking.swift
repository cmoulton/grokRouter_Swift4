//
//  Todo+Networking.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-28.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
  case parsing(reason: String)
}

extension Todo {
  init?(json: [String: Any]) {
    guard let title = json["title"] as? String,
      let userId = json["userId"] as? Int,
      let completed = json["completed"] as? Bool
      else {
        return nil
    }

    let idValue = json["id"] as? Int

    self.init(title: title, id: idValue, userId: userId, completedStatus: completed)
  }

  func toJSON() -> [String: Any] {
    var json = [String: Any]()
    json["title"] = title
    if let id = id {
      json["id"] = id
    }
    json["userId"] = userId
    json["completed"] = completed
    return json
  }

  private static func todoFromResponse(response: DataResponse<Any>) -> Result<Todo> {
    guard response.result.error == nil else {
      // got an error in getting the data, need to handle it
      print(response.result.error!)
      return .failure(response.result.error!)
    }

    // make sure we got JSON and it's a dictionary
    guard let json = response.result.value as? [String: Any] else {
      print("didn't get todo object as JSON from API")
      return .failure(BackendError.parsing(reason:
        "Did not get JSON dictionary in response"))
    }

    // turn JSON in to Todo object
    guard let todo = Todo(json: json) else {
      return .failure(BackendError.parsing(reason:
        "Could not create Todo object from JSON"))
    }
    return .success(todo)
  }

  static func todoByID(id: Int, completionHandler: @escaping (Result<Todo>) -> Void) {
    Alamofire.request(TodoRouter.get(id))
      .responseJSON { response in
        let result = Todo.todoFromResponse(response: response)
        completionHandler(result)
    }
  }

  func save(completionHandler: @escaping (Result<Int>) -> Void) {
    let fields = self.toJSON()
    Alamofire.request(TodoRouter.create(fields))
      .responseJSON { response in
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print(response.result.error!)
          completionHandler(.failure(response.result.error!))
          return
        }

        // make sure we got JSON and it's a dictionary
        guard let json = response.result.value as? [String: Any] else {
          print("didn't get todo object as JSON from API")
          completionHandler(.failure(BackendError.parsing(reason:
            "Did not get JSON dictionary in response")))
          return
        }

        // turn JSON in to Todo object
        guard let idNumber = json["id"] as? Int else {
          completionHandler(.failure(BackendError.parsing(reason:
            "Could not get id number from JSON")))
          return
        }
        completionHandler(.success(idNumber))
    }
  }
}
