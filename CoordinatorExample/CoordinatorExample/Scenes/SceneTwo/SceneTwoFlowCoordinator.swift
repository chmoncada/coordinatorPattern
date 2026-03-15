import SwiftUI

struct SceneTwoFlowCoordinator {
	@MainActor
	func start(
		onFinish: @escaping (SceneTwoFlowResult) -> Void
	) -> some View {
		SceneTwoFlowContainerView(onFinish: onFinish)
	}
}
