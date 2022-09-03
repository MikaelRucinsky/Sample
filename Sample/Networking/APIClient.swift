//
//  APIClient.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

enum Resources {}

actor APIClient {
    private let configuration: Configuration
    private let session: URLSession
    private let decoder: JSONDecoder
    
    struct Configuration {
        var environment: URL
        var sessionConfiguration: URLSessionConfiguration = .default
        var decoder: JSONDecoder
                
        init(environment: URL, sessionConfiguration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
            self.environment = environment
            self.sessionConfiguration = sessionConfiguration
            self.sessionConfiguration.timeoutIntervalForRequest = 5.0
            self.sessionConfiguration.timeoutIntervalForResource = 10.0
            self.decoder = decoder
        }
    }
    
    // MARK: - Public methods
    
    /// Initializes the client with the given parameters.
    ///
    /// - parameter host: A host to be used for Requests with relative paths.
    /// - parameter configuration: By default, `URLSessionConfiguration.default`.
    init(environment: URL, configuration: URLSessionConfiguration = .default) {
        self.init(configuration: Configuration(environment: environment,
                                               sessionConfiguration: configuration))
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
        self.decoder = configuration.decoder
    }
    
    func value<T: Decodable>(for request: Request<T>) async throws -> T {
        try await send(request).value
    }
    
    // MARK: - Private methods
    
    private func send<T: Decodable>(_ request: Request<T>) async throws -> Response<T> {
        try await send(request) { data in
            try self.decoder.decode(T.self, from: data)
        }
    }
    
    private func send<T>(_ request: Request<T>, _ decode: @escaping (Data) async throws -> T) async throws -> Response<T> {
        let response = try await data(for: request)
        let value = try await decode(response.value)
        return response.map { _ in value }
    }
    
    /// Returns response data for the given Request.
    private func data<T>(for request: Request<T>) async throws -> Response<Data> {
        let req = try await makeRequest(for: request)
        return try await send(req)
    }
    
    private func send(_ request: URLRequest) async throws -> Response<Data> {
        do {
            return try await actuallySend(request)
        } catch {
            //Add shouldClientRetry functionality
            throw SampleError.general
        }
    }
    
    private func actuallySend(_ request: URLRequest) async throws -> Response<Data> {
        do {
            let (data, response) = try await session.data(for: request)
            try validate(response: response, data: data)
            let httpResponse = (response as? HTTPURLResponse) ?? HTTPURLResponse()
            return Response(value: data, data: data, request: request, response: httpResponse, statusCode: httpResponse.statusCode)
        } catch let error {
            print(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func makeRequest<T>(for request: Request<T>) async throws -> URLRequest {
        let url = try makeURL(path: request.path)
        return try await makeRequest(url: url, method: request.method)
    }
    
    private func makeURL(path: String) throws -> URL {
        guard let url = URL(string: path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                  throw SampleError.badURL
              }
        if path.starts(with: "/") {
            components.scheme = configuration.environment.scheme
            components.host = configuration.environment.host
        }
        
        guard let url = components.url else {
            throw SampleError.badURL
        }
        return url
    }
    
    private func makeRequest(url: URL, method: String) async throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        print(request.cURLDescription())
        return request
    }
    
    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        if !(200..<300).contains(httpResponse.statusCode) {
            throw SampleError.unacceptableStatusCode(httpResponse.statusCode)
        }
    }
}

struct Request<Response> {
    var method: String
    var path: String
    
    static func getFor(path: String) -> Request {
        Request(method: "GET", path: path)
    }
}

extension URLRequest {
    func cURLDescription() -> String {
        guard let url = url, let method = httpMethod else {
            return "$ curl command generation failed"
        }
        var components = ["curl -v"]
        components.append("- \(method)")
        for header in allHTTPHeaderFields ?? [:] {
            let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(header.key): \(escapedValue)\"")
        }
        if let httpBodyData = httpBody {
            let httpBody = String(decoding: httpBodyData, as: UTF8.self)
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-d \"\(escapedBody)\"")
        }
        components.append("\"\(url.absoluteString)\"")
        return components.joined(separator: " \\\n\t")
    }
}

func decoding<T: Decodable>(_ data: Data) throws -> T {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        throw SampleError.invalidDecoding
    }
}

struct Response<T> {
    let value: T
    let data: Data
    let request: URLRequest
    let response: HTTPURLResponse
    let statusCode: Int
    
    func map<U>(_ closure: (T) -> U) -> Response<U> {
        Response<U>(value: closure(value), data: data, request: request, response: response, statusCode: statusCode)
    }
}
