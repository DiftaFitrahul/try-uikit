//
//  Todo.swift
//  TodoListProgrammatic
//
//  Created by MacBook Difta on 13/10/24.
//

import Foundation

struct Todo: Codable{
    let id: String
    let title: String
    let description: String
    let createdAt: String
    
    init(id: String, title: String, description: String, createdAt: String) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
    }
    
    func copy(
        title: String?,
        description: String?
    ) -> Todo{
        return Todo(id: self.id, title: title ?? self.title, description: description ?? self.description, createdAt: self.createdAt)
    }
}


struct PostTodo: Codable{
    let title: String
    let description: String
}
