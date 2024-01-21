;;;; In GitHub actions, setup the Common Lisp envionment in a platform-independent
;;;; way. After that, compile the defined program, and optionally create executables
;;;; for release.
;;; sbcl --non-interactive

;; Copyright 2024 Nicholas E. May
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Prep envionment.
;; Download & install Quicklisp in the script rather than the GitHub Actions
;; because it's easier; the downloaded file is already in our working directory.
(require :uiop)
(uiop:run-program (list "curl" "-O" "https://beta.quicklisp.org/quicklisp.lisp"))
(load "quicklisp.lisp")
(quicklisp-quickstart:install)

;;; Compile
;; Tell ASDF about the project we're trying to compile.
;; ASDF needs directories to have trailing paths.
(push (concatenate 'string (uiop:getenv "GITHUB_WORKSPACE") "/") asdf:*central-registry*)
(print asdf:*central-registry*)
(asdf:compile-system :example-system) ; todo 

;;; Optionally create release executables.
;;; We already have the envionment setup, so just keep going.
(if (uiop:getenv "cl-release")
    (progn
      (asdf:load-system :example-system) ; todo 
      (setq uiop:*image-entry-point* #'example-system:hello) ; todo
      (uiop:dump-image
       (if (uiop:os-windows-p)
           "hello.exe" ; todo (concatenate 'string *TODOexename* ".exe")
           "hello") ; todo
       :executable t))
    (print "Not creating executables; configure this in compile-and-release.yaml, line ~40: by setting cl-release to true"))

;; TODO adjust line number as needed.
