//
//  LoginViewViewModel.swift
//  ExamenCoppel2
//
//  Created by Equipo on 04/09/23.
//

import Foundation

final class LoginViewViewModel {
    
    var didLoginSucces : (()->Void)?
    var didLoginFailed : ((String)->Void)?
    
    public func doLogin(username:String,password:String){
        let parameters = ["username":username,"password":password]
        Networking.shared.doLogin(parameters: parameters) {[weak self] result in
            switch result {
            case .success(let data):
                let session_id = data.session_id
                let params = ["session_id" : session_id]
                self?.getAccountDetail(params: params) { result in
                    switch result {
                    case .success(let userData):
                        let username = userData.username
                        let userId = userData.id
                        self?.saveUserInfo(sessionId: session_id, username:username,id : userId)
                        self?.didLoginSucces?()
                    case .failure(let failure):
                        self?.didLoginFailed?(failure.status_message)
                    }
                }
                
                UserDefaults.standard.username = username
            case .failure(let error):
                self?.didLoginFailed?(error.status_message)
            }
        }
    }
    
    private func saveUserInfo(sessionId: String,username : String,id : Int){
        UserDefaults.standard.token = sessionId
        UserDefaults.standard.username = username
        UserDefaults.standard.id = id
        
    }
    
    private func getAccountDetail(params : [String:Any]? = nil,completion : @escaping (Result<UserDetailResponse,MVTokenError>)->Void){
        Networking.shared.setRequest(route: Route.accountDetail.defaultValue, method: .get, type: UserDetailResponse.self, parameters: params,completion: completion)
    }
    
   
}
