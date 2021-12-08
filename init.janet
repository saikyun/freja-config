(import ../../programmering/freja-indent-line/indentation)
(import ../../programmering/freja-jandent/freja-jandent/jandent-format)
(import ../../programmering/freja-eval-last-expr/eval-last-expression)
(import freja/frp :prefix "")
(import freja/state)
(import freja/new_gap_buffer :prefix "")
(import freja/input :prefix "")
(use freja/default-hotkeys)
(import freja/render_new_gap_buffer :as rgb)
(import freja/new_gap_buffer :as gb)
(import freja/file-handling :as fh)
(import freja/events :as e)
(import freja/hiccup :as h)
(import freja/find-file)

(def import-c (require "../../programmering/cgen/import-c/import-c"))
(put module/cache "freja/import-c" import-c)
(def cgen (require "../../programmering/cgen/import-c/cgen"))
(put module/cache "freja/cgen" cgen)

(global-set-key [:control :r] find-file/find-file-dialog)

(global-set-key [:control :k]
                (fn [_]
                  (print "reepeat")
                  (e/put! state/editor-state :force-refresh true)))

(global-set-key [:control :shift :i] show-checkpoints)

(import freja/echoer)
#(import ./show-errors)

#(show-errors/init)

(print "Running my init file :)")

(global-set-key
  [:caps-lock :alt :p]
  (fn [_]
    (:toggle-console state/editor-state)))

(global-set-key
  [:caps-lock :alt :i]
  (fn [_]
    (print "dafuq")
    (gb/replace-content (echoer/state-big :gb) @"")))

(global-set-key
  [:control :alt :p]
  (fn [_]
    (:toggle-console state/editor-state)))

(global-set-key
  [:control :alt :i]
  (fn [_]
    (gb/replace-content (echoer/state-big :gb) @"")))

(setdyn :pretty-format "%.40M")

(set-key search-binds [:caps-lock :n] |(:search-backwards $))
(set-key search-binds [:caps-lock :y] search-dialog)

(global-set-key [:caps-lock :a] select-all)
(global-set-key [:caps-lock :i] copy)
(global-set-key [:caps-lock :b] cut!)
(global-set-key [:caps-lock :.] paste!)
(global-set-key [:caps-lock :e] fh/save-and-dofile)
(global-set-key [:caps-lock (keyword ";")] save-file)
(global-set-key [:caps-lock :/] undo!)
(global-set-key [:caps-lock :y] search-dialog)
(global-set-key [:caps-lock :s] |(:open-file $))
(global-set-key [:caps-lock :shift :y] (fn [props]
                                         (print "formatting")
                                         (-> props
                                             #                                             format-code
                                             #                                             reset-blink
                                             )))
#

(import freja/evaling)

#(global-set-key [:shift :enter] eval-it)

(global-set-key [:control :a] select-all)
(global-set-key [:control :i] copy)
(global-set-key [:control :b] cut!)
(global-set-key [:control :.] paste!)
(global-set-key [:control :p] fh/save-and-dofile)
(global-set-key [:control (keyword ";")] save-file)
(global-set-key [:control :/] undo!)
(global-set-key [:control :y] search-dialog)
(global-set-key [:control :s] |(:open-file $))
(global-set-key [:control :u] |(:goto-line $))
(global-set-key [:control :shift :y] (fn [props]
                                       (print "formatting")
                                       (format! props)))

(set-key gb-binds [:control :shift :y] jandent-format/jandent-format)



(global-set-key [:caps-lock :j] rgb/move-down!)
(global-set-key [:caps-lock :k] rgb/move-up!)
(global-set-key [:caps-lock :shift :j] rgb/select-move-down!)
(global-set-key [:caps-lock :shift :k] rgb/select-move-up!)

(global-set-key [:caps-lock (keyword ";")] forward-char)
(global-set-key [:caps-lock :shift (keyword ";")] select-forward-char)
(global-set-key [:caps-lock :l] backward-char)
(global-set-key [:caps-lock :shift :l] select-backward-char)

(global-set-key [:caps-lock :p] forward-word)
(global-set-key [:caps-lock :shift :p] select-forward-word)
(global-set-key [:caps-lock :o] backward-word)
(global-set-key [:caps-lock :shift :o] select-backward-word)
 