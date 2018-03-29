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

  func update(completionHandler: @escaping (Error?) -> Void) {
    guard let id = self.id else {
      let error = BackendError.urlError(reason: "No ID provided for PATCH")
      completionHandler(error)
      return
    }
    let endpoint = User.endpointForID(id)
    guard let url = URL(string: endpoint) else {
      let error = BackendError.urlError(reason: "Could not construct URL")
      completionHandler(error)
      return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "PATCH"
    var headers = urlRequest.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    urlRequest.allHTTPHeaderFields = headers

    let encoder = JSONEncoder()
    do {
      let asJSON = try encoder.encode(self)
      urlRequest.httpBody = asJSON
      // See if it's right
      if let bodyData = urlRequest.httpBody {
        print(String(data: bodyData, encoding: .utf8) ?? "no body data")
      }
    } catch {
      print(error)
      completionHandler(error)
    }

    let session = URLSession.shared

    let task = session.dataTask(with: urlRequest) {
      (data, response, error) in
      guard error == nil else {
        let error = error!
        completionHandler(error)
        return
      }
      guard let responseData = data else {
        let error = BackendError.parsing(reason: "No data in response")
        completionHandler(error)
        return
      }

      print(String(data: responseData, encoding: .utf8) ?? "No response data as string")
      completionHandler(nil)
    }
    task.resume()
  }
}
