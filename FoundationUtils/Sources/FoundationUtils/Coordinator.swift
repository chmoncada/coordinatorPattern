import Foundation

/// The delegate to be used for the coordinator when dealing with children
@MainActor
public protocol CoordinatorChildDelegate: AnyObject {
	/// The coordinator did add a child coordinator.
	func coordinatorDidAdd<T, U>(_ coordinator: any Coordinator<T>, child: any Coordinator<U>)
	
	/// The coordinator did remove a child coordinator
	func coordinatorDidRemove<T, U>(_ coordinator: any Coordinator<T>, child: any Coordinator<U>)
}

/// Protocol that defines the coordinator interface
@MainActor
public protocol Coordinator<CoordinationResult>: AnyObject {
	associatedtype CoordinationResult
	
	/// The delegate to be notified about child coordinator changes
	var childDelegate: CoordinatorChildDelegate? { get set }
	
	/// The block performed when the coordinator has finished its flow
	var onFinish: ((CoordinationResult) -> Void)? { get set }
	
	/// Start the activity of the coordinator
	func start()
}

// MARK: - Default Implementation Extension
public extension Coordinator {
	/// Default implementation of coordinatorContainer using Swift pure storage
	/// This creates a CoordinatorContainer automatically when first accessed
	internal var coordinatorContainer: CoordinatorContainer {
		get {
			return CoordinatorContainerStorage.getOrCreateContainer(for: self)
		}
	}
	
	/// Default implementation of finish that calls onFinish and cleanup
	func finish(_ result: CoordinationResult) {
		onFinish?(result)
		coordinatorContainer.executeCleanup()
		CoordinatorContainerStorage.removeContainer(for: self)
	}
	
	/// Default implementation of addChild using the container
	func addChild<T>(coordinator: any Coordinator<T>) {
		coordinatorContainer.addChild(coordinator: coordinator, parent: self)
	}
}
