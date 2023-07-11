//
//  ListModel.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 7/07/23.
//

import Foundation

struct ResponseGet: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct RequestPost: Codable {
    let document_number: String
    let document_type: String
}

struct ResponseDataPost: Codable {
    let user_id: String
    let flag_user_state: String
}
