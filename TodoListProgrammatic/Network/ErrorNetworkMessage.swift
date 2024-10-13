//
//  ErrorNetworkMessage.swift
//  TodoListProgrammatic
//
//  Created by MacBook Difta on 13/10/24.
//

enum ErrorNetworkMessage: String, Error{
    case dataError = "Data from Network is Error, check your connection and try again."
    case responseError = "Invalid Reponse, check your connection and try again."
    case unknownError = "Something bad happen, try again later."
}
