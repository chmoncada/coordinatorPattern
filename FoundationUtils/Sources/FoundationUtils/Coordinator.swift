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
	
	/// Function to call when you are finished
	func finish(_ result: CoordinationResult)
	
	/// Add a child coordinator
	func addChild<T>(coordinator: any Coordinator<T>)
}

/// Container class that manages child coordinators and cleanup logic
/// This is composed into coordinator implementations instead of using inheritance
@MainActor
public final class CoordinatorContainer {
	private var children = [UUID: AnyObject]()
	
	public init() {}

	/// Add a child coordinator
	internal func addChild<T, P>(
		coordinator: any Coordinator<T>,
		parent: any Coordinator<P>
	) {
		// Get or create identifier for the child coordinator
		let childIdentifier = coordinator.coordinatorContainer.getOrCreateIdentifier()
		
		// Store reference to coordinator
		children[childIdentifier] = coordinator as AnyObject
		
		// Set up cleanup block on the child's container
		coordinator.coordinatorContainer.setCleanupBlock { [weak parent, weak coordinator] in
			guard let parent = parent, let coordinator = coordinator else { return }
			parent.coordinatorContainer.removeChild(identifier: childIdentifier)
			parent.childDelegate?.coordinatorDidRemove(parent, child: coordinator)
		}
		
		// Notify delegate
		parent.childDelegate?.coordinatorDidAdd(parent, child: coordinator)
	}
	
	/// Remove a child coordinator by identifier
	internal func removeChild(identifier: UUID) {
		children.removeValue(forKey: identifier)
	}
	
	/// Get or create a unique identifier for this coordinator
	internal func getOrCreateIdentifier() -> UUID {
		// Use object address as part of identifier to ensure uniqueness
		return identifier
	}
	
	/// Set the cleanup block to be called when this coordinator finishes
	internal func setCleanupBlock(_ block: @escaping () -> Void) {
		cleanupBlock = block
	}
	
	/// Execute the cleanup block
	internal func executeCleanup() {
		cleanupBlock?()
		cleanupBlock = nil
	}
	
	private let identifier = UUID()
	private var cleanupBlock: (() -> Void)?
}

// MARK: - Container Storage (Swift pure implementation)
@MainActor
private final class CoordinatorContainerStorage {
	/// Weak-keyed map so that when a coordinator is deallocated,
	/// its entry (and therefore its `CoordinatorContainer`) are automatically
	/// removed and released.
	private static let containers = NSMapTable<AnyObject, CoordinatorContainer>.weakToStrongObjects()
	
	static func getOrCreateContainer(for coordinator: AnyObject) -> CoordinatorContainer {
		if let existing = containers.object(forKey: coordinator) {
			return existing
		}
		
		let container = CoordinatorContainer()
		containers.setObject(container, forKey: coordinator)
		return container
	}
	
	static func removeContainer(for coordinator: AnyObject) {
		containers.removeObject(forKey: coordinator)
	}
}

// MARK: - Default Implementation Extension
public extension Coordinator {
	/// Default implementation of coordinatorContainer using Swift pure storage
	/// This creates a CoordinatorContainer automatically when first accessed
	var coordinatorContainer: CoordinatorContainer {
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
