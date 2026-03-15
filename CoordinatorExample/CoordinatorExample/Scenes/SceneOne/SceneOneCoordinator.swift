import SwiftUI
import UIKit
import FoundationUtils

@MainActor
final class SceneOneCoordinator: Coordinator {
	typealias CoordinationResult = Void
	
	var childDelegate: CoordinatorChildDelegate?
	var onFinish: ((CoordinationResult) -> Void)?
	
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let handleOutput: (SceneOneViewModelOutput) -> Void = { [weak self] output in
			switch output {
			case let .navigation(intent):
				switch intent {
				case .dismiss:
					self?.navigationController.popViewController(animated: true)
					self?.finish(())
				case .select(_):
					break
				}
			}
		}
		let viewModel = SceneOneViewModel(handleOutput: handleOutput)
		let view = ScenOneView(viewModel: viewModel)
		let viewController = UIHostingController(rootView: view)

		self.navigationController.pushViewController(viewController, animated: true)
	}
}
