import Testing
@testable import CoordinatorExample

struct CoordinatorExampleTests {

	@Test
	func sceneOneDismissEmitsDismissIntent() {
		var capturedOutput: SceneOneViewModelOutput?
		let viewModel = SceneOneViewModel { output in
			capturedOutput = output
		}

		viewModel.notify(.dismiss)

		guard let capturedOutput else {
			Issue.record("Expected one output to be emitted.")
			return
		}

		switch capturedOutput {
		case let .navigation(intent):
			#expect(intent == .dismiss)
		}
	}

	@Test
	func sceneTwoDismissEmitsDismissIntent() {
		var capturedOutput: SceneTwoViewModelOutput?
		let viewModel = SceneTwoViewModel { output in
			capturedOutput = output
		}

		viewModel.notify(.dismiss)

		guard let capturedOutput else {
			Issue.record("Expected one output to be emitted.")
			return
		}

		switch capturedOutput {
		case let .navigation(intent):
			#expect(intent == .dismiss)
		}
	}

	@Test
	func sceneTwoSelectEmitsSelectIntentWithSameValue() {
		let expectedValue = "One"
		var capturedOutput: SceneTwoViewModelOutput?
		let viewModel = SceneTwoViewModel { output in
			capturedOutput = output
		}

		viewModel.notify(.select(expectedValue))

		guard let capturedOutput else {
			Issue.record("Expected one output to be emitted.")
			return
		}

		switch capturedOutput {
		case let .navigation(intent):
			#expect(intent == .select(expectedValue))
		}
	}

	@Test
	@MainActor
	func sceneFlowRouterPushAppendsRouteToPath() {
		let router = SceneTwoFlowRouter { _ in }

		router.push(.sceneTwoDetails)

		#expect(router.path == [.sceneTwoDetails])
	}

	@Test
	@MainActor
	func sceneFlowRouterDismissPopsBeforeFinishing() {
		var finishedResults: [SceneTwoFlowResult] = []
		let router = SceneTwoFlowRouter { result in
			finishedResults.append(result)
		}
		router.push(.sceneTwoDetails)

		router.handle(.dismiss)

		#expect(router.path.isEmpty)
		#expect(finishedResults.isEmpty)
	}

	@Test
	@MainActor
	func sceneFlowRouterDismissOnRootFinishesOnceAsDismissed() {
		var finishedResults: [SceneTwoFlowResult] = []
		let router = SceneTwoFlowRouter { result in
			finishedResults.append(result)
		}

		router.handle(.dismiss)
		router.handle(.dismiss)

		#expect(finishedResults == [.dismissed])
	}

	@Test
	@MainActor
	func sceneFlowRouterSelectFinishesOnceWithSelection() {
		let expectedValue = "Two"
		var finishedResults: [SceneTwoFlowResult] = []
		let router = SceneTwoFlowRouter { result in
			finishedResults.append(result)
		}

		router.handle(.select(expectedValue))
		router.handle(.dismiss)

		#expect(finishedResults == [.selection(expectedValue)])
	}

}
