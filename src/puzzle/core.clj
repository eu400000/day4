(ns puzzle.core
  (:gen-class)
  (:require [puzzle.support-functions :refer :all]))

;; https://adventofcode.com/
;; (c) Eric Uitbeijerse
;; Dec 2021

(defn puzzlePart1
  [puzzleData]
  (let [drawnNumbers (getDrawnNumbers puzzleData)
        boards (getBingoBoards puzzleData)]
    (processDrawnNumbersFirstWin boards drawnNumbers)))

(defn puzzlePart2
  [puzzleData]
  (let [drawnNumbers (getDrawnNumbers puzzleData)
        boards (getBingoBoards puzzleData)]
    (processDrawnNumbersAllBingo boards drawnNumbers)))


(comment
  (puzzlePart1 (loadInputData "resources/puzzleInput.txt"))
  ;; => 31424


  (puzzlePart2 (loadInputData "resources/puzzleInput.txt"))
  ;; => 23042

  )