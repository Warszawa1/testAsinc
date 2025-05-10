//
//  UITextField+Combine.swift
//  testAsinc
//
//  Created by Ire  Av on 10/5/25.
//


import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text }
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    private func controlPublisher(for events: UIControl.Event) -> AnyPublisher<UIButton, Never> {
        ControlPublisher(control: self, events: events)
            .eraseToAnyPublisher()
    }
}

struct ControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never
    
    let control: Control
    let events: UIControl.Event
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
        let subscription = ControlSubscription(subscriber: subscriber, control: control, events: events)
        subscriber.receive(subscription: subscription)
    }
}

final class ControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control, S.Failure == Never {
    private var subscriber: S?
    private let control: Control
    
    init(subscriber: S, control: Control, events: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: events)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
        // Also remove the target when cancelling
        control.removeTarget(self, action: #selector(eventHandler), for: .allEvents)
    }
    
    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
    
    deinit {
        // Remove the target to break the retain cycle
        control.removeTarget(self, action: #selector(eventHandler), for: .allEvents)
    }
}
