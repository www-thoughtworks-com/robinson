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
