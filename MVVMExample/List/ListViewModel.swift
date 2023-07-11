//
//  ListViewModel.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 7/07/23.
//

// NetworkManager -> DataSourceManager -> ViewModel


import Foundation
import Combine

class ListViewModel {
    
    private let dataSource: ListDataSourceProtocol
    
    // Utilizamos un `PassthroughSubject` para publicar los cambios en los datos
    private let postsSubject = PassthroughSubject<[ResponseGet], Never>()
    
    // Conversion a AnyPublisher para que solo se puedan suscribir y mas no editar
    var postsPublisher: AnyPublisher<[ResponseGet], Never> {
        return postsSubject.eraseToAnyPublisher()
    }
    
    // MARK: Inyección de dependencias
    init(dataSource: ListDataSourceProtocol) {
        self.dataSource = dataSource
    }

    
    // MARK: SERVICES...
    
    func fetchData() {
        dataSource.fetchDataClosure(completion: { result in
            switch result {
            case .success(let listPost):
                self.postsSubject.send(listPost)
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }

    func postData() {
        let request = RequestPost(document_number: "Post Title", document_type: "Post Body")
        dataSource.postDataClosure(request: request) { result in
            switch result {
            case .success(let success):
                print("succes post user_id : \(success.user_id) y flag_user_state: \(success.flag_user_state)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}
