import AVFoundation
import Foundation
import Testing
@testable import MarioMonsters

struct AnswerCheckerTests {
    @Test func contractionsAndPunctuationAreIgnored() {
        #expect(AnswerChecker.sentenceMatches("She is not at home", "She isn't at home."))
        #expect(AnswerChecker.sentenceMatches("i can't sing", "I can't sing."))
        #expect(AnswerChecker.sentenceMatches("I am 8 years old.", "I am eight years old."))
    }

    @Test func wordOrderAndMissingWordsMatter() {
        #expect(!AnswerChecker.sentenceMatches("She is happy?", "Is she happy?"))
        #expect(!AnswerChecker.sentenceMatches("She no at home.", "She isn't at home."))
        #expect(!AnswerChecker.sentenceMatches("There is a ball in school.", "There is a ball in the school."))
    }

    @Test func speechScoreCountsWordsInOrder() {
        #expect(AnswerChecker.speechScore(transcript: "she has got curly hair", target: "She has got curly hair.") == 1)
        #expect(AnswerChecker.speechScore(transcript: "she curly hair", target: "She has got curly hair.") < 0.7)
        #expect(AnswerChecker.speechScore(transcript: "", target: "Hi") == 0)
    }
}

struct SchedulerTests {
    let calendar = Calendar(identifier: .gregorian)
    let now = Date(timeIntervalSince1970: 1_790_000_000)

    @Test func correctMovesUpAndSchedulesLater() {
        let first = Scheduler.next(box: 0, correct: true, now: now, calendar: calendar)
        #expect(first.box == 1)
        #expect(first.due == now)

        let later = Scheduler.next(box: 3, correct: true, now: now, calendar: calendar)
        #expect(later.box == 4)
        #expect(later.due == calendar.date(byAdding: .day, value: 4, to: calendar.startOfDay(for: now)))
    }

    @Test func wrongDropsTwoBoxesAndIsDueNow() {
        #expect(Scheduler.next(box: 5, correct: false, now: now).box == 3)
        #expect(Scheduler.next(box: 1, correct: false, now: now).box == 0)
        #expect(Scheduler.next(box: 5, correct: false, now: now).due == now)
    }

    @Test func boxIsCapped() {
        #expect(Scheduler.next(box: Scheduler.maxBox, correct: true, now: now).box == Scheduler.maxBox)
    }

    @Test func monsterHealth() {
        let cards = Curriculum.cards(for: .snake)
        #expect(MonsterStats.health(of: .snake, boxes: [:]) == 1)
        let all = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, Scheduler.masteredBox) })
        #expect(MonsterStats.health(of: .snake, boxes: all) == 0)
        #expect(MonsterStats.mastered(of: .snake, boxes: all).done == cards.count)
    }
}

struct LadderTests {
    @Test func boxSelectsExercise() {
        let sentence = Curriculum.noNo[0]
        let word = Curriculum.ae[0]
        #expect(Exercise.make(card: sentence, box: 0, speechEnabled: true).kind == .listenChoose)
        #expect(Exercise.make(card: sentence, box: 1, speechEnabled: true).kind == .sayIt)
        #expect(Exercise.make(card: sentence, box: 1, speechEnabled: false).kind == .repair)
        #expect(Exercise.make(card: sentence, box: 3, speechEnabled: true).kind == .build)
        #expect(Exercise.make(card: sentence, box: 6, speechEnabled: true).kind == .paper)
        #expect(Exercise.make(card: word, box: 2, speechEnabled: true).kind == .spellTiles)
        #expect(Exercise.make(card: word, box: 4, speechEnabled: true).autoplay == false)
    }

    @Test func skippedSpeakingBecomesAnotherExercise() {
        for card in [Curriculum.noNo[0], Curriculum.ae[0]] {
            let speaking = Exercise.make(card: card, box: 1, speechEnabled: true)
            let kinds = Set((0..<40).map { _ in speaking.swapped() }.map { swapped in
                #expect(swapped.card == card)
                return swapped.kind
            })
            #expect(!kinds.contains(.sayIt))
            #expect(kinds.count > 1)
        }
    }
}

struct SessionPlannerTests {
    let now = Date(timeIntervalSince1970: 1_790_000_000)
    let defaultCards = MonsterSelection.cards(enabled: Set(MonsterID.defaultEnabled))

    @Test func firstSessionMixesMonsters() {
        let plan = SessionPlanner.plan(cards: defaultCards, progress: [:], focus: nil, length: 10, now: now)
        #expect(plan.count == 8)
        #expect(Set(plan.map(\.monster)).count == MonsterID.defaultEnabled.count)
    }

