import SwiftUI

final class SceneOneCoordinator: Coordinator<Void> {

	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	override func start() {
		let handleOutput: (SceneOneViewModelOutput) -> Void = { [weak self] output in
			switch output {
			case .dismiss:
				self?.navigationController.popViewController(animated: true)
				self?.finish(())
			}
		}
		let viewModel = SceneOneViewModel(handleOutput: handleOutput)
		let view = ScenOneView(viewModel: viewModel)
		let viewController = UIHostingController(rootView: view)

		self.navigationController.pushViewController(viewController, animated: true)
	}
}
