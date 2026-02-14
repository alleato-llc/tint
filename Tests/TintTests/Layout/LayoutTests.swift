import Testing
@testable import Tint

@Suite struct LayoutTests {
    @Test func verticalSplit() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [.fixed(3), .fill, .fixed(1)])
        let rects = layout.split(area)
        #expect(rects.count == 3)
        #expect(rects[0] == Rect(x: 0, y: 0, width: 80, height: 3))
        #expect(rects[1] == Rect(x: 0, y: 3, width: 80, height: 20))
        #expect(rects[2] == Rect(x: 0, y: 23, width: 80, height: 1))
    }

    @Test func horizontalSplit() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .horizontal, constraints: [.fixed(20), .fill])
        let rects = layout.split(area)
        #expect(rects.count == 2)
        #expect(rects[0] == Rect(x: 0, y: 0, width: 20, height: 24))
        #expect(rects[1] == Rect(x: 20, y: 0, width: 60, height: 24))
    }

    @Test func percentageSplit() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.percentage(30), .percentage(70)])
        let rects = layout.split(area)
        #expect(rects[0].width == 30)
        #expect(rects[1].width == 70)
    }

    @Test func multipleFills() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.fixed(10), .fill, .fill])
        let rects = layout.split(area)
        #expect(rects[0].width == 10)
        // 90 remaining split between 2 fills: 45 each
        #expect(rects[1].width == 45)
        #expect(rects[2].width == 45)
    }

    @Test func minConstraint() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.min(20), .fill])
        let rects = layout.split(area)
        // min(20) gets 20 initially + some fill share
        #expect(rects[0].width >= 20)
    }

    @Test func emptyConstraints() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [])
        let rects = layout.split(area)
        #expect(rects.isEmpty)
    }

    @Test func singleFill() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [.fill])
        let rects = layout.split(area)
        #expect(rects.count == 1)
        #expect(rects[0] == area)
    }
}
