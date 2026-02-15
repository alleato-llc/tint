import Foundation
import PickleKit
import Testing

@Suite(.serialized)
struct TintBDDTests {
    private static let featuresPath: String = {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // Tests/TintBDDTests/
            .deletingLastPathComponent() // Tests/
            .deletingLastPathComponent() // project root
            .appendingPathComponent("Features")
            .path
    }()

    static let allScenarios = GherkinTestScenario.scenarios(paths: [featuresPath])

    @Test(arguments: TintBDDTests.allScenarios)
    func scenario(_ test: GherkinTestScenario) async throws {
        let result = try await test.run(stepDefinitions: [
            CommonSetupSteps.self,
            BufferActionSteps.self,
            BufferVerificationSteps.self,
            LayoutSteps.self,
            StyleSetupSteps.self,
            StyleVerificationSteps.self,
            TextWidgetSteps.self,
            BlockWidgetSteps.self,
            ListWidgetSteps.self,
            TableWidgetSteps.self,
            InputParsingSteps.self,
        ])
        #expect(result.passed, "Scenario '\(test.description)' failed: \(failureDetails(result))")
    }

    private func failureDetails(_ result: ScenarioResult) -> String {
        result.stepResults
            .filter { $0.status != .passed }
            .map { "\($0.keyword) \($0.text): \($0.error ?? "unknown error")" }
            .joined(separator: "\n")
    }
}
