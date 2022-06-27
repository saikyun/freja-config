(defn git-log-stat-since
  [&opt date]
  (let [d (os/date)
        date (or date
                 (string/format "%i-%02i-%02i" (d :year)
                                (inc (d :month)) # 0-indexed
                                (inc (d :month-day)) # 0-indexed
))
        p (os/spawn ["git" "log" "--stat" (string `--since="` date ` 00:00"`)]
                    :p
                    {:out :pipe})
        res
        (:read (p :out) :all)]
    (if (or (nil? res)
            (empty? res))
      (print "No commits found for date " date)
      res)))


(def lines-peg
  ~{:insertions (* (/ ':number ,(fn [v] [:insertions (scan-number v)]))
                   " insertions" (any (if-not (+ "," "\n") 1)))
    :deletions (* (/ ':number ,(fn [v] [:deletions (scan-number v)]))
                  " deletions" (any (if-not (+ "," "\n") 1)))
    :number (some :d)
    :line (* " " :number " file" (opt "s") " changed, " (opt :insertions) (opt ", ") (opt :deletions) "\n")
    :main (some (+ :line
                   (* (any (if-not "\n" 1)) "\n")))})

(defn loc-change-since
  [&opt day]
  (var res @{:insertions 0
             :deletions 0})
  (when-let [git-output (git-log-stat-since day)]

    (loop [v :in (peg/match lines-peg git-output)]
      (match v
        [:insertions v]
        (update res :insertions + v)

        [:deletions v]
        (update res :deletions + v))))
  res)

(defn print-loc-change-since
  [&opt day]
  (when-let [res (loc-change-since day)]
    (cond
      (and (pos? (res :insertions))
           (pos? (res :deletions)))
      (print "You have made " (res :insertions) " insertions and " (res :deletions) " deletions today.")

      (pos? (res :insertions))
      (print "You have made " (res :insertions) " insertions today.")

      (pos? (res :deletions))
      (print "You have made " (res :deletions) " deletions today.")

      (print "*crickets*"))))

(comment
  
  (git-log-stat-since)
  (git-log-stat-since "2022-04-08")

  (loc-change-since)
  (loc-change-since "2022-04-08")

  (print-loc-change-since)
  (print-loc-change-since "2022-04-08")

  #
)
