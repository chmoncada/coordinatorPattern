enum MainViewModelEvent {
	case showCoordinatorOne
	case showCoordinatorTwo
}

enum MainViewModelOutput {
	case showCoordinatorOne
	case showCoordinatorTwo
}

final class MainViewModel {

	let handleOutput: (MainViewModelOutput) -> Void

	init(handleOutput: @escaping (MainViewModelOutput) -> Void) {
		self.handleOutput = handleOutput
	}

	func notify(_ event: MainViewModelEvent) {
		switch event {
		case .showCoordinatorOne:
			handleOutput(.showCoordinatorOne)
		case .showCoordinatorTwo:
			handleOutput(.showCoordinatorTwo)
		}
	}
}
