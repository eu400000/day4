(ns puzzle.support-functions
  (:require [clojure.string :as str]))

(defn loadData
  [inputFileName]
  (let [inputString (str/split (slurp inputFileName) #"\r\n")]
    (map #(Integer/parseInt %1) inputString)))
