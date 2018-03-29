//
//  TodoRouter.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-28.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
  static let baseURLString = "https://jsonplaceholder.typicode.com/"

  case get(Int)
  case getAll
  case create(Data)
  case delete(Int)

  func asURLRequest() throws -> URLRequest {
    var method: HTTPMethod {
      switch self {
      case .get, .getAll:
        return .get
      case .create:
        return .post
      case .delete:
        return .delete
      }
    }

    let body: Data? = {
      switch self {
      case .create(let jsonAsData):
        return jsonAsData
      default:
        return nil
      }
    }()

    let url: URL = {
      // build up and return the URL for each endpoint
      let relativePath: String?
      switch self {
      case .get(let number):
        relativePath = "todos/\(number)"
      case .create, .getAll:
        relativePath = "todos"
      case .delete(let number):
        relativePath = "todos/\(number)"
      }

      var url = URL(string: TodoRouter.baseURLString)!
      if let relativePath = relativePath {
        url = url.appendingPathComponent(relativePath)
      }
      return url
    }()

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.httpBody = body
    return urlRequest
  }
}
