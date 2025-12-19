import SwiftUI
import UIKit
import FoundationUtils

@MainActor
final class MainCoordinator: Coordinator {
	typealias CoordinationResult = Void
	
	var childDelegate: CoordinatorChildDelegate?
	var onFinish: ((CoordinationResult) -> Void)?
	
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let handleOutput: (MainViewModelOutput) -> Void = { [weak self] output in
			switch output {
			case .showCoordinatorOne: self?.startSceneOne()
			case .showCoordinatorTwo: self?.startSceneTwo()
			}
		}
		let viewModel = MainViewModel(handleOutput: handleOutput)
		let view = MainView(viewModel: viewModel)
		let viewController = UIHostingController(rootView: view)

		self.navigationController.pushViewController(viewController, animated: true)
	}

	private func startSceneOne() {
		let coordinator = SceneOneCoordinator(navigationController: self.navigationController)
		addChild(coordinator: coordinator)
		coordinator.start()
	}

	private func startSceneTwo() {
		let coordinator = SceneTwoCoordinator(navigationController: self.navigationController)
		coordinator.onFinish = { selection in
			switch selection {
			case .none: print("User did not select anything")
			case let .some(text): print("User select: \(text)")
			}
		}

		addChild(coordinator: coordinator)
		coordinator.start()
	}
}
