(ns puzzle.support-functions
  ;; (:require [clojure.string :refer [split]]))
(:require [clojure.string :as str]))


(defmacro printvar
  "Println of var name, type and value"
  [a]
  `(println ~(name a) (type ~a) ~a))

(macroexpand '(printvar d))

(defn loadInputData
  [inputFileName]
  (with-open [rdr (clojure.java.io/reader inputFileName)]
    (reduce conj [] (line-seq rdr))))

(defn getDrawnNumbers
  [inputData]
  (map #(Integer/parseInt %1) (str/split (first inputData) #",")))

(defn convertStringWithIntegerToIntegerList
  ;; todo rename function
  "Assumes max a 2 spaces next to each other"
  [stringWithIntegers]
  (let [stringWithSingleSpaces (str/replace stringWithIntegers #"  " " ")
        stringWithNoLeadingSpace (str/replace stringWithSingleSpaces #"^ " "")]
    (map #(Integer/parseInt %1) (str/split stringWithNoLeadingSpace #" "))))

(defn getNextBoard
  [inputValue]
  (take 25 inputValue))

(defn getBingoBoards
  [inputData]
  (let [boardDataNoEmptyStrings (remove #(= % "") (rest inputData))
        boardDataIntegers (flatten (map #(convertStringWithIntegerToIntegerList %) boardDataNoEmptyStrings))]
    (loop [boardData boardDataIntegers
           acc {}
           id 1]

      (if (= (count boardData) 0)
        acc
        (recur (drop 25 boardData) (assoc acc (keyword (str "board" id)) (getNextBoard boardData)) (inc id))))))

    

(comment

)