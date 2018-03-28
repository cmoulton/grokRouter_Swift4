//
//  Alamofire+Codable.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-28.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation
import Alamofire

extension JSONDecoder {
  func decodeResponse<T: Decodable>(_ type: T.Type, from response: DataResponse<Data>) -> Result<T> {
    guard response.error == nil else {
      // got an error in getting the data, need to handle it
      print(response.error!)
      return .failure(response.error!)
    }
    
    // make sure we got JSON and it's a dictionary
    guard let responseData = response.data else {
      print("didn't get any data from API")
      return .failure(BackendError.parsing(reason:
        "Did not get data in response"))
    }

    // turn data into Todo
    do {
      let todo = try self.decode(type, from: responseData)
      return .success(todo)
    } catch {
      print("error trying to convert data to JSON")
      print(error)
      return .failure(error)
    }
  }
}
