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

  static func todoByID(id: Int, completionHandler: @escaping (Result<Todo>) -> Void) {
    Alamofire.request(TodoRouter.get(id))
      .responseData { response in
        let result = Todo.todoFromCodableResponse(response)
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

  private static func todoFromCodableResponse(_ response: DataResponse<Data>) -> Result<Todo> {
    guard response.result.error == nil else {
      // got an error in getting the data, need to handle it
      print(response.result.error!)
      return .failure(response.result.error!)
    }

    // make sure we got JSON and it's a dictionary
    guard let responseData = response.result.value else {
      print("didn't get any data from API")
      return .failure(BackendError.parsing(reason:
        "Did not get data in response"))
    }

    // turn data into Todo
    let decoder = JSONDecoder()
    do {
      let todo = try decoder.decode(Todo.self, from: responseData)
      return .success(todo)
    } catch {
      print("error trying to convert data to JSON")
      print(error)
      return .failure(error)
    }
  }

}
