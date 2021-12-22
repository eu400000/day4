(ns puzzle.support-functions-test
  (:require [clojure.test :refer :all]
            [puzzle.support-functions :refer :all]))

(def puzzleTestData ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "" "22 13 17 11  0" " 8  2 23  4 24" "21  9 14 16  7" " 6 10  3 18  5" " 1 12 20 15 19" "" " 3 15  0  2 22" " 9 18 13 17  5" "19  8  7 25 23" "20 11 10 24  4" "14 21 16 12  6" "" "14 21 17 24  4" "10 16 15  9 19" "18  8 23 26 20" "22 11 13  6  5" " 2  0 12  3  7"])
(def allBoardData '(22 13 17 11  0  8  2 23  4 24 21  9 14 16  7  6 10  3 18  5  1 12 20 15 19  3 15  0  2 22  9 18 13 17  5 19  8  7 25 23 20 11 10 24  4 14 21 16 12  6 14 21 17 24  4 10 16 15  9 19 18  8 23 26 20 22 11 13  6  5  2  0 12  3  7))

(def boardData '({:boardHits (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board1", :board (22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19)}
                 {:boardHits (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board2", :board (3 15 0 2 22 9 18 13 17 5 19 8 7 25 23 20 11 10 24 4 14 21 16 12 6)}
                 {:boardHits (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board3", :board (14 21 17 24 4 10 16 15 9 19 18 8 23 26 20 22 11 13 6 5 2 0 12 3 7)}))

(def boardHitsTest '({:boardHits (0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board1", :board (22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19)}
                     {:boardHits (0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board2", :board (3 15 0 2 22 9 18 13 17 5 19 8 7 25 23 20 11 10 24 4 14 21 16 12 6)}
                     {:boardHits (0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0), :boardName "board3", :board (14 21 17 24 4 10 16 15 9 19 18 8 23 26 20 22 11 13 6 5 2 0 12 3 7)}))

(deftest loadInputData-test
  (is (= puzzleTestData (loadInputData "resources/puzzleTestInput.txt"))))

(deftest getDrawnNumbers-test
  (is (= '(7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1) (getDrawnNumbers puzzleTestData))))

(deftest getBingoBoards-test
  (is (= boardData (getBingoBoards puzzleTestData))))

(deftest printvar-test
  (is (= '(clojure.core/println "puzzleTestData" (clojure.core/type puzzleTestData) puzzleTestData) (macroexpand '(printvar puzzleTestData)))))

(deftest convertStringWithIntegerToIntegerList-test
  (is (= '(22 13 17 11 0) (convertStringWithIntegerToIntegerList " 22 13 17 11  0"))))

(deftest getNextBoard-test
  (is (= '(22 13 17 11  0  8  2 23  4 24 21  9 14 16  7  6 10  3 18  5  1 12 20 15 19) (getNextBoard allBoardData))))

(deftest updateBoardHits-test
  (is (= '(1 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (updateBoardHits '(22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19) '(1 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 17)))
  (is (= '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (updateBoardHits '(22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19) nil -1))))

(deftest updateAllBoardHits-tests
  (is (= boardHitsTest (updateAllBoardHits boardData 17))))
