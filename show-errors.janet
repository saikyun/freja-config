(import freja/state)
(import freja/frp)
(import freja/events :as e)
(import freja/file-handling :as fh)
(import freja/render_new_gap_buffer :as rgb)
(import freja/default-layout :as dl)
(import freja/theme)
(import spork/path)

#TODO: add column
(defn open-file-and-goto-line
  [textarea file line]

  #(e/put! state/editor-state :right dl/default-right-editor)

  (-> textarea
      (fh/load-file file))
  (rgb/goto-line-number (textarea :gb) line)
  (e/put! state/focus :focus textarea))

(comment
  (open-file-and-goto-line gb
                           (stack :source)
                           (stack :source-line))

  #
)

#(debug/stacktrace fib err)

#@[@{:function <function 0x563DE373C950>
#    :pc 6
#    :slots @[<function 0x563DE37B05C0> <fiber 0x563DE36C3A30> nil]
#    :source "freja/file-handling.janet"
#    :source-column 5
#    :source-line 69}]

(defn stack-row
  [{:name name
    :source source
    :source-line source-line}
   editor]
  [:block {}
   [:clickable {:on-click
                (fn [&_]
                  (open-file-and-goto-line
                    editor
                    source
                    source-line))}
    [:padding {:top 6 :bottom 6}
     (when name
       [:text {:size 18
               :text (string name " - ")}])
     [:text {:size 18
             :weight 1
             :text (string source)}]
     [:text {:size 18
             :weight 1
             :text (string " - line: " source-line)}]]]])

(defn show-stack
  [props & _]

  (def err (props :error))

  (def {:error msg
        :source source
        :source-line source-line}
    (if (dictionary? err)
      err
      {}))

  [:background {:color (theme/colors :background)}
   [:padding {:all 6}
    [:padding {:bottom 24}
     [:text {:size 26
             :text
             (if msg
               msg
               (string/format "%p" err))}]]

    (comment
      [:row {}
       [:block {:weight 0.5}
        [:text {:size 18
                :color 0x000000aa
                :text "name"}]]
       [:block {:weight 1}
        [:text {:size 18
                :color 0x000000aa
                :text
                "position"}]]
       [:block {:weight 0.5}
        [:text {:size 18
                :color 0x000000aa
                :text
                "line"}]]]
      #
)

    (when (dictionary? err)
      (stack-row err (props :editor)))

    (let [stack (debug/stack (err :fiber))]
      ;(map |(stack-row $ (props :editor)) stack))

    (when (err :fiber)
      (let [buf @""]
        (with-dyns [:out buf
                    :err buf]
          (debug/stacktrace (err :fiber) (err :error)))
        [:padding {:top 24}
         [:text {:font "MplusCode"
                 :size 18
                 :text buf}]]))]])

(var last-view nil)
(var last-view-was-error? false)

(defn open-stack-view
  [err]
  (unless last-view-was-error?
    (set last-view (state/editor-state :right)))

  (set last-view-was-error? true)

  (def left-editor (get-in state/editor-state [:left-state :editor]))

  # (def stack (debug/stack (err :fiber)))

  (let [{:source source :source-line source-line} err]
    (when (and (= (path/abspath source)
                  (path/abspath (get-in left-editor [:gb :path])))
               (not= (tracev source-line)
                     (tracev (rgb/current-line-number (left-editor :gb)))))
      (open-file-and-goto-line
        left-editor
        source
        source-line)))

  (e/put! state/editor-state :right
          (fn [_]
            [:block {:max-width 500}
             [show-stack {:error err
                          :editor left-editor}]])))

(defn close-stack-view
  []
  (when last-view-was-error?
    (set last-view-was-error? false)
    (print "close")
    (e/put! state/editor-state :right last-view)))

(defn init
  []
  (frp/subscribe! state/eval-results
                  (fn [res]
                    #(print "res?")
                    #(pp res)
                    (if (res :error)
                      (open-stack-view res)
                      (close-stack-view)))))

(comment
  # TODO: do this as a subscription to eval-results

  (def err
    (last
      (filter |($ :error)
              (e/vs frp/eval-results))))

  (open-stack-view err)

  (do
    (frp/subscribe! frp/eval-results
                    (fn [res]
                      (if (res :error)
                        (open-stack-view res)
                        (close-stack-view))))
    :ok)
  #
)
