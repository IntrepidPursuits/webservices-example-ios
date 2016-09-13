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
    var body: AnyObject? { get }
    func execute(callback: @escaping (Result<Any>) -> Void)
}

protocol NetworkRequestable: NetworkCallable {
    var requestHandler: RequestHandlable? { get }
    var defaultHTTPHandler: RequestHandlable { get }
}

extension NetworkRequestable {
    var defaultHTTPHandler: RequestHandlable {
        return HTTPRequestHandler(path: path, method: method, headers: headers, body: body)
    }
}

protocol RequestHandlable: NetworkCallable {
    // func execute(callback: @escaping (Result<AnyObject>) -> Void)
}

struct NetworkRequest: NetworkRequestable {
    var path: String
    var method: NetworkMethod
    var headers: [String : String]?
    var body: AnyObject?
    var requestHandler: RequestHandlable?
    
    init (path: String, method: NetworkMethod, headers: [String : String]? = nil, body: AnyObject? = nil, requestHandler: RequestHandlable? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.requestHandler = requestHandler == nil ? defaultHTTPHandler : requestHandler
    }
    
    func execute(callback: @escaping (Result<Any>) -> Void) {
        guard let requestHandler = requestHandler else {
            callback(.Failure(RequestError.requestHandlerNilError))
            return
        }
        
        requestHandler.execute(callback: callback)
    }
}