    @Test func dueCardsComeFirstButLeaveRoomForNewOnes() {
        let due = Curriculum.all.prefix(20).reduce(into: [String: ProgressSnapshot]()) {
            $0[$1.id] = ProgressSnapshot(box: 2, due: now.addingTimeInterval(-60))
        }
        let plan = SessionPlanner.plan(progress: due, focus: nil, length: 10, now: now)
        #expect(plan.count == 10)
        #expect(plan.filter { due[$0.id] == nil }.count == 2)
    }

    @Test func laterSessionsAddUpToFiveNewCards() {
        let one = [Curriculum.all[0].id: ProgressSnapshot(box: 3, due: now.addingTimeInterval(86_400))]
        let plan = SessionPlanner.plan(progress: one, focus: nil, length: 10, now: now)
        #expect(plan.filter { one[$0.id] == nil }.count == 5)
    }

    @Test func bigBacklogMixesMonsters() {
        let due = Curriculum.all.reduce(into: [String: ProgressSnapshot]()) {
            $0[$1.id] = ProgressSnapshot(box: 2, due: .distantPast)
        }
        let plan = SessionPlanner.plan(cards: defaultCards, progress: due, focus: nil, length: 10, now: now)
        #expect(Set(plan.map(\.monster)).count == MonsterID.defaultEnabled.count)
    }

    @Test func focusRestrictsToOneMonster() {
        let plan = SessionPlanner.plan(progress: [:], focus: .jumper, length: 10, now: now)
        #expect(plan.allSatisfy { $0.monster == .jumper })
    }

    @Test func fillsWithWeakestWhenNothingIsDue() {
        var progress: [String: ProgressSnapshot] = [:]
        for card in Curriculum.all {
            progress[card.id] = ProgressSnapshot(box: card.monster == .traps ? 1 : 5, due: now.addingTimeInterval(86_400))
        }
        let plan = SessionPlanner.plan(progress: progress, focus: nil, length: 6, now: now)
        #expect(plan.count == 6)
        #expect(plan.allSatisfy { $0.monster == .traps })
    }
}

struct TileTests {
    @Test func tilesHideSentenceStartCapital() {
        #expect(TileFactory.canonicalTokens("She isn't at home.") == ["she", "isn't", "at", "home"])
        #expect(TileFactory.canonicalTokens("I study English on Wednesdays.") == ["I", "study", "English", "on", "Wednesdays"])
    }

    @Test func distractorsComeFromMariosMistakes() {
        let card = Curriculum.noNo[1] // She isn't at home.
        #expect(TileFactory.distractorWords(for: card).contains("no"))
    }

    @Test func repairBankCompletesTheSentence() {
        for card in Curriculum.all where card.kind == .sentence {
            let setup = TileFactory.repairSetup(for: card)
            let available = (setup.placed + setup.bank).map(AnswerChecker.key)
            for token in TileFactory.canonicalTokens(card.english) {
                #expect(available.contains(AnswerChecker.key(token)), "\(card.english) is missing \(token)")
            }
        }
    }

    @Test func spellingLettersAreNotInTarget() {
        for card in Curriculum.all where card.kind == .word {
            let letters = TileFactory.distractorLetters(for: card)
            #expect(letters.count <= 3)
            #expect(letters.allSatisfy { !card.english.contains($0) })
        }
    }
}

struct ContentTests {
    @Test func idsAreUnique() {
        #expect(Set(Curriculum.all.map(\.id)).count == Curriculum.all.count)
    }

    @Test func everyMonsterHasEnoughCards() {
        for monster in MonsterID.allCases {
            #expect(Curriculum.cards(for: monster).count >= 15)
        }
    }

    @Test func wrongVersionsAreReallyWrong() {
        for card in Curriculum.all {
            #expect(card.wrong.count >= 2, "\(card.english)")
            #expect(!card.wrong.contains(card.english), "\(card.english)")
            if card.kind == .sentence {
                // The repair exercise starts from wrong[0]; it must differ once normalised.
                #expect(!AnswerChecker.sentenceMatches(card.wrong[0], card.english), "\(card.english)")
            }
        }
    }

    @Test func checklistIsShortAndRelevant() {
        for card in Curriculum.all {
            let items = DetectiveChecklist.items(for: card)
            #expect((1...4).contains(items.count))
        }
        let question = Curriculum.jumper[0]
        #expect(DetectiveChecklist.items(for: question).contains { $0.contains("verbo") })
    }

    @Test func everyMonsterHasInfo() {
        for monster in MonsterID.allCases {
            #expect(!monster.info.name.isEmpty)
        }
        #expect(MonsterID.allCases.compactMap(\.info.emblem).sorted() == ["'s", "got", "×2"])
    }

