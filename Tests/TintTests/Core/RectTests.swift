import Testing
@testable import Tint

@Suite struct RectTests {
    @Test func basicProperties() {
        let rect = Rect(x: 1, y: 2, width: 10, height: 5)
        #expect(rect.right == 11)
        #expect(rect.bottom == 7)
        #expect(rect.area == 50)
        #expect(!rect.isEmpty)
        #expect(rect.position == Position(x: 1, y: 2))
        #expect(rect.size == Size(width: 10, height: 5))
    }

    @Test func isEmpty() {
        #expect(Rect(x: 0, y: 0, width: 0, height: 5).isEmpty)
        #expect(Rect(x: 0, y: 0, width: 5, height: 0).isEmpty)
        #expect(Rect.zero.isEmpty)
    }

    @Test func intersection() {
        let a = Rect(x: 0, y: 0, width: 10, height: 10)
        let b = Rect(x: 5, y: 5, width: 10, height: 10)
        let inter = a.intersection(b)
        #expect(inter == Rect(x: 5, y: 5, width: 5, height: 5))
    }

    @Test func intersectionNoOverlap() {
        let a = Rect(x: 0, y: 0, width: 5, height: 5)
        let b = Rect(x: 10, y: 10, width: 5, height: 5)
        let inter = a.intersection(b)
        #expect(inter.isEmpty)
    }

    @Test func contains() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 10)
        #expect(rect.contains(Position(x: 0, y: 0)))
        #expect(rect.contains(Position(x: 9, y: 9)))
        #expect(!rect.contains(Position(x: 10, y: 0)))
        #expect(!rect.contains(Position(x: 0, y: 10)))
        #expect(!rect.contains(Position(x: -1, y: 0)))
    }

    @Test func inset() {
        let rect = Rect(x: 0, y: 0, width: 20, height: 10)
        let inset = rect.inset(top: 1, right: 2, bottom: 1, left: 2)
        #expect(inset == Rect(x: 2, y: 1, width: 16, height: 8))
    }

    @Test func inner() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 5)
        let inner = rect.inner
        #expect(inner == Rect(x: 1, y: 1, width: 8, height: 3))
    }

    @Test func insetClamps() {
        let rect = Rect(x: 0, y: 0, width: 2, height: 2)
        let inset = rect.inset(top: 5, right: 5, bottom: 5, left: 5)
        #expect(inset.width == 0)
        #expect(inset.height == 0)
    }

    @Test func sizeZero() {
        #expect(Size.zero == Size(width: 0, height: 0))
    }
}
