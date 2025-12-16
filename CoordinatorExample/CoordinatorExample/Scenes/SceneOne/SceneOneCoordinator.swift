import SwiftUI
import UIKit

final class SceneOneCoordinator: Coordinator {
	typealias CoordinationResult = Void
	
	var childDelegate: CoordinatorChildDelegate?
	var onFinish: ((Void) -> Void)?
	
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
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
