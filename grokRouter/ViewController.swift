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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    createTodo()
  }

  func fetchTodo() {
    // MARK: Get Todo #1
    Todo.todoByID(id: 1) { result in
      if let error = result.error {
        // got an error in getting the data, need to handle it
        print("error calling GET on /todos/")
        print(error)
        return
      }
      guard let todo = result.value else {
        print("error calling GET on /todos/ - result is nil")
        return
      }
      // success!
      print(todo.description())
      print(todo.title)
    }
  }

  func fetchAllTodos() {
    Todo.allTodos() {
      result in
      print(result)
    }
  }

  func createTodo() {
    // MARK: Create new todo
    guard let newTodo = Todo(title: "My first todo",
                             id: nil,
                             userId: 1,
                             completedStatus: true) else {
                              print("error: newTodo isn't a Todo")
                              return
    }
    newTodo.save() { result in
      guard result.error == nil else {
        // got an error in getting the data, need to handle it
        print("error calling POST on /todos/")
        print(result.error!)
        return
      }
      guard let todoIdValue = result.value else {
        print("error calling POST on /todos/. result is nil")
        return
      }
      // success!
      print(todoIdValue)
    }
  }
}
