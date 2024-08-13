//
//  WebsocketManager.swift
//  TheCWA_admin
//
//  Created by Theo Koester on 3/10/24.
//

import Foundation
import UIKit

protocol WebSocketObserver: AnyObject {
    func didReceiveWebSocketMessage(_ message: WebSocketMessage)
}

class WebSocketHandler {
    static let shared = WebSocketHandler()
    var websocketTask: URLSessionWebSocketTask?
    private var observers = [WebSocketObserver]()
    
    private init() {
            // Private initialization to ensure just one instance is created.
        }
    
    func addObserver(_ observer: WebSocketObserver) {
        if !observers.contains(where: { $0 === observer }) {
            observers.append(observer)
        }
    }
    
    func removeObserver(_ observer: WebSocketObserver) {
        observers = observers.filter { $0 !== observer }
    }
    
    func connect(to url: URL) {
           websocketTask = URLSession.shared.webSocketTask(with: url)
           websocketTask?.resume()
           receiveMessage()
           sendInitialConnectMessage()
       }

       private func sendInitialConnectMessage() {
           if let userUUID = UIDevice.current.identifierForVendor?.uuidString {
               if let connectMessage = MessageHandler.createMessage(type: .connect, data: userUUID) {
                   sendMessage(connectMessage)
               }
           } else {
               print("Failed to retrieve device UUID")
           }
       }

    
    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        websocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket Error in sending message: \(error)")
            }
        }
    }
    
    func disconnect() {
        websocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func receiveMessage() {
        websocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                
                print("WebSocket Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.decodeMessage(text)
                case .data(let data):
                    print("WebSocket Received data: \(data)")
                default:
                    break
                }
                self?.receiveMessage() // Listen for the next message
            }
        }
    }
    
    private func decodeMessage(_ text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let message = try JSONDecoder().decode(WebSocketMessage.self, from: data)
                notifyObservers(with: message)
            } catch {
                print("Decoding error: \(error)")
            }
        }
    }
    
    private func notifyObservers(with message: WebSocketMessage) {
        for observer in observers {
            observer.didReceiveWebSocketMessage(message)
        }
    }    
}

struct WebSocketMessage: Codable {
    var type: String
    var item_type: String?
    var data: String?
    
    
    func decodeData<T: Codable>(as type: T.Type) throws -> T {
        guard let jsonString = data,
              let jsonData = jsonString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid data"))
        }
        return try JSONDecoder().decode(type, from: jsonData)
    }
}
