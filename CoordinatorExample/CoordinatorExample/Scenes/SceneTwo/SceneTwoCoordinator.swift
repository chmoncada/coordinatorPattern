import SwiftUI

final class SceneTwoCoordinator: Coordinator<String?> {

	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	override func start() {
		let handleOutput: (SceneTwoViewModelOutput) -> Void = { [weak self] output in
			switch output {
			case .dismiss:
				self?.navigationController.popViewController(animated: true)
				self?.finish(nil)
			case let .selection(text):
				self?.navigationController.popViewController(animated: true)
				self?.finish(text)
			}
		}
		let viewModel = SceneTwoViewModel(handleOutput: handleOutput)
		let view = SceneTwoView(viewModel: viewModel)
		let viewController = UIHostingController(rootView: view)

		self.navigationController.pushViewController(viewController, animated: true)
	}
}
