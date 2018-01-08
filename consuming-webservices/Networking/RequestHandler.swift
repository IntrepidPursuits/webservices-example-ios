//
//  RequestHandler.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum RequestError: Error {
    case requestHandlerNil
    case invalidURL
    case noResponse
    case httpResponse(Int)
    case noData
}

extension RequestError: CustomStringConvertible {
    var description: String {
        switch self {
        case .requestHandlerNil:
            return "No Request Handler"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .httpResponse(let errorCode):
            return "HTTP Response: \(errorCode)"
        case .noData:
            return "No Data Returned"
        }
    }
}

struct HTTPRequestHandler: RequestHandler {
    var path: String
    var method: NetworkMethod
    var headers: [String : String]?
    var body: Any?
    
    func execute(callback: @escaping (Result<Any>) -> Void) {
        guard let url = URL(string: path) else {
            callback(.failure(RequestError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body as? ColorData)
            } catch (let e) {
                callback(.failure(e))
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                callback(.failure(RequestError.noResponse))
                return
            }
            
            guard response.statusCode < 400 else {
                callback(.failure(RequestError.httpResponse(response.statusCode)))
                return
            }
            
            guard let data = data else {
                callback(.failure(RequestError.noData))
                return
            }

            if let str = String(data: data, encoding: .utf8) {
                print("Received response: \(str)")
            }
            callback(.success(data))
        }
        task.resume()
    }
}
