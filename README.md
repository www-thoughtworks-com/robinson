robinson
========

A Ruby website link checker that actually works :)

All credit to anemone for doing the actual work.

(in case you were wondering, it weeds out the weakest links)

usage
-----

    robinson <host>[:<port>] [--ignoring <ignorepath> [...]]
  
    e.g. robinson www.example.com
    e.g. robinson localhost:8080 --ignoring /blogfeed /external_content

notes
-----

Checks only internal links on site (this is anemone behaviour, which is used for the actual crawling).
