import Foundation

// MARK: - Container Storage (Swift pure implementation)
@MainActor
final class CoordinatorContainerStorage {
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


