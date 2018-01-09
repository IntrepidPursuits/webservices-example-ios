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
    case decoderFailure
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
        case .decoderFailure:
            return "JSONDecoder failed to generate model"
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

        // Create your URLRequest and set its method

        if let headers = headers {
            for (key, value) in headers {
                // Add each header value to the appropriate header key
            }
        }
        
        if let body = body {
            // Set the httpBody of your request
            // Use the JSONEncoder to make the body a ColorData object
        }

        // Create a dataTask using URLSession with your shiny, new request
        // We'll need to cast our response as an HTTPURLResponse
        // We'll also need to decode our received data using JSONDecoder

        // You might find this snippet handy for debugging
        // if let str = String(data: data, encoding: .utf8) {
        //     print("Received response: \(str)")
        // }

        let fakeData = ["color": "#FF0000", "name": "Cookie Cat"]
        callback(.success(fakeData))

        // task.resume()
    }
}
