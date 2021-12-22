(ns puzzle.support-functions
  ;; (:require [clojure.string :refer [split]]))
  (:require [clojure.string :as str]))


(defmacro printvar
  "Println of var name, type and value"
  [a]
  `(println ~(name a) (type ~a) ~a))

(defn pp
  [inputValues]
  (clojure.pprint/pprint inputValues))

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
           acc ()
           id 1]
      (if (= (count boardData) 0)
        (flatten acc)
        ;;using into to make the LazySeq from repeat into a PersistentList (faciltates easier unit test)
        (recur (drop 25 boardData) (list acc (hash-map :boardName (str "board" id) :board (getNextBoard boardData) :boardHits (into () (repeat 25 0)))) (inc id))))))
        

(defn updateBoardHits
  "Handles 1 board at a time"
  [board boardHits drawnNumber]
  (if (= drawnNumber -1) ;-1 means initiatize boardHits
    (repeat 25 0)
    
    
    (map #(if (= %1 drawnNumber) (inc %2) %2) board boardHits)
  ))

(defn updateAllBoardHits
  "Handles all boards"
  [boards drawnNumber]
  (map #(update % :boardHits (fn [dummy]
                               (updateBoardHits (:board %) (:boardHits %) drawnNumber)))
       boards))


