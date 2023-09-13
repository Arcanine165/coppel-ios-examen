//
//  Networking.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import Foundation



final class Networking {
    
    private var apiUrl = "https://api.themoviedb.org/3"
    
    private let apiToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxODg0OWRlMDI0ZDEwMTg1YTI5YjRjYjA5NmFjMDEzMyIsInN1YiI6IjY0ODY4ODQyZTI3MjYwMDBhZmMzNDY3NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ebGIe9NwSY5hmqdqSvJF_wSuOLTlOjWiPo5hRe1Zqrw"
    
    private let apiKey = "18849de024d10185a29b4cb096ac0133"
    
    
    static let shared = Networking()
    
    private init(){}
    
    public func doLogin(parameters : [String:Any],completion : @escaping (Result<SessionModelResponse,MVTokenError>)->Void){
        
        getToken() {[weak self] result in
            switch result {
            case .success(let token):
                var params = parameters
                params["request_token"] = token.request_token
                self?.validateLoginWithCredentials(params:params) { result in
                    switch result {
                    case .success(let data):
                        let params = ["request_token":data.request_token]
                        self?.createSession(params:params,completion: { result in
                            switch result {
                            case .success(let response):
                                completion(.success(response))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getToken(completion : @escaping (Result<LoginModelResponse,MVTokenError>)->Void){
        setRequest(route: Route.tokenURL.defaultValue, method: .get, type: LoginModelResponse.self,completion: completion)
    }
    private func validateLoginWithCredentials(params: [String:Any]? = nil,completion : @escaping (Result<LoginModelResponse,MVTokenError>)->Void){
        setRequest(route: Route.loginURL.defaultValue, method: .post, type: LoginModelResponse.self, parameters: params,completion: completion)
    }
    private func createSession(params: [String:Any]? = nil,completion : @escaping (Result<SessionModelResponse,MVTokenError>)->Void){
        setRequest(route: Route.authenticate.defaultValue, method: .post, type: SessionModelResponse.self, parameters: params,completion: completion)

    }
    
    public func setRequest<T:Codable>(route: String, method: Method,type : T.Type, parameters: [String:Any]? = nil,completion : @escaping (Result<T,MVTokenError>)->Void){
        guard let request = createRequest(route: route, method: method,parameters: parameters) else {
            return
        }
        print(request.url)
        URLSession.shared.dataTask(with: request){[weak self] data,response,error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.decodeData(data: data, type: T.self, completion: completion)
            }
            
        }.resume()
       
        
    }
    
    
    private func createRequest(route : String, method : Method, parameters : [String:Any]? = nil ) -> URLRequest? {
        let urlString = apiUrl + route
       
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(apiToken, forHTTPHeaderField: "Authorization")
        if var params = parameters {
            params["api_key"] = apiKey
            switch method {
            case .get:
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents?.queryItems = params.compactMap({ key,value in
                    return URLQueryItem(name: key, value: value as? String)
                })
                urlRequest.url = urlComponents?.url
            case .post:
                let json = try? JSONSerialization.data(withJSONObject: params)
                urlRequest.httpBody = json
            }
        }
        return urlRequest
    }
    private func decodeData<T:Codable>(data : Data, type : T.Type, completion : @escaping ((Result<T,MVTokenError>)->Void)){
        do {
            let data = try JSONDecoder().decode(type, from: data)
            completion(.success(data))
            
        }catch{
            do{
                let error = try JSONDecoder().decode(MVTokenError.self,from: data)
                completion(.failure(error))
            }catch {
                completion( .failure(MVTokenError(success: false, status_code: 0, status_message: "Undefined")))
            }
        }
    }
}
