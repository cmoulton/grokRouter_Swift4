//
//  ViewController.swift
//  grokRouter
//
//  Created by Christina Moulton on 2018-03-28.
//  Copyright © 2018 Christina Moulton. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  func makeGetCallWithAlamofire() {
    Alamofire.request(TodoRouter.get(1))
      .responseJSON { response in
        // check for errors
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print("error calling GET on /todos/1")
          print(response.result.error!)
          return
        }

        // make sure we got some JSON since that's what we expect
        guard let json = response.result.value as? [String: Any] else {
          print("didn't get todo object as JSON from API")
          if let error = response.result.error {
            print("Error: \(error)")
          }
          return
        }

        // get and print the title
        guard let todoTitle = json["title"] as? String else {
          print("Could not get todo title from JSON")
          return
        }
        print("The title is: " + todoTitle)
    }
  }

  func makePostCallWithAlamofire() {
    let newTodo: [String: Any] = ["title": "My first todo", "completed": false, "userId": 1]
    Alamofire.request(TodoRouter.create(newTodo))
      .responseJSON { response in
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print("error calling POST on /todos/1")
          print(response.result.error!)
          return
        }
        // make sure we got some JSON since that's what we expect
        guard let json = response.result.value as? [String: Any] else {
          print("didn't get todo object as JSON from API")
          if let error = response.result.error {
            print("Error: \(error)")
          }
          return
        }
        // get and print the title
        guard let idNumber = json["id"] as? Int else {
          print("Could not get id number from JSON")
          return
        }
        print("Created todo with id: \(idNumber)")
    }
  }

  func makeDeleteCallWithAlamofire() {
    Alamofire.request(TodoRouter.delete(1))
      .responseJSON { response in
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print("error calling DELETE on /todos/1")
          if let error = response.result.error {
            print("Error: \(error)")
          }
          return
        }
        print("DELETE ok")
    }
  }
}

