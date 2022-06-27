(import ./freja-indent-lines-default)
#(import ../../programmering/freja-jandent/freja-jandent/jandent-format)
#(import ../../programmering/freja-eval-last-expr/freja-eval-last-expr/eval-last-expression)
(import ./freja-stedit-defaults)
#(import ../../programmering/parse-symbols/hold-alt)
(import freja/state)
(import freja/new_gap_buffer :prefix "")
(import freja/input :prefix "")
(use freja/default-hotkeys)
(import freja/render_new_gap_buffer :as rgb)
(import freja/new_gap_buffer :as gb)
(import freja/file-handling :as fh)
(import freja/hiccup :as h)
(import freja/find-file)
(import freja/echoer)
(import freja/event/subscribe :as s)
(import ./loc-this-day)

(def text-size 24)

(s/put! state/editor-state :text/size text-size)

(def mod2 :alt)
(def mod1 :right-control)

(global-set-key [mod1 :shift :u]
                (fn [_] (loc-this-day/print-loc-change-since)))

(global-set-key [mod1 :shift :p] echoer/toggle-console)
(global-set-key [mod1 :shift :i] echoer/clear-console)

(global-set-key
  [mod1 :0]
  (fn [_]
    (s/put! state/editor-state :text/size text-size)
    (print "Reset text size: " (state/editor-state :text/size))))

(global-set-key
  [mod1 :-]
  (fn [_]
    (s/update! state/editor-state :text/size |(min 70 (inc $)))
    (print "Updated text size: " (state/editor-state :text/size))))

(global-set-key
  [mod1 (keyword "'")]
  (fn [_]
    (s/update! state/editor-state :text/size |(max 8 (dec $)))
    (print "Updated text size: " (state/editor-state :text/size))))

(global-set-key [mod1 :r] find-file/find-file-dialog)

(set-key search-binds [mod1 :n] |(:search-backwards $))
(set-key search-binds [mod1 :y] search-dialog)

(global-set-key [mod1 :shift :y] (fn [props]
                                   (print "formatting")
                                   (format! props)))

(do comment
  (global-set-key [mod1 :p] fh/save-and-dofile)

  (global-set-key [mod1 :a] select-all)
  (global-set-key [mod2 :a] move-to-start-of-line)
  (global-set-key [mod2 :q] delete-word-backward!)
  (global-set-key [mod2 :w] delete-word-forward!)
  (global-set-key [mod1 (keyword ",")] close-buffer)
  (global-set-key [mod2 :d] move-to-end-of-line)
  (global-set-key [mod2 :u] page-down!)
  (global-set-key [mod2 :i] page-up!)

  (global-set-key [mod1 :i] copy)
  (global-set-key [mod1 :b] cut!)
  (global-set-key [mod1 :.] paste!)

  (global-set-key [mod1 (keyword ";")] save-file)
  (global-set-key [mod1 :/] undo!)
  (global-set-key [mod1 :t] redo!)
  (global-set-key [mod1 :y] search-dialog)
  (global-set-key [mod1 :s] |(:open-file $))
  (global-set-key [mod1 :u] |(:goto-line $)))

#(put gb-binds :control nil)
#(put global-keys :control nil)

(do comment
  (global-set-key [mod2 :j] rgb/move-down!)
  (global-set-key [mod2 :k] rgb/move-up!)
  (global-set-key [mod2 :shift :j] rgb/select-move-down!)
  (global-set-key [mod2 :shift :k] rgb/select-move-up!)

  (global-set-key [mod2 (keyword ";")] forward-char)
  (global-set-key [mod2 :shift (keyword ";")] select-forward-char)
  (global-set-key [mod2 :l] backward-char)
  (global-set-key [mod2 :shift :l] select-backward-char)

  (global-set-key [mod1 :tab] swap-top-two-buffers)

  #(set-key gb-binds [mod1 :shift :y] jandent-format/jandent-format)
)

(global-set-key [mod1 :enter] eval-it)

(global-set-key [mod2 :p] forward-word)
(global-set-key [mod2 :shift :p] select-forward-word)
(global-set-key [mod2 :o] backward-word)
#(set-key gb-binds [mod2 :o] nil)
(global-set-key [mod2 :shift :o] select-backward-word)
