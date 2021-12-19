(ns puzzle.support-functions
  ;; (:require [clojure.string :refer [split]]))
(:require [clojure.string :as str]))

(comment

  
  (clojure.string/split "a, b, c" #",")

  (split "a, b, c" #",")

  (clojure.string/split "name,address,city,state,zip,email,phone" #",")
  )

(defn loadInputData
  [inputFileName]
  (with-open [rdr (clojure.java.io/reader inputFileName)]
    (reduce conj [] (line-seq rdr))))

(defn getDrawnNumbers
  [inputData]
  (map #(Integer/parseInt %1) (str/split (first inputData) #","))
)

(defn printSymbol
  [a]
  ;; (println (name ~a) (type a) a)
  (println (var a))
  )

(defmacro printvar
  "Println of var name, type and value"
  [a]
  `(println ~(name a) (type ~a) ~a))

(defn getBingoBoards
  [inputData]
  (let [boardData (remove #(= %1 "") (rest inputData))
        ;; boardString (str/split boardData #" ")
        ;; boardIntegers (map #(Integer/parseInt %1) )
        ]
    (println inputData )
    (println boardData)
    ;; (println boardString)
    )
)

(defn showData
  [inputFileName]
  (with-open [rdr (clojure.java.io/reader inputFileName)]
    (let [line (line-seq rdr)]
      (printf "%s\n" (clojure.string/join "\n" line)))))


(comment
  (def d ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "" "22 13 17 11  0" " 8  2 23  4 24" "21  9 14 16  7" " 6 10  3 18  5" " 1 12 20 15 19" "" " 3 15  0  2 22" " 9 18 13 17  5" "19  8  7 25 23" "20 11 10 24  4" "14 21 16 12  6" "" "14 21 17 24  4" "10 16 15  9 19" "18  8 23 26 20" "22 11 13  6  5" " 2  0 12  3  7"])
  (def d {})
  (getBingoBoards d)
  d
  (rest d)
  (printSymbol d)
  (name 'd)
  (defn symbol-as-string 
    [sym] 
    (println (name ~sym))
    (str (second `(name ~sym)))
    )
  

  (symbol-as-string d)


(defn symbol-as-string [sym] (str (second `(name ~sym))))

=> (def my-var {})
#'user/my-var
=> (symbol-as-string my-var)
"my-var"
=> (symbol-as-string 'howdy)
"howdy"




  (defn keyname [key] (str (namespace key) "/" (name key)))
  (keyname d)
  (identity d)
  (str/split (first (rest d)) #" ")
  (map #(Integer/parseInt %1) (str/split rest d #" "))
  (count d)
  (println d)
  (clojure.pprint/pprint d)
  (type d)
  (keys d)
  (first d)
  (str/split (first d) #",")
  (second d)
  (last d)
  (time (mapv identity d))
)

(comment
  (getDrawnNumbers ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "" "22 13 17 11  0" " 8  2 23  4 24" "21  9 14 16  7" " 6 10  3 18  5" " 1 12 20 15 19" "" " 3 15  0  2 22" " 9 18 13 17  5" "19  8  7 25 23" "20 11 10 24  4" "14 21 16 12  6" "" "14 21 17 24  4" "10 16 15  9 19" "18  8 23 26 20" "22 11 13  6  5" " 2  0 12  3  7"])
  (loadInputData "resources/puzzleTestInput.txt")
  (slurp "resources/puzzleTestInput.txt")
  (first [1,2, 3])
  (str/split "1,2,3" ",")
  (first [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1 22 13 17 11 0 8 2 23 4 24 21 9 14 16 7 6 10 3 18 5 1 12 20 15 19 3 15 0 2 22 9 18 13 17 5 19 8 7 25 23 20 11 10 24 4 14 21 16 12 6 14 21 17 24 4 10 16 15 9 19 18 8 23 26 20 22 11 13 6 5 2 0 12 3 7])
  (first ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "22" "13" "17" "11" "0" "8" "2" "23" "4" "24" "21" "9" "14" "16" "7" "6" "10" "3" "18" "5" "1" "12" "20" "15" "19" "3" "15" "0" "2" "22" "9" "18" "13" "17" "5" "19" "8" "7" "25" "23" "20" "11" "10" "24" "4" "14" "21" "16" "12" "6" "14" "21" "17" "24" "4" "10" "16" "15" "9" "19" "18" "8" "23" "26" "20" "22" "11" "13" "6" "5" "2" "0" "12" "3" "7"])

  (re-find #"" ["7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1" "22" "13" "17" "11" "0" "8" "2" "23" "4" "24" "21" "9" "14" "16" "7" "6" "10" "3" "18" "5" "1" "12" "20" "15" "19" "3" "15" "0" "2" "22" "9" "18" "13" "17" "5" "19" "8" "7" "25" "23" "20" "11" "10" "24" "4" "14" "21" "16" "12" "6" "14" "21" "17" "24" "4" "10" "16" "15" "9" "19" "18" "8" "23" "26" "20" "22" "11" "13" "6" "5" "2" "0" "12" "3" "7"])

 
  
  (reduce)
)