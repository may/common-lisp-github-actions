;;; sbcl --non-interactive
(require :uiop)
(uiop:run-program (list "curl" "-O" "https://beta.quicklisp.org/quicklisp.lisp"))
(load "quicklisp.lisp")
(quicklisp-quickstart:install)
; --eval '(ql-util:without-prompting (ql:add-to-init-file))' --quit
;(push #p"${{ github.workspace }}" asdf:*central-registry*)
(push (uiop:getenv "GITHUB_WORKSPACE") asdf:*central-registry*)
(print asdf:*central-registry*)
(asdf:compile-system :example-system)
