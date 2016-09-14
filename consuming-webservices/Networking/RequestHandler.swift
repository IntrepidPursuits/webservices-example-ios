//
//  RequestHandler.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}

enum RequestError: Error {
    case requestHandlerNilError
    case invalidURLError
    case noResponseError
    case httpResponseError(Int)
    case noDataError
}

extension RequestError: CustomStringConvertible {
    var description: String {
        switch self {
        case .requestHandlerNilError:
            return "No Request Handler"
        case .invalidURLError:
            return "Invalid URL"
        case .noResponseError:
            return "No Response"
        case .httpResponseError(let errorCode):
            return "HTTP Response: \(errorCode)"
        case .noDataError:
            return "No Data Returned"
        }
    }
}

struct HTTPRequestHandler: RequestHandler {
    var path: String
    var method: NetworkMethod
    var headers: [String : String]?
    var body: Any?
    
    func execute( callback: @escaping (Result<Any>) -> Void) {
        guard let url = URL(string: path) else {
            callback(.Failure(RequestError.invalidURLError))
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
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch (let e) {
                callback(.Failure(e))
            }
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                callback(.Failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                callback(.Failure(RequestError.noResponseError))
                return
            }
            
            guard response.statusCode < 400 else {
                callback(.Failure(RequestError.httpResponseError(response.statusCode)))
                return
            }
            
            guard let data = data else {
                callback(.Failure(RequestError.noDataError))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    print("Received response: \(str)")
                }
                callback(.Success(json))
            } catch (let e) {
                callback(.Failure(e))
            }
        })
        task.resume()
    }
}
