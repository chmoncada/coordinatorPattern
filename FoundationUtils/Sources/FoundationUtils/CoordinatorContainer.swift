import Foundation

/// Container class that manages child coordinators and cleanup logic
/// This is composed into coordinator implementations instead of using inheritance
@MainActor
final class CoordinatorContainer {
	private var children = [UUID: AnyObject]()
	
	init() {}
	
	/// Add a child coordinator
	func addChild<T, P>(
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
	func removeChild(identifier: UUID) {
		children.removeValue(forKey: identifier)
	}
	
	/// Get or create a unique identifier for this coordinator
	func getOrCreateIdentifier() -> UUID {
		// Use object address as part of identifier to ensure uniqueness
		return identifier
	}
	
	/// Set the cleanup block to be called when this coordinator finishes
	func setCleanupBlock(_ block: @escaping () -> Void) {
		cleanupBlock = block
	}
	
	/// Execute the cleanup block
	func executeCleanup() {
		cleanupBlock?()
		cleanupBlock = nil
	}
	
	private let identifier = UUID()
	private var cleanupBlock: (() -> Void)?
}


