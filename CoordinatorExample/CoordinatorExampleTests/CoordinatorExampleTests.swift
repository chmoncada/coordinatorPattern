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

}
