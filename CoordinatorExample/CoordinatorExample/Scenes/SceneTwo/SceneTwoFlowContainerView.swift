import SwiftUI

struct SceneTwoFlowContainerView: View {
	@StateObject private var router: SceneTwoFlowRouter

	init(onFinish: @escaping (SceneTwoFlowResult) -> Void) {
		self._router = StateObject(
			wrappedValue: SceneTwoFlowRouter(
				onFinish: onFinish
			)
		)
	}

	var body: some View {
		NavigationStack(path: $router.path) {
			sceneTwoRootView
				.navigationDestination(for: SceneTwoFlowRoute.self) { route in
					sceneView(for: route)
				}
		}
	}

	private var sceneTwoRootView: some View {
		let viewModel = SceneTwoViewModel { output in
			switch output {
			case let .navigation(intent):
				router.handle(intent)
			}
		}
		return SceneTwoView(viewModel: viewModel)
	}

	@ViewBuilder
	private func sceneView(for route: SceneTwoFlowRoute) -> some View {
		switch route {
		case .sceneTwoDetails:
			Text("Scene Two Detail")
		}
	}
}
