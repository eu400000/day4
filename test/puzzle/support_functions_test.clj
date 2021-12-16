(ns puzzle.support-functions-test
  (:require [clojure.test :refer :all]
            [puzzle.support-functions :refer :all]))

(def puzzleTestData '(199 200 208 210 200 207 240 269 260 263))

(deftest loadData-test
  (is (= testData (loadData "resources/puzzleTestInput.txt"))))