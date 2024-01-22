;;;; In GitHub actions, setup the Common Lisp envionment in a platform-independent
;;;; way. After that, compile the defined program, and optionally create executables
;;;; for release.

;;; sbcl --non-interactive
;; Created: 2024-01-20
;; Revised: 2024-01-21

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

;; Note: You should not need to edit this program (unless something breaks);
;; rather, please edit the values in compile-and-release.yml.
;; If you don't have that file, this one won't do you much good.

;;; Prep envionment.
(require :uiop)

;; See compile-and-release.yml for user-friendly descriptions of these values.
(defparameter *cl-system* (read-from-string (uiop:getenv "cl-system")))
(defparameter *cl-release* (uiop:getenv "cl-release"))
(defparameter *cl-exe-basename* (uiop:getenv "cl-exe-basename"))

;; Download & install Quicklisp in the script rather than the GitHub Actions
;; because it's easier; the downloaded file is already in our working directory.
(uiop:run-program (list "curl" "-O" "https://beta.quicklisp.org/quicklisp.lisp"))
(load "quicklisp.lisp")
(quicklisp-quickstart:install)

;;; Compile
;; Tell ASDF about the project we're trying to compile.
;; ASDF needs directories to have trailing paths.
(push (concatenate 'string (uiop:getenv "GITHUB_WORKSPACE") "/") asdf:*central-registry*)
(print asdf:*central-registry*)
(asdf:compile-system *cl-system*)

;;; Optionally create release executables.
;;; We already have the envionment setup, so just keep going.
(if *cl-release*
    (progn
      (asdf:load-system *cl-system*)
      (setq uiop:*image-entry-point*
            ;; Convert the function specified in the .yml config into a function object.
            (symbol-function (find-symbol (string-upcase
                                           (uiop:getenv "cl-exe-entry-function")))))
      (uiop:dump-image
       (if (uiop:os-windows-p)
           (concatenate 'string *cl-exe-basename* ".exe")
           *cl-exe-basename*)
       :executable t))
    (print "Not creating executables; configure this in compile-and-release.yml, line ~45: by setting cl-release to true"))
