enum SceneTwoViewModelEvent {
	case dismiss
	case select(String)
}

enum SceneTwoViewModelOutput {
	case navigation(SceneTwoFlowIntent)
}

final class SceneTwoViewModel {
	let handleOutput: (SceneTwoViewModelOutput) -> Void

	init(handleOutput: @escaping (SceneTwoViewModelOutput) -> Void) {
		self.handleOutput = handleOutput
	}

	func notify(_ event: SceneTwoViewModelEvent) {
		switch event {
		case .dismiss:
			handleOutput(.navigation(.dismiss))
		case let .select(text):
			handleOutput(.navigation(.select(text)))
		}
	}
}
