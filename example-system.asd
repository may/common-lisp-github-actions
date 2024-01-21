;;;; example-system.asd

(asdf:defsystem #:example-system
  :description "Describe example-system here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "example-system")))
