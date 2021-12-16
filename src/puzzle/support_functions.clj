(ns puzzle.support-functions
  (:require [clojure.string :as str]))

(defn loadData
  [inputFileName]
  ;; (let [inputString (str/split (slurp inputFileName) #"\r\n")]
  (let [inputString (str/split (slurp inputFileName) #"\s+")]
    ;; (map #(Integer/parseInt %1) inputString)
   (println inputString (type inputString))

    ;; (vector (first inputString))
    inputString
    )
  )

(comment
  (loadData "resources/puzzleTestInput.txt")
  (slurp "resources/puzzleTestInput.txt")
  (first [1,2, 3])
  (str/split "1,2,3" ",")
  (first [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1 22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19 3 15 0 2 22 9 18 13 17 5 19 8 7 25 23 20 11 10 24 4 14 21 16 12 6 14 21 17 24 4 10 16 15 9 19 18 8 23 26 20 22 11 13 6 5 2 0 12 3 7])
  (first ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "22" "13" "17" "11" "0" "8" "2" "23" "4" "24" "21" "9" "14" "16" "7" "6" "10" "3" "18" "5" "1" "12" "20" "15" "19" "3" "15" "0" "2" "22" "9" "18" "13" "17" "5" "19" "8" "7" "25" "23" "20" "11" "10" "24" "4" "14" "21" "16" "12" "6" "14" "21" "17" "24" "4" "10" "16" "15" "9" "19" "18" "8" "23" "26" "20" "22" "11" "13" "6" "5" "2" "0" "12" "3" "7"])

  (re-find #"" ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "22" "13" "17" "11" "0" "8" "2" "23" "4" "24" "21" "9" "14" "16" "7" "6" "10" "3" "18" "5" "1" "12" "20" "15" "19" "3" "15" "0" "2" "22" "9" "18" "13" "17" "5" "19" "8" "7" "25" "23" "20" "11" "10" "24" "4" "14" "21" "16" "12" "6" "14" "21" "17" "24" "4" "10" "16" "15" "9" "19" "18" "8" "23" "26" "20" "22" "11" "13" "6" "5" "2" "0" "12" "3" "7"])

  (with-open [rdr (clojure.java.io/reader "resources/puzzleTestInput.txt")]
    (reduce conj [] (line-seq rdr)))

  (with-open [rdr (clojure.java.io/reader "resources/puzzleTestInput.txt")]
    (printf "%s\n" (clojure.string/join "\n" (line-seq rdr))))

)