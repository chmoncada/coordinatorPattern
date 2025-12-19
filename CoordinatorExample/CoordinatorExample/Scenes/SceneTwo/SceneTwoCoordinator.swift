import SwiftUI
import UIKit
import FoundationUtils

@MainActor
final class SceneTwoCoordinator: Coordinator {
	typealias CoordinationResult = String?
	
	var childDelegate: CoordinatorChildDelegate?
	var onFinish: ((String?) -> Void)?
	
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
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
