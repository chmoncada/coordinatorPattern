import SwiftUI

enum SceneTwoFlowStartDecision {
	case present
	case skip(SceneTwoFlowSkipReason)
}

enum SceneTwoFlowSkipReason {
	case disabledByFeatureFlag
}

struct SceneTwoFlowCoordinator {
	func prepareStart() async throws -> SceneTwoFlowStartDecision {
		// POC note: this currently always starts the flow.
		// In a real app this is the place for async checks (remote config, auth, etc.).
		.present
	}

	@MainActor
	func makeRoot(
		onFinish: @escaping (SceneTwoFlowResult) -> Void
	) -> some View {
		SceneTwoFlowContainerView(onFinish: onFinish)
	}
}
