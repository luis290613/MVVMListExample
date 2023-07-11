//
//  ListDataSource.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 11/07/23.
//

import Foundation

protocol ListDataSourceProtocol {
    func fetchDataClosure(completion : @escaping (Result<[ResponseGet],NetworkError>) -> Void )
    func postDataClosure(request: RequestPost, completion : @escaping (Result<ResponseDataPost,NetworkError>) -> Void )
}

class ListDataSource: ListDataSourceProtocol {
    
    
    // MARK: Inyección de dependencias
    /// Aquí podemos usar la inyección de depdencias como en ListViewModel
    /// para insertar el NetworkManagerProtocol que sería lo mismo que ListDataSourceProtocol
    init() { }
    
    
    let urlGet = "https://jsonplaceholder.typicode.com/posts"
    
    // MARK: Closure
    func fetchDataClosure(completion : @escaping (Result<[ResponseGet],NetworkError>) -> Void ) {
        NetworkManager.shared.request(urlString: urlGet, method: .get) { result in
            switch result {
            case .success(let responseData):
                
                if let data = responseData {
                    do {
                        print(data.toString())
                        let posts = try data.decode(as: [ResponseGet].self)
                        completion(.success(posts))
                    } catch {
                        completion(.failure(.invalidDecodeData))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postDataClosure(request: RequestPost, completion : @escaping (Result<ResponseDataPost,NetworkError>) -> Void) {
        do {
            let urlPost = "http://localhost:5050/user/flow"
            let postData = try request.encode()
            NetworkManager.shared.request(urlString: urlPost, method: .post, body: postData) { result in
                switch result {
                case .success(let responseData):
                    
                    if let data = responseData {
                        do {
                            print(data.toString())
                            let responsedata = try data.decode(as: ResponseDataPost.self)
                            completion(.success(responsedata))
                        } catch {
                            completion(.failure(.invalidDecodeData))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.invalidEncodeData))
        }
    }
    
}


// MARK: - Mock para pruebas unitariaa, servicios caidos, etc
class ListDataSourceMock : ListDataSourceProtocol {
    
    func fetchDataClosure(completion: @escaping (Result<[ResponseGet], NetworkError>) -> Void) {
        var listResponse : [ResponseGet] = []
        for i in 1...10 {
            listResponse.append(ResponseGet(userId: i, id: i, title: "Mock title \(i)", body: "Mock body \(i)"))
        }
        completion(.success(listResponse))
    }
    
    func postDataClosure(request: RequestPost, completion: @escaping (Result<ResponseDataPost, NetworkError>) -> Void) {
        completion(.success(ResponseDataPost(user_id: "Mock 1", flag_user_state: "MOCK gaaaaaaaa")))
    }
    
}
