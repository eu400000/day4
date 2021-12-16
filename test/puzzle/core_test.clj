(ns puzzle.core-test
  (:require [clojure.test :refer :all]
            [puzzle.core :refer :all]))

(def puzzleTestData '(199 200 208 210 200 207 240 269 260 263))

(deftest puzzlePart1-test
  (is (= 4512 (puzzlePart1 puzzleTestData))))

(deftest day3Part2-test
  (is (= 230 (puzzlePart2 puzzleTestData))))
