import Foundation
@testable import FoundationUtils

@MainActor
final class MockCoordinator: Coordinator {
    typealias CoordinationResult = String
    
    var childDelegate: CoordinatorChildDelegate?
    var onFinish: ((String) -> Void)?
    
    var startCallCount = 0
    
    func start() {
        startCallCount += 1
    }
}

@MainActor
final class MockCoordinatorVoid: Coordinator {
    typealias CoordinationResult = Void
    
    var childDelegate: CoordinatorChildDelegate?
    var onFinish: ((CoordinationResult) -> Void)?

    var startCallCount = 0
    
    func start() {
        startCallCount += 1
    }
}

@MainActor
final class MockCoordinatorChildDelegate: CoordinatorChildDelegate {
    var didAddCallCount = 0
    var didRemoveCallCount = 0
    var lastAddedChild: AnyObject?
    var lastRemovedChild: AnyObject?
    
    func coordinatorDidAdd<T, U>(_ coordinator: any Coordinator<T>, child: any Coordinator<U>) {
        didAddCallCount += 1
        lastAddedChild = child
    }
    
    func coordinatorDidRemove<T, U>(_ coordinator: any Coordinator<T>, child: any Coordinator<U>) {
        didRemoveCallCount += 1
        lastRemovedChild = child
    }
}

