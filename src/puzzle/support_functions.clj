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
  (map #(if (= %1 drawnNumber) (inc %2) %2) board boardHits))

(defn updateAllBoardHits
  "Handles all boards"
  [boards drawnNumber]
  (map #(update % :boardHits (fn [dummy]
                               (updateBoardHits (:board %) (:boardHits %) drawnNumber)))
       boards))

(defn checkForBingoHor
  [boardHits]
  (loop [currentHits boardHits]
    (if (= (apply + (take 5 currentHits)) 5)
      true
      (if (empty? currentHits)
        false
        (recur (drop 5 currentHits))))))

(defn checkForBingoVer
  [boardHits]
  (loop [currentHits boardHits
         column 1]
    (if (= (apply + (take-nth 5 currentHits)) 5)
      true
      (if (= column 5)
        false
        (recur (drop 1 currentHits) (inc column))))))

(defn checkForBingo
  [boards]
  (loop [currentBoards boards]
    (let [currentBoard (first currentBoards)
          currentBoardHits (:boardHits currentBoard)]
      (if (or (= (checkForBingoHor currentBoardHits) true)
              (= (checkForBingoVer currentBoardHits) true))
        (:boardName currentBoard)
        (if (empty? currentBoards)
          nil
          (recur (drop 1 currentBoards))))))
)


  (defn processDrawnNumbers
    [boards drawnNumbers]
    (loop [currentBoards boards
           remainingNumbers drawnNumbers]
      ;; (printvar currentBoards)
      ;; (printvar remainingNumbers)
      (if (zero? (count remainingNumbers))
        currentBoards
        (recur (updateAllBoardHits currentBoards (first remainingNumbers)) (drop 1 remainingNumbers)))))
