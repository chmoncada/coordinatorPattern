import SwiftUI

struct ScenOneView: View {

	let viewModel: SceneOneViewModel

	var body: some View {
		VStack(spacing: 20) {
			HStack {
				Button(action: {
					self.viewModel.notify(.dismiss)
				}) {
					Image(systemName: "chevron.left")
					Text("Back")
				}
				.padding()

				Spacer()
			}

			Spacer()

			Text("Scene One")
				.padding()

			Spacer()
		}
		.navigationBarHidden(true)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
