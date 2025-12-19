import Foundation

// MARK: - Container Storage (Swift pure implementation)
@MainActor
final class CoordinatorContainerStorage {
	/// Storage for per-instance coordinator containers keyed by object identity.
	/// Lifecycle is controlled explicitly via `finish` / `removeContainer(for:)`.
	private static var containers: [ObjectIdentifier: CoordinatorContainer] = [:]
	
	static func getOrCreateContainer(for coordinator: AnyObject) -> CoordinatorContainer {
		let id = ObjectIdentifier(coordinator)
		
		if let existing = containers[id] {
			return existing
		}
		
		let container = CoordinatorContainer()
		containers[id] = container
		return container
	}
	
	static func removeContainer(for coordinator: AnyObject) {
		let id = ObjectIdentifier(coordinator)
		containers[id] = nil
	}
}



