enum SceneTwoViewModelEvent {
	case dismiss
	case select(String)
}

enum SceneTwoViewModelOutput {
	case dismiss
	case selection(String)
}

final class SceneTwoViewModel {
	let handleOutput: (SceneTwoViewModelOutput) -> Void

	init(handleOutput: @escaping (SceneTwoViewModelOutput) -> Void) {
		self.handleOutput = handleOutput
	}

	func notify(_ event: SceneTwoViewModelEvent) {
		switch event {
		case .dismiss:
			handleOutput(.dismiss)
		case let .select(text):
			handleOutput(.selection(text))
		}
	}
}
