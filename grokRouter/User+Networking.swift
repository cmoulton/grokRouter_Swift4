//
//  User+Networking.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-29.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation
import Alamofire

extension User {
  static func userByID(_ id: Int, completionHandler: @escaping (User?, Error?) -> Void) {
    let endpoint = User.endpointForID(id)
    guard let url = URL(string: endpoint) else {
      print("Error: cannot create URL")
      let error = BackendError.urlError(reason: "Could not create URL")
      completionHandler(nil, error)
      return
    }
    let urlRequest = URLRequest(url: url)
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: urlRequest, completionHandler: {
      (data, response, error) in
      guard let responseData = data else {
        print("Error: did not receive data")
        completionHandler(nil, error)
        return
      }
      guard error == nil else {
        completionHandler(nil, error!)
        return
      }
      
      let decoder = JSONDecoder()
      do {
        let user = try decoder.decode(User.self, from: responseData)
        completionHandler(user, nil)
      } catch {
        print("error trying to convert data to JSON")
        print(error)
        completionHandler(nil, error)
      }
    })
    task.resume()
  }
}
