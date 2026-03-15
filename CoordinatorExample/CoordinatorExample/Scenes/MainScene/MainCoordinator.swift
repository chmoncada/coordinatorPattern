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
		let flowCoordinator = SceneTwoFlowCoordinator()
		let rootView = flowCoordinator.start { [weak self] result in
			guard let self else { return }
			self.navigationController.popViewController(animated: true)

			switch result {
			case .dismissed:
				print("User did not select anything")
			case let .selection(text):
				print("User select: \(text)")
			}
		}
		let viewController = UIHostingController(rootView: rootView)
		self.navigationController.pushViewController(viewController, animated: true)
	}
}
