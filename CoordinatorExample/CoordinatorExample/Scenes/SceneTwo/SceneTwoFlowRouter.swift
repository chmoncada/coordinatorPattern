import SwiftUI
import Combine

@MainActor
final class SceneTwoFlowRouter: ObservableObject {
	@Published var path: [SceneTwoFlowRoute] = []

	private var didFinish = false
	private let onFinish: (SceneTwoFlowResult) -> Void

	init(onFinish: @escaping (SceneTwoFlowResult) -> Void) {
		self.onFinish = onFinish
	}

	func push(_ route: SceneTwoFlowRoute) {
		path.append(route)
	}

	func pop() {
		guard path.isEmpty == false else {
			finish(.dismissed)
			return
		}
		path.removeLast()
	}

	func handle(_ intent: SceneTwoFlowIntent) {
		switch intent {
		case .dismiss:
			pop()
		case let .select(value):
			finish(.selection(value))
		}
	}

	private func finish(_ result: SceneTwoFlowResult) {
		guard didFinish == false else { return }
		didFinish = true
		onFinish(result)
	}
}
