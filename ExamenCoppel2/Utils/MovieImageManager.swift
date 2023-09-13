//
//  MovieImageManager.swift
//  ExamenCoppel2
//
//  Created by Equipo on 09/09/23.
//

import Foundation
import UIKit

final class MovieImageManager {
    private init(){}
    
    static let shared = MovieImageManager()
    
    private var imagesUrl = "https://image.tmdb.org/t/p/w500"
    
    private var fetchedImages = NSCache<NSString,NSData>()
    
    private var totalCacheItems = 0
    
    public func fetchImage(with path : String, completion : @escaping (Result<Data,Error>)->Void){
        
        if fetchedImages.totalCostLimit >= totalCacheItems {
            removeCacheItems()
        }
        
        if let data = fetchedImages.object(forKey: path as NSString) {
            completion(.success(data as Data))
        }
        
        let imageUrl = imagesUrl + path
        
        let data = fetchedImages.object(forKey: path as NSString)
        guard let url = URL(string: imageUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            self.fetchedImages.setObject(data as NSData, forKey: path as NSString)
            completion(.success(data))
            self.totalCacheItems += 1
            
        }.resume()
       
       
        
    }
    private func removeCacheItems(){
        fetchedImages.removeAllObjects()
    }
}
