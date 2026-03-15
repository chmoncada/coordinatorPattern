enum SceneOneViewModelEvent {
	case dismiss
}

enum SceneOneViewModelOutput {
	case navigation(SceneFlowIntent)
}

final class SceneOneViewModel {
	let handleOutput: (SceneOneViewModelOutput) -> Void

	init(handleOutput: @escaping (SceneOneViewModelOutput) -> Void) {
		self.handleOutput = handleOutput
	}

	func notify(_ event: SceneOneViewModelEvent) {
		switch event {
		case .dismiss:
			handleOutput(.navigation(.dismiss))
		}
	}
}
