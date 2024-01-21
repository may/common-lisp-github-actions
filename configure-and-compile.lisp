;;; sbcl --non-interactive
(load "quicklisp.lisp")
(quicklisp-quickstart:install)
; --eval '(ql-util:without-prompting (ql:add-to-init-file))' --quit
;(push #p"${{ github.workspace }}" asdf:*central-registry*)
(push (uiop:getenv "GITHUB_WORKSPACE") asdf:*central-registry*)
(print asdf:*central-registry*)
(break "for debugging")
(asdf:compile-system :example-system)
