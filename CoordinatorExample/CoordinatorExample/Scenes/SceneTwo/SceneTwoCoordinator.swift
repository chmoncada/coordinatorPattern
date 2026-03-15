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
		let view = SceneTwoFlowContainerView { [weak self] result in
			switch result {
			case .dismissed:
				self?.navigationController.popViewController(animated: true)
				self?.finish(nil)
			case let .selection(value):
				self?.navigationController.popViewController(animated: true)
				self?.finish(value)
			}
		}
		let viewController = UIHostingController(rootView: view)

		self.navigationController.pushViewController(viewController, animated: true)
	}
}
