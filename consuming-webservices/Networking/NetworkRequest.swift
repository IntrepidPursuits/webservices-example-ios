//
//  NetworkRequest.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol NetworkCallable {
    var path: String { get }
    var method: NetworkMethod { get }
    var headers: [String: String]? { get }
    var body: Any? { get }
    func execute(callback: @escaping (Result<Any>) -> Void)
}

protocol NetworkRequestable: NetworkCallable {
    var requestHandler: RequestHandler? { get }
    var defaultHTTPHandler: RequestHandler { get }
}

extension NetworkRequestable {
    var defaultHTTPHandler: RequestHandler {
        return HTTPRequestHandler(path: path, method: method, headers: headers, body: body)
    }
}

protocol RequestHandler: NetworkCallable {
}

struct NetworkRequest: NetworkRequestable {
    var path: String
    var method: NetworkMethod
    var headers: [String : String]?
    var body: Any?
    var requestHandler: RequestHandler?
    
    init (path: String, method: NetworkMethod, headers: [String : String]? = nil, body: Any? = nil, requestHandler: RequestHandler? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.requestHandler = requestHandler == nil ? defaultHTTPHandler : requestHandler
    }
    
    func execute(callback: @escaping (Result<Any>) -> Void) {
        guard let requestHandler = requestHandler else {
            callback(.failure(RequestError.requestHandlerNil))
            return
        }
        
        requestHandler.execute(callback: callback)
    }
}