    @Test func streakCountsConsecutiveDays() {
        let calendar = Calendar.current
        let today = Date.now
        let days = (0..<3).map { calendar.date(byAdding: .day, value: -$0, to: today)! }
        #expect(Streak.days(sessionDates: days) == 3)
        #expect(Streak.days(sessionDates: [calendar.date(byAdding: .day, value: -3, to: today)!]) == 0)
    }
}

struct MonsterSelectionTests {
    @Test func typicalErrorsAreOnByDefault() {
        #expect(MonsterID.defaultEnabled == MonsterGroup.core.monsters)
        #expect(Set(MonsterID.defaultEnabled) == [.ae, .noNo, .jumper, .snake, .traps, .gotLost])
    }

    @Test func selectionIsNeverEmptyAndRoundTrips() {
        #expect(MonsterSelection.decode("") == Set(MonsterID.defaultEnabled))
        #expect(MonsterSelection.decode("nonsense") == Set(MonsterID.defaultEnabled))
        let picked: Set<MonsterID> = [.animals, .yesterday, .ae]
        #expect(MonsterSelection.decode(MonsterSelection.encode(picked)) == picked)
        #expect(MonsterSelection.cards(enabled: [.animals]).allSatisfy { $0.monster == .animals })
    }
}

struct SpokenSpanishTests {
    @Test func symbolsAndEmphasisAreReadNaturally() {
        #expect(SpokenSpanish.normalise("hair = pelo. ¡No es endulzado! 🍭") == "hair, es pelo. ¡No es endulzado!")
        #expect(SpokenSpanish.normalise("swim → swimming") == "swim, swimming")
        #expect(SpokenSpanish.normalise("Delante de = IN front OF.") == "Delante de, es in front of.")
        #expect(SpokenSpanish.normalise("friend lleva una i: fr-I-end. wHale") == "friend lleva una i: friend. whale")
        #expect(SpokenSpanish.normalise("straight: s-t-r-a-i-g-h-t, -ing, I, Monday") == "straight: s-t-r-a-i-g-h-t, ing, I, Monday")
    }

    @Test func eachSentenceIsReadOnItsOwn() {
        #expect(SpokenSpanish.sentences("¿Quién es? ¡Piensa! Has she got…? Vale.") == ["¿Quién es?", "¡Piensa!", "Has she got…?", "Vale."])
    }

    @Test func allHelpTextCanBeSpoken() {
        for card in Curriculum.all {
            let spoken = SpokenSpanish.sentences(card.explanation).joined(separator: " ")
            #expect(!spoken.isEmpty)
            #expect(!spoken.contains(where: { "→=≠«»·".contains($0) }), "\(spoken)")
        }
    }
}

struct SpeechLeniencyTests {
    @Test func accentAndRecognizerSlipsStillCount() {
        #expect(AnswerChecker.speechScore(transcript: "eye have got a dog", target: "I have got a dog.") == 1)
        #expect(AnswerChecker.speechScore(transcript: "she has got curli hair", target: "She has got curly hair.") == 1)
        #expect(AnswerChecker.speechScore(transcript: "my favourit colour is green", target: "My favourite colour is green.") == 1)
        #expect(AnswerChecker.speechScore(transcript: "the dolfin is swimming", target: "The dolphin is swimming.") == 1)
        #expect(AnswerChecker.speechScore(transcripts: ["is he happy", "is she happy"], target: "Is she happy?") == 1)
    }

    @Test func differentWordsDoNotCount() {
        #expect(!AnswerChecker.soundsAlike("cat", "car"))
        #expect(!AnswerChecker.soundsAlike("she", "he"))
        #expect(AnswerChecker.speechScore(transcript: "i like football", target: "She has got curly hair.") == 0)
    }

    @Test func aLoneIIsSpokenAsAWord() {
        #expect(Speaker.spokenEnglish("I") == "eye")
        #expect(Speaker.spokenEnglish("I am happy.") == "I am happy.")
        let you = Speaker.pronounced("you")
        #expect(you.attribute(NSAttributedString.Key(AVSpeechSynthesisIPANotationAttribute), at: 0, effectiveRange: nil) as? String == "ˈjuː")
        #expect(Speaker.pronounced("Have you got a dog?").length == 19)
    }
}

@MainActor
struct VoiceChoiceTests {
    @Test func prefersAClearWomansVoiceAndSkipsNoveltyVoices() {
        let voices = Speaker.voices(for: "en")
        #expect(voices.allSatisfy { $0.language.hasPrefix("en-") && !$0.identifier.contains("eloquence") })
        if voices.contains(where: { $0.gender == .female }) {
            #expect(voices.first?.gender == .female)
        }
    }
}
