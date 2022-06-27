(import freja/default-hotkeys :as dh)
(import ./freja-stedit/freja-stedit/freja-stedit :as fse)

(dh/set-key dh/gb-binds
            # XXX: this is control right paren
            [:control :shift :0]
            (comp dh/reset-blink fse/absorb-forward))

(dh/set-key dh/gb-binds
            # XXX: this is control right curly brace
            [:control :shift :right-bracket]
            (comp dh/reset-blink fse/eject-forward))

'(dh/set-key dh/gb-binds
             [:alt :p]
             (comp dh/reset-blink fse/forward-expr))

'(dh/set-key dh/gb-binds
             [:alt :o]
             (comp dh/reset-blink fse/backward-expr))

(dh/set-key dh/gb-binds
            [:alt :shift (keyword ",")]
            (comp dh/reset-blink fse/select-forward-atom))

(dh/set-key dh/gb-binds
            [:alt :shift :m]
            (comp dh/reset-blink fse/select-backward-atom))

(dh/set-key dh/gb-binds
            [:alt (keyword ",")]
            (comp dh/reset-blink fse/forward-atom))

(dh/set-key dh/gb-binds
            [:alt :m]
            (comp dh/reset-blink fse/backward-atom))

'(dh/set-key dh/gb-binds
             [:alt :j]
             (comp dh/reset-blink fse/forward-down-expr))

'(dh/set-key dh/gb-binds
             [:alt :k]
             (comp dh/reset-blink fse/backward-up-expr))

'(dh/set-key dh/gb-binds
             [:control :alt :a]
             (comp dh/reset-blink fse/backward-start-of-top-level))

(dh/set-key dh/gb-binds
            [:control :alt :e]
            (comp dh/reset-blink fse/forward-end-of-top-level))

(dh/set-key dh/gb-binds
            [:control :alt :k]
            (comp dh/reset-blink fse/delete-forward-expr))

(dh/set-key dh/gb-binds
            [:control :alt :shift :k]
            (comp dh/reset-blink fse/select-forward-expr))
