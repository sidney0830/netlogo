; SKIN - Simulating Knowledge Dynamics in Innovation Networks
; Nigel Gilbert, Petra Ahrweiler, Andreas Pyka
;
; Copyright Nigel Gilbert, Petra Ahrweiler, Andreas Pyka (C) 2003-2010
;
; version 2.0  25 August 2003
; version .1  1 September 2003   Bugs caused by extreme parameter values removed.
;                                Partnerships added
; version .2  17 September 2003  Networks added
; version .3  26 October  2003   Some network bugs removed and plots added
; version .4   1 November 2003   Economy added
; version .5   8 November 2003   Bugs, converted to NetLogo 2.0
; version .7  12 November 2003   Partners cannot be from networks
; version .9  13 November 2003   (Hamburg) Network bugs removed
; version 3.0 14 November 2003   Tidy up; make environmental inputs and outputs product ranges
; version .2  27 December 2003   Changed incremental research direction setting
; version .3  27 December 2003   Network graphics
; version .6   2 January  2004   Herfindahl index, bug fixes, shorter partner search
; version .7  15 February 2004   Connectivity graph; variable start-ups; random initial capital;
;                                increased radical research threshold; changed network display
; version .8  24 January  2006   Added degree distribution plot
; version .9  31 May      2006   Added code for Behaviour Space runs
; version 4.0 16 June     2006   Real valued abilities, many bug fixes
; version 4.22 16 August  2006   IH no longer dependent on Abilities
;                                Networks now cost partners to create
; version 4.23 19 August  2006   Stop crashing in make-networks
; version 4.24 19 August  2006   reward-to-trigger-start-up adjusted to 950
; version 4.27 5 September 2006  Increase final-price; changed back to map-artefact; using cost-plus pricing;
;                                incr-step now proportional to capability value
; version 5    23 April   2010   Stripped down and simplified version of v4.29, converted to NetLogo 4.1

; Notes:
;   A firm cannot be a member of more than 1 network at any one time
;   In the plots, networks are included in the count of firms (but not partnerships)

 extensions [ nw ]


; globals preceded by ';' below are set by sliders, not by code
globals [
;   nFirms                       ; the number of firms initially
;   nProducts                    ; the number of products that are possible
;   nInputs                      ; the maximum number of inputs that a firm can require
;   n-big-firms                 ; number of firms with 10 times initial capital of rest
;   reward-to-trigger-start-up   ; a start-up is created when the best reward in the
;                                   round is more than or equal to this
;   attractiveness-threshold     ; how attractive a firm must be before it becomes a
                                 ;    partner
;   partnership-strategy         ; whether partners as alike (conservative) or as different
                                 ;    as possible are sought
;   success-threshold            ; how successful an innovation must be before it is a
                                 ;    success
;   in-out-products-percent      ; percentage of the product range which are raw-materials and
                                 ;  end-user products e.g. 0 -> (in-out-products-percent / 100) are raw-materials
;   initial-capital              ; the capital that a firm starts with

;   initial-capital-university   ; the capital that a university starts with

;   reward-to-trigger-university-start-up  ; a university start-up is created when the best reward in the round is more than or equal to this
  
  
  initial-capital-for-big-firms  ; the amount of start-up capital for those firms set to be 'big'
  initial-capital-for-big-universities  ; the amount of start-up capital for those universities set to be 'big' 
  maxPrice                       ; maximum initial price of any product
  maxQuality                     ; maximum initial quality of any product
  max-ih-length                  ; maximum length of an innovation hypothesis
  nCapabilities                  ; global number of capabilities possible
  nCapabilities-university       ;; Added by Yao-Ching
  
  low-capital-threshold          ; if a firm's capital is below this, it does radical
                                 ;    research
  capital-knowledge-ratio        ; proportionality between kene length and firm's
                                 ;    capital
  incr-research-tax              ; tax paid for one step of incremental research
  radical-research-tax           ; tax paid for one step of radical research
  collaboration-tax              ; tax paid for every partnership per step
  depreciation                   ; tax paid per step by every firm
  raw-cost                       ; the cost of a unit of raw material
  final-price                    ; the selling price of a unit sold to the end-user
  max-partners                   ; the maximum number of potential partners a firm searches for
  max-university-partners        ; the maximum number of potential partners a university searches for. Added by Yao-Ching
  
  raw-materials                  ; the inputs that come from the environment are
                                 ;      numbered 0 up to (but not including) this
  raw-materials-university       ; the inputs that come from the environment are
                                 ;      numbered 0 up to (but not including) this
                                 ;; Added by Yao-Ching
  end-products                   ; the outputs that are bought by the end-user (final consumers) are
                                 ;      numbered greater than end-products
                                 
                                 ;; added by Yao-Ching
  firm-number                    ; for counting firm 
  university-number              ; for counting university
]

breed [ firms firm]              ; the firm agents
breed [ networks network]        ; an association of several firms

                                 ;; added by Yao-Ching
breed [universities university]  ; the university agents 

firms-own [
  ;kene
  capabilities                    ; the Firms kene part 1
  abilities                       ; the Firms kene part 2
  expertises                      ; the Firms kene part 3
  ih                              ; the firm's innovation hypothesis
                                  ;     (the locations of the ih kene triples )
  new-ih?                         ; true when a new IH has been generated
  advert                          ; a list of the capabilities of my innovation
                                  ;     hypothesis
  ;research
  research-direction              ; direction of changing an ability
                                  ;     (for incremental research)
  ability-to-research             ; the ability that is being changed by incremental
                                  ;     research
  done-rad-research               ; true if the firm has just done radical research
  partners                        ; agentset of my current partners
  previous-partners               ; agentset of firms with which I have previously
                                  ;     partnered
                                  
  previous-university-partners    ; agentset of universities with which I have proviously partnered
                                  ;; Added By Yao-Ching
  
  suppliers                       ; list of suppliers
  customers                       ; list of customers

  ;product
  product                         ; the product produced by this firm (a number)
  inputs                          ; the products required as inputs to make the product
  quality                         ; the quality of the product
  selling?                        ; whether I could make the product to sell this round
                                  ;      (I can make product only if all my inputs are
                                  ;      available to me)
  trading?                        ; whether I could make the product at a profit
  total-cost                      ; the total of the prices charged by suppliers for my inputs
  price                           ; the price I want to sell the product for
  sales                           ; the total amount received from selling in this round
  last-reward                     ; the profit received by the firm last time

  ;firm
  capital                         ; the amount of capital of the firm
  net                             ; the network I am a member of
  age                             ; steps since the firm was started
  hq?                             ; is this a firm representing the headquarters of a network?
  
  
  ;; Added By Yao-Ching
  number                          ; number of firm
  
  collaborate-universities        ; agentset of university that firm collaborate
]

networks-own [
  hq                              ; the firm object that does this network's work
  members                         ; the firms that constitute this network
]

universities-own [
    ;kene
  capabilities                    ; the Firms kene part 1
  abilities                       ; the Firms kene part 2
  expertises                      ; the Firms kene part 3
  ih                              ; the firm's innovation hypothesis
                                  ;     (the locations of the ih kene triples )
  new-ih?                         ; true when a new IH has been generated
  advert                          ; a list of the capabilities of my innovation
                                  ;     hypothesis
  ;research
  research-direction              ; direction of changing an ability
                                  ;     (for incremental research)
  ability-to-research             ; the ability that is being changed by incremental
                                  ;     research
  done-rad-research               ; true if the firm has just done radical research
  partners                        ; agentset of my current partners
  previous-partners               ; agentset of firms with which I have previously
                                  ;     partnered
                                  
  previous-firm-partners          ; agentset of firm with which I have proviously partnered
                                  ;; Added By Yao-Ching
                                                                    
  suppliers                       ; list of suppliers
  customers                       ; list of customers

  ;; product
  product                         ; the product produced by this firm (a number)
  inputs                          ; the products required as inputs to make the product
  quality                         ; the quality of the product
  selling?                        ; whether I could make the product to sell this round
                                  ;      (I can make product only if all my inputs are
                                  ;      available to me)
  trading?                        ; whether I could make the product at a profit
  total-cost                      ; the total of the prices charged by suppliers for my inputs
  price                           ; the price I want to sell the product for
  sales                           ; the total amount received from selling in this round
  last-reward                     ; the profit received by the firm last time

  ;; university
  capital                         ; the amount of capital of the university
  net                             ; the network I am a member of
  age                             ; steps since the university was started
  hq?                             ; is this a firm representing the headquarters of a network?
  
  collaborable?                   ; boolean, whether the university could collaborate with firm or not.

  number
]


to setup
  clear-all
  crt 2 [create-links-with other turtles]
  nw:set-context turtle-set turtles link-set links
  show map sort nw:get-context
  ;create-turtles 3 [ create-links-with other turtles ]
  ;nw:set-context turtles links
  ;show map sort nw:get-context
  
  no-display
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  ask patches [set pcolor white ]

  ; set basic global parameters

  ;   set initial-capital 10000                ; set with an interface slider
  set initial-capital-for-big-firms initial-capital * 10
  set initial-capital-for-big-universities initial-capital-university * 10
  ;   set nProducts 50                         ; set with an interface slider
  ;   set nFirms 100                           ; set with an interface slider
  ;   set nInputs 4                            ; set with an interface slider
  set maxPrice 1000
  ;   set success-threshold 800                ; set with an interface slider
  ;   set reward-to-trigger-start-up 950       ; set with an interface slider
  set max-ih-length 9                          ; innovation hypothesis
  set nCapabilities 1000
  set nCapabilities-university nCapabilities * nTimesOfFirmCapabilities  ;; Added By Yao-Ching
  
  ;   set attractiveness-threshold 0.4         ; set with an interface slider
  set low-capital-threshold 1000
  set capital-knowledge-ratio 20 ;50
  set depreciation 100
  set incr-research-tax 100
  set radical-research-tax 100
  set collaboration-tax 100
  set max-partners 5
  set max-university-partners 5

  ; in an open system, the products with the lowest product numbers are 'raw materials',
  ; always available and always sold at a low price (raw-cost) and the products with the
  ; highest product numbers are 'end-products', always purchased by consumers with
  ; inexhaustible demand at a high price (final-price).  The proportions of products that
  ; are raw-materials and end-products is set with the in-out-products-percent slider.
  set raw-cost 1
  set final-price 10 * maxPrice
  set raw-materials floor nProducts * in-out-products-percent / 100
  set raw-materials-university floor nProducts * in-out-products-percent / 100  ;; Added by Yao-Ching
  set end-products  ceiling nProducts * ( 100 - in-out-products-percent) / 100

  set firm-number 0

  initialise-firms                 ; create a population of firms
  ask firms [ setup-firm ]
  
  initialise-universities
  ask universities [ setup-university ]

  show-plots TRUE
  show-plots-universities TRUE
end

; make firms as empty shells, yet to be filled with knowledge

to initialise-firms
  create-firms nFirms [
    hide-turtle
    set capital initial-capital
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-firms-percent / 100) * nFirms) firms [ ;;bug fix for v 5-32: added /100
    ;; n-of size agnetset/list => Randomly chose n agents
    set capital initial-capital-for-big-firms
  ]
  ask firms [ initialise-firm ]
end


;; make firms as empty shells, yet to be filled with knowledge
;; added by Yao-Ching

to initialise-universities
  create-universities nUniversities [
    hide-turtle
    set capital initial-capital-university
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-universities-percent / 100) * nUniversities) universities [ ;;bug fix for v 5-32: added /100
    ;; n-of size agnetset/list => Randomly chose n agents
    set capital initial-capital-for-big-universities
  ]
  ask universities [ initialise-university ]
end

; initialise all the firm's variables (except capital, previously set)

to initialise-firm
  set ih []
  set inputs []
  set research-direction "random"
  set done-rad-research false
  set partners no-turtles
  set previous-partners no-turtles
  set suppliers []
  set customers []
  set new-ih? true
  set selling? false
  set trading? false
  set net nobody
  set hq? false
  set age 0
  set capabilities []              ; create a null kene
  set abilities []
  set expertises []
  set number firm-number
  set firm-number firm-number + 1
  set collaborate-universities no-turtles  ;; added by Yao-Ching
  set previous-university-partners no-turtles ;; added by Yao-Ching
end

to initialise-university
  set ih []
  set inputs []
  set research-direction "random"
  set done-rad-research false
  set partners no-turtles
  set previous-partners no-turtles
  set suppliers []
  set customers []
  set new-ih? true
  set selling? false
  set trading? false
  set net nobody
  set hq? false
  set age 0
  set capabilities []              ; create a null kene
  set abilities []
  set expertises []
  set number university-number
  set university-number university-number + 1
end

; set up a single firm with all its required knowledge

to setup-firm
  make-kene
  make-innovation-hypothesis
  make-advert
  manufacture
end

to setup-university
  make-kene
  make-innovation-hypothesis
  make-advert
;;  manufacture  

  file-open "123.txt"
 
  file-write "=========================="
  file-write number
  file-write "=========================="
  file-print ""
  file-print advert
  file-print "=========================="
  file-close
  
end

to go
  if maxPrice = 0 [ setup ]  ; if the setup button hasn't been pressed, do it now
  if count firms = 0 [ stop ]       ; stop if all firms have gone bankrupt
  
  ask universities [
    do-research
;;    manufacture
    pay-taxes
  ]
  
  find-universities  ;; Firm find the availiable university to collaborate
                     ;; Added by Yao Ching

  ask firms [
    if partnership-strategy != "no partners" [ collaborate ]
    
    collaborate-with-university ;; Added By Yao-Ching
    
    do-research
    manufacture
    pay-taxes
  ]
  
  find-suppliers
  buy
  
  ask firms [
    take-profit
    adjust-price
  ]
  
  create-start-ups
  create-university-start-ups  ;;  Added By Yao-Ching
  
  create-nets
  show-plots FALSE
  show-plots-universities FALSE
  ask networks [ distribute-network-profits ]
  ask firms [ do-admin ]
  
  ask firms [ decrease-expertises ]
  
  ;; Added By Yao-Ching 2015/01/02
  ; get capital from government every tick
  ask universities [ get-capital-from-government ]

  ;;; save each firm attribute
  ask firms [ out-put-attributes ]
  ask universities [ out-put-attributes ]
  tick
end


;;; KNOWLEDGE LEVEL
;;;
;;;  create kene, innovation hypothesis, advert etc.
;;;

; a kene is a set of triples of capability, ability and expertise.  These are held as
; three arrays (vectors).  The length of the kene is proportional to the capital of the firm.

;firm procedure
to make-kene
  ;; the length of the kene is defined by the capital of the firm
  ;; but cannot be less than 5 triples.
  ;; the length is proportional to the log of 1 +  the capital divided
  ;; by the capital-knowledge-ratio

  file-open ("breed.txt") ; for debug
  let cap-capacity 0
  
  if breed = firms [
      set cap-capacity ln (1 + (capital / capital-knowledge-ratio))
      if cap-capacity < 5 [ set cap-capacity 5 ]
      file-print "firm"
   ] 
  
  ;; Added by Yao-Ching
  if breed = universities [
      ; cap-capacity is two times of firm's
      set cap-capacity ln (1 + (capital / capital-knowledge-ratio)) * nTimesOfFirmCapabilities
      if cap-capacity < 5 [ set cap-capacity 5 * nTimesOfFirmCapabilities ]  
      file-print "university"
   ]
   
   file-close


  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and nCapabilities, such that no number is repeated
  while [length capabilities < cap-capacity] [
    let candidate-capability 0
    ;; Added by Yao-Ching
    ; identified the type of breed and set different nCapabilities
    if breed = firms [
      set candidate-capability random nCapabilities + 1
    ]
    if breed = universities [
      set candidate-capability random nCapabilities-university + 1
    ]
    if not member? candidate-capability capabilities [
      set capabilities fput candidate-capability capabilities
    ]
    ;; show member? 2 [1 2 3]   show member? turtle 0 turtles
    ;; fput => Adds item to the beginning of a list and reports the new list.  // set mylist fput 2 mylist
  ]
  ; now fill the ability and expertise vectors
  ; with real numbers randomly chosen from 0 .. <10 for abilities
  ; and integers from  1 .. 10 for expertise levels
  while [ length abilities < length capabilities ] [
    set abilities fput (random-float 10.0) abilities
    set expertises fput ((random 10) + 1) expertises
  ]
end




; an innovation hypothesis is a vector of locations in the kene.  So, for example, an IH
; might be [1 3 4 7], meaning the second (counting from 0 as the first), fourth, fifth
; and eighth triple in the kene.  The IH cannot be longer than the length of the kene,
; nor shorter than 2, but is of random length between these limits.

;firm procedure
to make-innovation-hypothesis
  set ih []
  let location 0
  let kene-length length capabilities
  let ih-length min (list ((random max-ih-length) + 2) kene-length)
  while [ ih-length > 0 ] [
    set location random kene-length
    if not member? location ih [
      set ih fput location ih
      set ih-length ih-length - 1
    ]
  ]
  ; reorder the elements of the innovation hypothesis in numeric ascending order
  set ih sort ih

  ; initialise incremental research values, since this is a new innovation hypothesis, and
  ;  previous research will have been using a different IH
  set research-direction "random"
  ; ensure that a new product, quality and set of inputs are calculated for the firm
  set new-ih? true
end

; set up the firm's advert, which is the list of capabilities in its innovation
; hypothesis

;firm procedure
to make-advert


  set advert map [ item ? capabilities ] ih
  ;; 回傳 在ih位置的capabilities的element
  ;; observer> show map [item ? [695 422 544 588 917 232 117]] [1 2 3 5 6]
  ;;                               0   1   2   3   4   5   6
  ;; observer: [422 544 588 232 117]
  
  if breed = universities [
      file-open "maydaycha.txt"
      file-print "============================"
      file-print "capabilities"
      file-print capabilities
      file-print "ih"
      file-print ih
      file-print "advert"
  
 
      file-print "advert"
      file-print advert
 
  
      file-print "============================"
    ]
  

  
  
end

; a firm's product is computed from its innovation hypothesis, using the capabilities and
;    abilities.  It may not be a raw-material.
;firm procedure
to make-product
  set product map-artefact ih raw-materials nProducts
  ; if the customer is an end user, the income from a sale of the product is fixed at 'final-price',
  ; otherwise set price to random
  ifelse product > end-products
  [ set price final-price ]
  [ set price (random maxPrice) + 1 ]
end

; the quality of a firm's product is computed from the abilities and expertise in its
; innovation hypothesis: it is the sum (modulo 10) of the product of the abilities and
; (1 - e to the power of the corresponding expertise level)

;firm procedure
to make-quality
  set quality
    (reduce [?1 + ?2]
      (map [ (item ? abilities) * (1 - exp (- (item ? expertises))) ]
        ih))
  mod 10
end

; the mapping from innovation hypothesis to product number
; the product is the sum (modulo the total number of products) of the product of the
; capabilities and the abilities in the innovation hypothesis
; NB this is different from the Cybernetics and Systems article, which says that it is
; composed from only capabilities (if that were the case, incremental research would
; never have an effect on a product).

to-report map-artefact [ locations bottom top]
  report int
    ((reduce [?1 + ?2]
      (map [ (item ? capabilities) * (item ? abilities) ] locations)) mod (top - bottom)) + bottom
end

; calculate what products a firm needs for its inputs.
; This is done by chopping the innovation hypothesis into sections, one for each input, and
; then mapping the section into a product using a mapping function

;firm procedure
to make-inputs
  set inputs []

  ; the number of inputs (ingredients) required for the product derived from this IH is between 1 and nInputs,
  ;     but not more than the length of the IH

  let number-of-inputs min (list (length ih) (random nInputs + 1))

  ; keep choosing a chunk of the IH, working out what ingredient this represents, and checking this is unique
  ; and not the same as the product until the required number of inputs have been determined.

  ; it can happen that it is impossible to find a distinct set of inputs and product, especially if the
  ; innovation hypothesis is short.  In such cases, give up.

  let tries 0

  while [ length inputs < number-of-inputs and tries < 10 * number-of-inputs ] [
    let start-loc random length ih
    let end-loc start-loc + random (length ih - start-loc)
    let input map-artefact (sublist ih start-loc (end-loc + 1)) 0 end-products
    ifelse input != product and not member? input inputs [
      set inputs fput input inputs
    ]
    [ set tries tries + 1 ]
  ]

  if length inputs < number-of-inputs [
    ; failed to find a set of distinct inputs
    ; set the input to an 'impossible' product, so this firm
    ; never actually manufactures
    set inputs (list (nProducts + 1))
  ]

  ; stop firms that have only raw-material
  ; inputs and make an end-user product -
  ; that's cheating!
  if product > end-products [
    let raw-inputs-only true
    foreach inputs [
      if ? > raw-materials [ set raw-inputs-only false ]
    ]
    if raw-inputs-only [ set inputs (list (nProducts + 1)) ]
  ]
end

; calculate the product that will be made, the inputs that will be required and
; the quality of the product.  Adjust my expertise.
; The product will not change unless the innovation hypothesis has changed.
; Nor will the inputs required.  The quality will change if expertises have changed
; (and normally they will have).

; firm procedure
to manufacture
  if new-ih? [
    make-product
    make-inputs
    set new-ih? false
    set trading? false
  ]
  make-quality
  adjust-expertise
end


;;; MARKET LEVEL
;;;
;;; find suppliers for each input, put on market, try to sell product and collect money
;;;


;; a firm doesn't know whether its inputs can be supplied.  Even if it finds a potential supplier,
;; that supplier may not be able to produce because it can't find a supplier for its inputs!
;; Hence, we first treat all firms as possible producers, and then eliminate those that
;; cannot actually produce, because no-one is offering the required inputs or no-one wants
;; the firm's product, until there is no further change and all firms have been classified as either
;; potentially able to supply or definitely not (selling? is true or false respectively).

;; First, check that some firm produces all the inputs a firm requires: if not discard the firm
;; Then loop discarding firms that produce products that no one in the remaining pool of firms
;; wants, and firms that require inputs that no one in the pool produces and firms that would make
;; a loss if they did produce.
;; Continue discarding until there is no further change and set the remaining firms in the pool
;; as 'selling'.  These are the firms that engage in market transactions in this time step.

; observer procedure
to find-suppliers
  ask firms [set selling? false ]
  let possible-firms firms with [ inputs-available firms ]
  let previous-possible-firms no-turtles
  while [ possible-firms != previous-possible-firms ] [
    set previous-possible-firms possible-firms
    ; discard firms that make products no one wants to buy
    set possible-firms possible-firms with [ product-desired possible-firms ]
    ; discard firms that require inputs that no one is able to supply
    set possible-firms possible-firms with [ inputs-available possible-firms ]
  ]
  ; the firms remaining are those that have a product to sell
  ask possible-firms [set selling? true ]

  ; discard firms for which the price of the inputs is greater than the price charged for the product
  ; such firms are 'selling' but not 'trading'
  set previous-possible-firms no-turtles
  while [ possible-firms != previous-possible-firms ] [
    set previous-possible-firms possible-firms
    set possible-firms possible-firms with [ profitable possible-firms ]  ;; also set the supplier in this line (profitable possible-firms)
  ]
  ask firms [set trading? false ]
  ask possible-firms [set trading? true ]
end

;; Add by Yao-Ching
;; observer procedure

to find-universities
  ask universities [set selling? false]
  let possible-universities universities with [ inputs-available-university universities ]
  let previous-possible-universities no-turtles
  while [ possible-universities != previous-possible-universities ] [
    set previous-possible-universities possible-universities
    ; discard firms that make products no one wants to buy
    ;set possible-universities possible-universities with [ product-desired possible-universities ]
    ; discard firms that require inputs that no one is able to supply
    set possible-universities possible-universities with [ inputs-available-university possible-universities ]
  ]
  
  ask possible-universities [ set selling? true ]
  ask universities [ set collaborable? false ]
  ask possible-universities [ set collaborable? true ]
  
  ;;ask universities [ file-print number ]
      
end



;; return true if at least one of the firms in the market (an agentset)
;;  would like to buy my product (or the product could be bought by
;;  an end-user)

; firm procedure
to-report product-desired [ market ]
  let my-product product
  ; if the product is an end-user product it is always in demand
  if my-product > end-products [ report true ]
  let found-demand false
  report any? market with [member? my-product inputs]
end

;; return true if there is at least one firm in the market (an agentset)
;; wanting to supply each of the inputs I need in order to produce my product
;; firm procedure

;firm procedure
to-report inputs-available [ market ]
  foreach inputs [
    ; the input must a raw-material (always available) or produced by some firm in the
    ; market - if neither, at least one of the inputs required is not available
    if ? >= raw-materials and not any? market with [ ? = product ]  [ report false ]
  ]
  report true
end


;; return true if there is at least one university that can wait to supply firm to use his intelligence 
;university procedure
to-report inputs-available-university [ market ]
  foreach inputs [
    if ? >= raw-materials-university and not any? market with [ ? = product ] [ report false]
   ]
  report true
end

;; return true if, using the cheapest suppliers, the total cost of the inputs available from
;; other firms in the market is less than the price the firm is proposing to charge for its product.
;; At the same time, identify and record the best suppliers of the inputs.

; firm procedure
to-report profitable [ market ]
  if not (product-desired market) [ report false ]
  if not (inputs-available market) [ report false ]
  ; find suppliers if the firm cannot just use the same suppliers as last time
  if not trading? [
    set suppliers []
    foreach inputs [
      let supplier nobody
      ifelse ? >= raw-materials [
        ; find all suppliers of this input
        let possible-suppliers market with [? = product ]
        ; find cheapest
        let cheapest-suppliers possible-suppliers with-min [ price ]
        ; if there is more than one at this price, find one with best quality
        set supplier max-one-of cheapest-suppliers [ quality ]
      ]
      [ ; raw materials are always available
        set supplier "raw-material"
      ]
      set suppliers fput supplier suppliers
    ]
  ]
  ; report true if the firm would make a profit if it sold the product
  report (price > cost-price)
end

;; report the total cost of the inputs required to create the firm's product

;firm procedure
to-report cost-price
  let total 0
  foreach suppliers [
    ifelse ? = "raw-material"
    [ set total total + raw-cost ]
    [ set total total + [ price ] of ? ]
  ]
  report total
end

;; after all that, actually purchase the inputs from my selected suppliers,
;; reducing my available capital and incrementing the number of customers and
;; and sales total of each of the suppliers

; observer procedure
to buy
  ask firms [ set sales 0 set customers [] ]
  ask firms with [ trading? = true ] [
    purchase
  ]
end

;firm procedure
to purchase
  set total-cost 0
  foreach suppliers [
    ifelse ? = "raw-material"
      [
        set total-cost total-cost + raw-cost
      ]
      [
        set total-cost total-cost + [price] of ?
        ask ? [
          set capital capital + price
          set customers fput myself customers
          set sales sales + price
        ]
      ]
  ]
  ; buy the inputs from my capital
  set capital capital - total-cost
  ; if the firm is producing a consumer product, sell it to the end user
  if product > end-products [
    set capital capital + final-price
    set sales sales + final-price
    set customers fput "end-user" customers
  ]
end

;; calculate the profit I have made from selling my product

;firm procedure
to take-profit
  set last-reward 0
  
  ;; Added By YaoChing
  ;; Give the profit to collaborate universities
  if trading?  [
    let profit length customers * (price - total-cost)
    let universities-profit profit * (Percentage-Of-Profit-To-Give-To-University / 100)  ;; every university get the <Percentage-Of-Profit-To-Give-To-University>% of profit of firm
    
    ask collaborate-universities [
      set capital (capital + universities-profit)
      set last-reward universities-profit
    ]
    set profit profit - (count collaborate-universities * universities-profit)
   ;; set last-reward length customers * (price - total-cost)
    set last-reward profit
  ]
end


;;; COLLABORATION
;;;
;;; find partners to collaborate with and form partnerships
;;;

; find some partners to form partnerships with, if the current product is not selling

;firm procedure
to collaborate
  if not Partnering [ stop ]

  if not trading? [
    find-partners
    if any? partners  [ learn-from-partners ]
    pay-tax collaboration-tax * count partners
  ]
end

to collaborate-with-universities
  if not Collborate-With-Universities [ stop ]
  
  if not trading? [
    find-university-partners
    if any? collaborate-universities [ learn-from-collaborate-universities ]
    pay-tax collaboration-tax * count collaborate-universities
  ]
end

; firm procedure
to collaborate-with-university
  
  ;; Modified By Yao-Ching

  let cadidates universities with [ collaborable? = true ]
  
  let random-number-of-universities random 3 + 1  ;; number of universities that will collaborate with
  
  let start-number 0
  
  if count cadidates > 0  [ 
      while [ start-number < random-number-of-universities ] [
       set collaborate-universities (turtle-set (one-of cadidates) collaborate-universities)  ;; random selet the university that is able to collaborate
       set start-number start-number + 1
      ]
  ]
end

; try up to max-partners (5) times to find partners to collaborate with, looking first at previous
; partners and then at suppliers, customers and finally others.  For each partner
; found, tell the partner that I am now a partner

;firm procedure
to find-partners
  let candidates no-turtles

  ; collect together all the firms I know from past experience
  ; note some 'suppliers' and 'customers' might be the string 'raw-material' or 'end-user'
  set candidates (turtle-set previous-partners (filter [is-firm? ?] suppliers) (filter [is-firm? ?] customers))
  ; if there are not enough, augment the list with random firms
  if count candidates < max-partners [
    ; if there are very few firms left, there may not be enough in the pool
    ; to provide the extra ones needed, and in this case just use those that are available
    let xtra min (list (max-partners - count candidates) (count firms))
    set candidates (turtle-set candidates n-of xtra firms) 
  ]
  ; if the resulting list of candidate partners is now too long, chop the end ones
  if count candidates > max-partners [ set candidates n-of max-partners candidates ]

  ; now have a set of exactly max-partners candidates.  Select those that are compatible
  ; as actual partners
  set candidates candidates with [ compatible? myself ]
  set partners (turtle-set partners candidates)
  ; add the new partner to my partners
  ask candidates [ set partners (turtle-set myself partners) ]
end

;; Added By Yao-Ching
;; find university partners
to find-university-partners
  let candidates no-turtles
  
  set candidates (turtle-set previous-university-partners (filter [is-university? ?] collaborate-universities) )
  
  if count candidates < max-university-partners [ 
    let xtra min (list (max-university-partners - count candidates) (count universities))  
    set candidates (turtle-set candidates n-of xtra universities)
  ]
  
  if count candidates > max-university-partners [ set candidates n-of max-university-partners candidates ]
  
  set candidates candidates with [ compatible? myself ]
  
  set collaborate-universities (turtle-set collaborate-universities candidates)
end

; reports true or false according to whether the possible partner is sufficiently attractive,
; according to the current partnership strategy

;firm procedure
to-report compatible? [ possible-partner ]
  let attractiveness 0

  ; reject impossible potential partners (cannot partner with myself or with the HQ of a network)
  if possible-partner = self or [hq?] of possible-partner [ report false ]
  ; a partner cannot already be a member of my network
  if net != nobody and member? possible-partner [members] of net [ report false ]
  ; a possible partner cannot already be a partner of mine
  if member? self [partners] of possible-partner or member? possible-partner partners [report false]
  ifelse partnership-strategy = "conservative"
    [ set attractiveness (length intersection advert [advert] of possible-partner) /
      (min list length advert length [advert] of possible-partner) ]
    [ ifelse (length intersection advert [advert] of possible-partner) >= 1
      [ set attractiveness (length set-difference advert [advert] of possible-partner) /
        (length advert + length [advert] of possible-partner) ]
      [ set attractiveness 0 ]
    ]
  report attractiveness > attractiveness-threshold
end

; reports the set intersection of the lists a and b, treated as sets

to-report intersection [ set-a set-b ]
  let set-c []
  foreach set-a [ if member? ? set-b [ set set-c fput ? set-c ] ]
  report set-c
end

; reports the set difference of lists a and b, treated as sets
to-report set-difference [ set-a set-b ]
  let set-c intersection set-a set-b
  set set-b remove-duplicates sentence set-a set-b
  foreach set-c [ if member? ? set-b [ set set-b remove ? set-b ] ]
  report set-b
end

; obtain capabilities from partners.  The capabilities that are learned are those
; from the partners' innovation hypothesis.

;firm procedure
to learn-from-partners
    ask partners [ merge-capabilities myself ]
    make-innovation-hypothesis
end



;; Added By Yao-Ching
to learn-from-collaborate-universities
;;  ask self [ merge-capabilities ? ]
  ask collaborate-universities [ merge-capabilities myself ]
  make-innovation-hypothesis
end

;firm procedure
to merge-capabilities [ other-firm ]
  add-capabilities other-firm
  ask other-firm [ add-capabilities myself ]
end

; for each capability in the other's innovation hypothesis, if it is new to me,
; add it (and its ability) to my kene (if I have sufficient capital), and make
; the expertise level 1 less. For each capability that is not new, if the other's
; expertise level is greater than mine, adopt its ability and expertise level,
; otherwise do nothing.

;firm procedure
to add-capabilities [ other-firm ]
  let my-position 0
  foreach [ih] of other-firm [
    let capability item ? [capabilities] of other-firm
    ifelse member? capability capabilities [
      ;  capability already known to me
      set my-position position capability capabilities
      if item my-position expertises < item ? [expertises] of other-firm [
        set expertises replace-item my-position expertises item ? [expertises] of other-firm
        set abilities replace-item my-position abilities item ? [abilities] of other-firm
      ]
    ]
    [
    ; capability is new to me; adopt it if I have 'room'
    if (length capabilities) < ((capital / capital-knowledge-ratio) + 1) [
      set capabilities sentence capabilities capability
      set abilities sentence abilities item ? [abilities] of other-firm
      let other-expertise (item ? [expertises] of other-firm) - 1
      ; if other-expertise is 1, it is immediately forgotten by adjust-expertise
      if other-expertise < 2 [set other-expertise 2 ]
      set expertises sentence expertises other-expertise
    ]
  ]
]
end


;;;  RESEARCH
;;;
;;;  carry out incremental or radical research and adjust expertise and prices
;;;

; Successful firms don't do research, they just keep on with their previous product
; (unless their kene has changed through partnering).  Unsuccessful
; firms normally do incremental research.  However, if their capital has almost
; all gone, they do radical research instead.

;firm procedure
to do-research
  if last-reward < success-threshold [
    ifelse capital <= low-capital-threshold
      [ do-radical-research ]
      [ do-incremental-research ]
  ]
end

; adjust an ability up or down by an amount that is likely to change the product number by one unit.
; If this is the second or subsequent time of doing incremental
; research, and the last reward was positive (although less than success-threshold, since if it
; were above that, the firm would continue to produce the last innovation, rather than do
; research), make a change to the same ability in the same direction.
; If the first time or the research proved unsuccessful (the firm made a loss and last-reward
; is 0), choose a ability from the kene at random and alter it in a random direction.

; research-direction is initially "random".  It is set here to "down" or "up" to show
; direction of research.  If an ability has been explored to the limit (reached 0 or 10),
; the direction is reset to random.

;firm procedure
to do-incremental-research
  if not Incr-research [ stop ]
  if research-direction = "random"  [
    set ability-to-research random length ih
    ifelse (random 2) = 1
      [ set research-direction "up" ]
      [ set research-direction "down" ]
  ]
  let new-ability item ability-to-research abilities
  ifelse research-direction = "up"
    [ set new-ability new-ability +  (new-ability / item ability-to-research capabilities) ]
    [ set new-ability new-ability -  (new-ability / item ability-to-research capabilities)  ]
  if new-ability <= 0  [ set new-ability 0   set research-direction "random"]
  if new-ability > 10  [ set new-ability 10  set research-direction "random"]
  set abilities replace-item  ability-to-research abilities new-ability
  set new-ih? true
  pay-tax incr-research-tax
end

; radical research just means
; a. randomly changing one capability for a new value and then
; b. constructing a new innovation hypothesis from the kene

;firm procedure
to do-radical-research
  if not Rad-research [ stop ]
  set done-rad-research true
  let capability-to-mutate (random length capabilities)
  let new-capability (random nCapabilities) + 1; find a capability that is new to this firm
  while [ member? new-capability capabilities ]
    [set new-capability (random nCapabilities) + 1 ]
  set capabilities replace-item capability-to-mutate capabilities new-capability
  set new-ih? true
  pay-tax radical-research-tax
end


; raise the expertise level by one (up to a maximum of 10) for capabilities that
; are used in the innovation, and decrease by one for capabilities that are not.
; If an expertise level has dropped to zero, the capability is forgotten.

;firm procedure
to adjust-expertise
  if not Adj-expertise [ stop ]
  let location 0
  while [ location < length capabilities ] [
    let expertise item location expertises
    ifelse member? location ih
      [ ; capability has been used - increase expertise if possible
        if expertise < 10 [ set expertises replace-item location expertises (expertise + 1) ]
      ]
      [ ; capability has not been used - decrease expertise and drop capability if expertise has fallen to zero
        ifelse expertise > 0
        [ set expertises replace-item location expertises (expertise - 1) ]
        [ forget-capability location set location location - 1]
      ]
    set location location + 1
  ]
end

; remove the capability, ability, expertise at the given location of the kene.
; Warning; all hell will break loose if the capability that is being forgotten is included
; in the innovation hypothesis (but no test is done to check this).
; Although the keen is changed, the innovation hypothesis and the product are not (since
; the forgotten capability is not in the ih, this doesn't matter)

;firm procedure
to forget-capability [location ]
  set capabilities remove-item location capabilities
  set abilities remove-item location abilities
  set expertises remove-item location expertises
  adjust-ih location
end

; reduce the values (which are indices into the kene) in the innovation hypothesis to
; account for the removal of a capability.  Reduce all indices above 'location' by one

;firm procedure
to adjust-ih [ location ]
  let elem 0
  let i 0
  while [ i < length ih ] [
    set elem item i ih
    if elem > location [ set ih replace-item i ih (elem - 1 ) ]
    set i i + 1
  ]
end

; Adjust the price of my product to respond to market conditions:
; If in the last round I sold a product to lots ofcustomers, increase the price by 10%
; If there were no buyers, reduce the price by 10%

;firm procedure
to adjust-price
  if not Adj-price [ stop ]
  if trading? [
    if length customers > 4 [ set price price * 1.1 ]
    if length customers = 0 [ set price price * 0.9 ]
  ]
end


;;; CREATE NETWORKS
;;;

; if the firm's last innovation was successful and they are not already a member of
; a network and they have enough capital, initiate the formation of a network and add myself
; and my partners as the initial members

;observer procedure
to create-nets
  if not Networking [ stop ]
  ask firms with [ (last-reward > success-threshold) and (capital > initial-capital) and (net = nobody) ] [
    create-network
  ]
end


; A network consist of a network agent with an associated network firm.  The latter does all
; the work of innovation and production for the network.

; Create a network agent founded on myself as the first member and add my partners as members,
; unless they alrady are members of an existing network. Create the associated network firm,
; that is the network's headquarters (HQ),  Collect the start-up capital for the
; new firm from the partners, in proportion to the partners' wealth

; firm procedure
to create-network
  ; do nothing if I am already in a network
  if net != nobody [ stop ]
  ; identify the partners that are not already in a network
  let my-partners partners with [ net = nobody ]
  ; do nothing if there are no partners not already in a network
  ; since a network must have more members than just the founder
  if not any? my-partners [ stop ]
  ; create the network and the network's HQ
  let the-network make-network
  ; add the founder and the founder's partners to the network
  ask the-network [ add-members myself ]
  ; extract the HQ's startup capital from the new network's members
  let partners-wealth reduce [ ?1 + ?2 ] map [ [capital] of ?1 ] [members] of the-network
  foreach [members] of the-network [ set capital capital - (initial-capital * capital / partners-wealth) ]
  ; produce the network's first product
  ask [ hq ] of the-network [
    make-innovation-hypothesis
    make-advert
    manufacture
  ]
end

; make an 'empty' network (a new network agent and a new firm agent, representing the network's headquarters (HQ))

;firm procedure
to-report make-network
  let new-net nobody
  let hqfirm nobody
  hatch-networks 1 [    ; create a network agent
    set new-net self
    hide-turtle
    hatch-firms 1 [    ; create an HQ firm for the network
      set hqfirm self
      set capital initial-capital
      initialise-firm
      set hq? true
      ; link this firm to its network
      set net new-net
      ask new-net [
        ; tell the network about its HQ
        set hq hqfirm
        set members []
        ]
    ]
  ]
  report new-net
end

; copy the kene triples corresponding to the innovation hypothesis
;   from the source to this firm

;firm procedure
to copy-ih-capabilities [ source ]
  foreach [ih] of source [
    set capabilities fput item ? [capabilities] of source capabilities
    set abilities fput item ? [abilities] of source abilities
    set expertises fput item ? [expertises] of source expertises
  ]
end

; add the-firm and all its partners to the network (and so on recursively)

; network procedure
to add-members [ the-firm ]
  let the-network self
  ; add the firm to the network
  set members fput the-firm members
  ; merge the kene of the firm into the network
  ask the-firm [
    set net the-network
    merge-capabilities [ hq ] of the-network
  ]
  ; find the partners of the firm that are not already in a network
  let my-partners no-turtles
  ask the-firm [ set my-partners partners with [ net = nobody ] ]
  if not any? my-partners [ stop ]
  ; and add the firm's partners to the network
  ask my-partners [
    ask the-network [ add-members myself ]
  ]
end


;;; ADMINISTRATION
;;;
;;;

; no comment needed!

;firm procedure
to pay-taxes
  pay-tax depreciation        ; annual depreciation
end

; the money paid just disappears.  Later it may be transferred to end-users, to keep it
;   in circulation

;firm procedure
to pay-tax [ amount ]
  set capital capital - amount
end

; If the network has been successful, distribute all the profits of the network
; above the initial capital equally to all the network members
; Alternatively if the network has gone bankrupt, dissolve the network

;network procedure
to distribute-network-profits
  if length members > 0 and [capital] of hq > initial-capital [
    let amount-to-distribute ([capital] of hq - initial-capital) / length members
    foreach members [
      ask ? [ set capital capital + amount-to-distribute ]
    ]
    ask hq [ set capital initial-capital ]
  ]
  if [capital] of hq < 0 [ dissolve-network ]
end

; unhook each member from the network and kill both the network agent and the associated
;   firm agent

;network procedure
to dissolve-network
  foreach members [
    ask ? [set net nobody ]
  ]
  ask hq [ exit ]
  die
end

; some final tidying up at the end of every round

;firm procedure
to do-admin
  ; dissolve this round's partnerships, but remember the partners for the future
  set previous-partners (turtle-set previous-partners partners)
  set age age + 1
  ; die if bankrupt
  if capital < 0 [ exit ]
end

; remove myself from the simulation, making sure that I am no longer a member of any network etc.

;firm procedure
to exit
  ; remove the firm from its network (if any).  If the network has only one
  ;  member (in addition to the HQ firm), also kill the network
  if net != nobody [
    ask net [ set members remove myself members ]
    if not hq? and length [members] of net <= 1 [
      ask net [ dissolve-network ]
    ]
  ]
  ; remove myself from records of partnerships I am or have been in
  ; and from lists of suppliers and customers
  ask firms [
    set partners partners with [ myself != self ]
    set previous-partners previous-partners with [myself != self ]
  ]
  ask firms with [member? myself suppliers or member? myself customers] [
    set customers remove myself customers
    set suppliers remove myself suppliers
    ; and ensure that this firm's suppliers and customers are recalculated
    set trading? false
  ]
  die
end

; start-ups are clones of the most successful firm, modified in two ways:
; they get only the standard starting capital
; they get their kene trimmed to the length appropriate to their capital
; create 1, or if the most successful firm was very successful, more

;observer procedure
to create-start-ups
  if count firms = 0 [ stop ]
  if not Start-ups [ stop ]
  let biggest-reward max [last-reward] of firms
  if biggest-reward > reward-to-trigger-start-up
    [ repeat log biggest-reward 10 [ make-start-up ] ]
end

;; Added By Yao-Ching
;observer procedure
to create-university-start-ups
  if count universities = 0 [stop]
  if not University-Start-Ups [ stop ]
  file-open "start-up.txt"
  file-print University-Start-Ups
  file-close
  let biggest-reward max [last-reward] of universities
  if biggest-reward > reward-to-trigger-university-start-up
    [ repeat log biggest-reward 10 [ make-university-start-up ] ]
end

; clone the firm with the largest reward

;observer procedure
to make-start-up
  create-firms 1 [
    set capital  initial-capital
    initialise-firm
    clone-kene max-one-of other firms [ last-reward ]
    make-innovation-hypothesis
    make-advert
    manufacture
  ]
end

;; Added By Yao-Ching
;observer procedure
to make-university-start-up
  create-universities 1 [
    set capital initial-capital-university
    initialise-university
    clone-kene max-one-of other universities [ last-reward ]
    make-innovation-hypothesis
    make-advert
  ]
end

; cloning a kene involves copying the triples in its innovation hypothesis,
; but chopping it to a length suitable for the capital of the firm receiving it

;firm procedure
to clone-kene [ firm-to-clone ]
  let ih-pos 0
  repeat min list (length [ih] of firm-to-clone) (ln ((capital / capital-knowledge-ratio) + 1) + 1) [
    let triple-pos item ih-pos [ih] of firm-to-clone
    set capabilities fput (item triple-pos [capabilities] of firm-to-clone) capabilities
    set abilities fput (item triple-pos [abilities] of firm-to-clone) abilities
    set expertises fput (item triple-pos [expertises] of firm-to-clone) expertises
    set ih-pos ih-pos + 1
  ]
end

;;; DISPLAY
;;;
;;; display some plots

;observer procedure
to show-plots[ is-setup-call ]

    ifelse is-setup-call [ 
      file-open "tmp.txt" 
    ] [ 
      file-open "output.txt" 
    ]
    
    file-write "================== Round "
    file-write ticks
    file-write " =================="
    file-print ""
    let count-of-firms count firms ;; local variable, eq => count-of-firms == count(firms)
    if count-of-firms <= 2 [stop]

    set-current-plot "Capital"
    file-print "Capital"
    if count firms with [ capital > 0 ] > 0 [ ;; 計算 capital > 0 的firm數量
     set-current-plot-pen "Average"
     plot mean [ log capital 10 ] of firms with [ capital > 0 ] ;; mean => aberage, mean capital of firms whose capital > 0

     file-write "Average: "
     file-write mean [ log capital 10 ] of firms with [ capital > 0 ]
     file-print ""

    ]


    set-current-plot "Collaboration"
    file-print "Collaboration"

    set-current-plot-pen "In partnership"
    file-write "In partnership: "
    plot 100 * count firms with [ any? partners ] / count-of-firms   ;; 畫有partner的firm （plot y-value）
    file-write 100 * count firms with [ any? partners ] / count-of-firms
    file-print ""

    set-current-plot-pen "In network"
    file-write "In network:"
    plot 100 * count firms with [ net != nobody ] / count-of-firms
    file-write 100 * count firms with [ net != nobody ] / count-of-firms
    file-print ""

    if any? networks [ plot-degree-distribution ]

    set-current-plot "Population"
    file-print "Population"
    set-current-plot-pen "Firms"
    file-write "Firms: "
    plot count-of-firms
    file-write count-of-firms
    file-print ""
    set-current-plot-pen "Networks"
    file-write "Networks: "
    plot count networks
    file-write count networks
    file-print ""

    set-current-plot "Dynamics"
    file-print "Dynamics"
    set-current-plot-pen "Successes"
    file-write "Successes: "
    let selling-firms count firms with [selling?]
    if selling-firms > 0 [
      plot 100 * count firms with [ last-reward > success-threshold ] / selling-firms
      file-write 100 * count firms with [ last-reward > success-threshold ] / selling-firms
    ]
    file-print ""
    set-current-plot-pen "Start-ups"
    file-write "Start-ups: "
    plot 100 * count firms with [ age = 0 and ticks != 0 and not hq?] / count-of-firms
    file-write 100 * count firms with [ age = 0 and ticks != 0 and not hq?] / count-of-firms
    file-print ""

    set-current-plot "Transactions"
    file-print "Transactions"
    set-current-plot-pen "Firms selling"
    file-write  "Firms selling: "
    plot 100 * count firms with [ selling? ] / count-of-firms
    file-print 100 * count firms with [ selling? ] / count-of-firms

    set-current-plot-pen "Firms trading"
    file-write "Firms trading: "

    plot 100 *  count firms with [ trading? ] / count-of-firms
    file-print 100 *  count firms with [ trading? ] / count-of-firms

    set-current-plot "Sales"
    file-print "Sales"
    if count firms with [sales > 0] > 0 [
      set-current-plot-pen "Sales"
      file-write "Sales: "
      plot mean [sales ] of firms with [sales > 0 ]
      file-print mean [sales ] of firms with [sales > 0 ]
    ]

    if count firms with [last-reward > 0] > 0 [
      set-current-plot-pen "Profit"
      file-write "Profit: "
      plot mean [ last-reward ] of firms with [last-reward > 0 ]
      file-print mean [ last-reward ] of firms with [last-reward > 0 ]
    ]

    set-current-plot "Networks"
    file-print "Networks"
    if count networks > 0 [
      set-plot-x-range 1  max list 20 1 + max [length members] of networks
      histogram [ length members ] of networks  ; 這邊需要在記錄數值
      file-print [ length members ] of networks
     ]

    set-current-plot "Partners"
    file-print "Partners"
    histogram  [count partners] of firms with [ any? partners ] ; 這邊需要在記錄數值
    file-print [count partners] of firms with [ any? partners ]

    set-current-plot "Age distribution"
    file-print "Age distribution"
    set-current-plot-pen "Age"
    file-write "Age: "
    let max-age max [ age ] of firms
    if  max-age > 0 [
      set-plot-x-range 0 max-age
      histogram [age ] of firms  ; 這邊需要在記錄數值
      file-print [age ] of firms
     ]

    set-current-plot "Size distribution"
    file-print "Size distribution"
    set-current-plot-pen "Size"
    file-write "Size: "
    let max-cap max [ capital ] of firms
    if max-cap > 0 [
      histogram [ 100 * capital / max-cap ] of firms ; 這邊需要在記錄數值
      file-print [ 100 * capital / max-cap ] of firms

    ]

    set-current-plot "Rate of radical research"
    file-print "Rate of radical research"

    set-current-plot-pen "Rad-research"
    file-write "Rad-research: "
    plot count firms with [ done-rad-research ]
    file-print count firms with [ done-rad-research ]

    set-current-plot "Artefacts"
    file-print "Artefacts"

    set-current-plot-pen "Products"
    file-write "Products: "

    histogram  [ product ] of firms
    file-print [ product ] of firms

    set-current-plot-pen "Inputs"
    file-write "Inputs: "

    histogram reduce [sentence ?1 ?2] [ inputs ] of firms
    file-print reduce [sentence ?1 ?2] [ inputs ] of firms

    file-close ; close file
end


;; Added By Yao-Ching
;; observer procedure
to show-plots-universities [ is-setup-call ]
  let count-of-universities count universities ;; local variable, eq => count-of-firms == count(firms)
    if count-of-universities <= 2 [stop]

    set-current-plot "u_Capital"
    ;; file-print "Capital"
    if count universities with [ capital > 0 ] > 0 [ ;; 計算 capital > 0 的firm數量
     set-current-plot-pen "Average"
     plot mean [ log capital 10 ] of universities with [ capital > 0 ] ;; mean => aberage, mean capital of firms whose capital > 0

     ;;file-write "Average: "
     ;;file-write mean [ log capital 10 ] of universities with [ capital > 0 ]
     ;;file-print ""
     
    ]
    
    
    set-current-plot "u_Dynamics"
    set-current-plot-pen "Successes"
    let selling-universities count universities with [selling?]
    if selling-universities > 0 [
      plot 100 * count universities with [ last-reward > success-threshold ] / selling-universities
    ]
    set-current-plot-pen "Start-ups"
    plot 100 * count universities with [ age = 0 and ticks != 0 and not hq?] / count-of-universities
end

;
; plot log(number of members) by log(frequency of networks with that number of members)
; at the present moment of time, plus a regression line
;

to plot-degree-distribution
  set-current-plot "Network size"
  clear-plot  ;; erase what we plotted before
  set-plot-pen-color black
  set-plot-pen-mode 2 ;; plot points
  let max-degree max [length members] of networks
  let degree 1 ; only include nodes with at least one link
  let sumx 0 ;; for regression line
  let sumy 0
  let sumxy 0
  let sumxx 0
  let sumyy 0
  let n 0
  while [degree <= max-degree]
  [
    let matches networks with [length members = degree]
    if any? matches
      [ let x log degree 10
        let y log (count matches) 10
        plotxy x y
        set sumx sumx + x
        set sumy sumy + y
        set sumxy sumxy + x * y
        set sumxx sumxx + x * x
        set sumyy sumyy + y * y
        set n n + 1
        ]
    set degree degree + 1
  ]
  if n > 1 [
   let slope  (n * sumxy - sumx * sumy) / (n * sumxx - sumx * sumx)
   let intercept  (sumy - slope * sumx) / n
   create-temporary-plot-pen "regression line"
   set-plot-pen-mode 0
   set-plot-pen-color red
   plot-pen-up
   plotxy 0 intercept
   plot-pen-down
   ifelse slope = 0 [
     plotxy intercept intercept  ;; regression line is parallel to x-axis
   ] [
     plotxy -1 * intercept / slope 0
   ]
  ]
end

;; Added By Yao-Ching
;; In every 2 ticks, expertises will reduce 1 if it is not in ih
to decrease-expertises
  let indexes n-values length expertises [ ? ]
  let return-expertises []
  let remove-item-index []
  let tmp-ih n-values length ih [0]
  let idxs n-values length ih [ ? ]
  (foreach expertises indexes [
    let index ?2
    if (not member? index ih) [
      ifelse (?1 - 1) <= 0 [
        set capabilities replace-item index capabilities 0 
        set abilities replace-item index abilities 0 
        set expertises replace-item index expertises 0
        
        
      ] [
        set expertises replace-item index expertises (?1 - 1) 
      ]
    ]
  ])
  
  
  ;; Remember the offset 
  (foreach expertises indexes [
      let expertise ?1
      let index ?2
      if expertise <= 0 [
        (foreach ih idxs [
          if ( ?1 > index and ?1 != 0) [ set tmp-ih replace-item ?2 tmp-ih ((item ?2 tmp-ih) + 1)]
        ])
      ]
   ])
  
  ;; Align the ih value base on offset
  let idxs3 n-values length tmp-ih [ ? ]
  (foreach tmp-ih idxs3 [
    set ih replace-item ?2 ih ((item ?2 ih) - ?1 )
  ])
  
  set ih remove-duplicates ih
  
  ;; remove triple that value == 0
  set expertises filter [? > 0] expertises
  set abilities filter [? > 0] abilities
  set capabilities filter [? > 0] capabilities 
  
end

;; Added By Yao-Ching 2015/01/02
; University procedure
; get capital from government every tick
to get-capital-from-government
  set capital (capital + capital-from-government)
end



;; Added by Yao-Ching
to out-put-attributes
  file-open (word "output/" breed "-" number ".txt") ; open file to write

  file-print(word "======================" ticks "=========================") 

  file-print( word "capabilities: " capabilities " " )
  file-print( word "abilities: " abilities " " )
  file-print( word "expertises: " expertises " " )
  file-print( word "ih: " ih " " )

  file-print( word "new-ih?: " new-ih? " " )
  file-print( word "advert: " advert " " )

  file-print( word "research-direction: " research-direction " " )

  file-print( word "ability-to-research: " ability-to-research " " )

  file-print( word "done-rad-research: " done-rad-research " " )
  file-print( word "partners: " partners " " )
  file-print( word "previous-partners: " previous-partners " " )

  file-print( word "suppliers: " suppliers " " )
  file-print( word "customers: " customers " " )

  file-print( word "product: " product " " )
  file-print( word "inputs: " inputs " " )
  file-print( word "quality: " quality " " )
  file-print( word "selling?: " selling? " " )


  file-print( word "trading?: " trading? " " )
  file-print( word "total-cost: " total-cost " " )
  file-print( word "price: " price " " )
  file-print( word "sales: " sales " " )
  file-print( word "last-reward: " last-reward " " )

  file-print( word "capital: " capital " " )
  file-print( word "net: " net " " )
  file-print( word "age: " age " " )
  file-print( word "hq?: " hq? " " )

  file-print ""


  file-close

end

;; end of code
@#$#@#$#@
GRAPHICS-WINDOW
630
45
875
263
89
89
1.045
1
10
1
1
1
0
0
0
1
-89
89
-89
89
0
0
1
ticks
30.0

BUTTON
35
20
98
53
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
935
10
1239
160
Population
Time
N
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Firms" 1.0 0 -16777216 true "" ""
"Networks" 1.0 0 -10899396 true "" ""

PLOT
935
317
1238
467
Collaboration
Time
%
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"In partnership" 1.0 0 -5825686 true "" ""
"In network" 1.0 0 -10899396 true "" ""

BUTTON
150
20
213
53
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
20
290
240
335
partnership-strategy
partnership-strategy
"no partners" "conservative" "progressive"
1

PLOT
935
165
1237
315
Transactions
Time
%
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Firms selling" 1.0 0 -7500403 true "" ""
"Firms trading" 1.0 0 -6459832 true "" ""

SLIDER
20
145
240
178
nInputs
nInputs
3
6
4
1
1
NIL
HORIZONTAL

SLIDER
20
110
240
143
nProducts
nProducts
0
100
100
1
1
NIL
HORIZONTAL

PLOT
240
610
500
765
Dynamics
Time
% of firms
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Successes" 1.0 0 -13791810 true "" ""
"Start-ups" 1.0 0 -2674135 true "" ""

SLIDER
20
215
240
248
big-firms-percent
big-firms-percent
0
100
1
1
1
NIL
HORIZONTAL

PLOT
735
610
935
761
Networks
Size
Count
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 1 -10899396 true "" ""

SLIDER
21
73
241
106
nFirms
nFirms
0
1000
500
1
1
NIL
HORIZONTAL

SLIDER
20
335
240
368
attractiveness-threshold
attractiveness-threshold
0
1
0.3
0.1
1
NIL
HORIZONTAL

PLOT
0
610
235
765
Capital
Time
log 10 Capital
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"Average" 1.0 0 -2674135 false "" ""

PLOT
0
770
235
950
Network size
Log (k)
Log (deg. distrib.)
0.0
2.0
0.0
2.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
505
610
730
762
Partners
Number
Frequency
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

PLOT
240
770
500
950
Age distribution
Age
N
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"Age" 1.0 1 -10899396 true "" ""

PLOT
570
70
920
225
Artefacts
NIL
NIL
0.0
100.0
0.0
40.0
true
true
"" ""
PENS
"Inputs" 1.0 1 -11221820 true "" ""
"Products" 1.0 1 -10899396 true "" ""

PLOT
505
770
730
950
Size distribution
NIL
NIL
0.0
100.0
0.0
50.0
true
false
"" ""
PENS
"size" 1.0 1 -13791810 true "" ""

PLOT
735
770
935
950
Rate of radical research
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"rad-research" 1.0 0 -16777216 true "" ""

SWITCH
0
520
142
553
Adj-expertise
Adj-expertise
1
1
-1000

SWITCH
147
520
263
553
Adj-price
Adj-price
1
1
-1000

SWITCH
268
520
410
553
Incr-research
Incr-research
1
1
-1000

SWITCH
415
519
556
552
Rad-research
Rad-research
1
1
-1000

SWITCH
562
519
683
552
Partnering
Partnering
0
1
-1000

SWITCH
689
518
816
551
Networking
Networking
1
1
-1000

PLOT
570
220
920
420
Sales
Time
Mean value per firm
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Sales" 1.0 0 -13345367 true "" ""
"Profit" 1.0 0 -2064490 true "" ""

SWITCH
822
518
938
551
Start-ups
Start-ups
1
1
-1000

SLIDER
20
370
240
403
success-threshold
success-threshold
0
10000
995
1
1
NIL
HORIZONTAL

SLIDER
20
410
240
443
reward-to-trigger-start-up
reward-to-trigger-start-up
0
2000
1202
1
1
NIL
HORIZONTAL

SLIDER
20
180
240
213
In-out-products-percent
In-out-products-percent
0
50
22
1
1
%
HORIZONTAL

TEXTBOX
50
240
200
266
___________________________________
11
0.0
1

SLIDER
20
255
240
288
initial-capital
initial-capital
0
100000
20000
1000
1
NIL
HORIZONTAL

TEXTBOX
260
10
645
28
SKIN (Simulating Knowledge Dynamics in Innovation Networks) 5.31
11
0.0
1

SLIDER
255
75
465
108
nUniversities
nUniversities
0
1000
502
1
1
NIL
HORIZONTAL

SLIDER
255
215
457
248
big-universities-percent
big-universities-percent
0
100
50
1
1
NIL
HORIZONTAL

SLIDER
255
255
457
288
initial-capital-university
initial-capital-university
0
100000
88000
1000
1
NIL
HORIZONTAL

SLIDER
255
35
467
68
nTimesOfFirmCapabilities
nTimesOfFirmCapabilities
0
100
29
1
1
NIL
HORIZONTAL

SWITCH
558
567
790
600
Collborate-With-Universities
Collborate-With-Universities
1
1
-1000

SWITCH
823
567
1005
600
University-Start-Ups
University-Start-Ups
1
1
-1000

SLIDER
245
410
542
443
reward-to-trigger-university-start-up
reward-to-trigger-university-start-up
0
2000
1128
1
1
NIL
HORIZONTAL

SLIDER
250
315
540
348
Percentage-Of-Profit-To-Give-To-University
Percentage-Of-Profit-To-Give-To-University
0
100
50
1
1
NIL
HORIZONTAL

PLOT
5
990
230
1140
u_Capital
Time
log 10 Capital
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"Average" 1.0 0 -2674135 true "" ""

PLOT
250
990
500
1140
u_Dynamics
Time
% of universities
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Successes" 1.0 0 -13345367 true "" ""
"Start-ups" 1.0 0 -2674135 true "" ""

SLIDER
245
455
457
488
capital-from-government
capital-from-government
0
10000
760
10
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

SKIN (Simulating Knowledge Dynamics in Innovation Networks) is a multi-agent model of innovation networks in knowledge-intensive industries grounded in empirical research and theoretical frameworks from innovation economics and economic sociology. The agents represent innovative firms who try to sell their innovations to other agents and end users but who also have to buy raw materials or more sophisticated inputs from other agents (or material suppliers) in order to produce their outputs. This basic model of a market is extended with a representation of the knowledge dynamics in and between the firms. Each firm tries to improve its innovation performance and its sales by improving its knowledge base through adaptation to user needs, incremental or radical learning, and co-operation and networking with other agents.

## HOW IT WORKS

The agents

The individual knowledge base of a SKIN agent, its kene, contains a number of �units of knowledge�. Each unit in a kene is represented as a triple consisting of a firm�s capability C in a scientific, technological or business domain, its ability A to perform a certain application in this field, and the expertise level E the firm has achieved with respect to this ability. The units of knowledge in the kenes of the agents can be used to describe their virtual knowledge bases. 

The market

Because actors in empirical innovation networks of knowledge-intensive industries interact on both the knowledge and the market levels, there needs to be a representation of market dynamics in the SKIN model. Agents are therefore characterised by their capital stock. Each firm, when it is set up, has a stock of initial capital. It needs this capital to produce for the market and to finance its R&D expenditures; it can increase its capital by selling products. The amount of capital owned by a firm is used as a measure of its size and additionally influences the amount of knowledge (measured by the number of triples in its kene) that it can maintain.  Most firms are initially given the same starting capital allocation, but in order to model differences in firm size, a few randomly chosen firms can be allocated extra capital. 

Firms apply their knowledge to create innovative products that have a chance of being successful in the market. The special focus of a firm, its potential innovation, is called an innovation hypothesis. In the model, the innovation hypothesis (IH) is derived from a subset of the firm�s kene triples.
   
The underlying idea for an innovation, modelled by the innovation hypothesis, is the source an agent uses for its attempts to make profits in the market. Because of the fundamental uncertainty of innovation, there is no simple relationship between the innovation hypothesis and product development. To represent this uncertainty,  the innovation hypothesis is transformed into a product through a mapping procedure where the capabilities of the innovation hypothesis are used to compute an index number that represents the product. The particular transformation procedure applied allows the same product to result from different kenes.

A firm�s product, P, is generated from its innovation hypothesis as

                                             

P = Sum (capability * ability) mod N

where N is a large constant and represents the notional total number of possible different products that could be present in the market).

A product has a certain quality, which is also computed from the innovation hypothesis in a similar way, by multiplying the abilities and the expertise levels for each triple in the innovation hypothesis and normalising the result. Whereas the abilities used to design a product can be used as a proxy for its product characteristics, the expertise of the applied abilities is an indicator of the potential product quality. 

In order to realise the product, the agent needs some materials. These can either come from outside the sector (�raw materials�) or from other firms, which generated them as their products. Which materials are needed is again determined by the underlying innovation hypothesis: the kind of material required for an input is obtained by selecting subsets from the innovation hypotheses and applying the standard mapping function. 

These inputs are chosen so that each is different and differs from the firm�s own product. In order to be able to engage in production, all the inputs need to be obtainable on the market, i.e. provided by other firms or available as raw materials. If the inputs are not available, the firm is not able to produce and has to give up this attempt to innovate. If there is more than one supplier for a certain input, the agent will choose the one at the cheapest price and, if there are several similar offers, the one with the highest quality. 
   
If the firm can go into production, it has to find a price for its product, taking into account the input prices it is paying and a possible profit margin. While the simulation starts with product prices set at random, as the simulation proceeds a price adjustment mechanism following a standard mark-up pricing model increases the selling price if there is much demand, and reduces it (but no lower than the total cost of production) if there are no customers.  Some products are considered to be destined for the �end-user� and are sold to customers outside the sector: there is always a demand for such end-user products provided that they are offered at or below a fixed end-user price. A firm buys the requested inputs from its suppliers using its capital to do so, produces its output and puts it on the market for others to purchase. Using the price adjustment mechanism, agents are able to adapt their prices to demand and in doing so learn by feedback. 

In making a product, an agent applies the knowledge in its innovation hypothesis and this increases its expertise in this area. This is the way that learning by doing/using is modelled. The expertise levels of the triples in the innovation hypothesis are increased and the expertise levels of the other triples are decremented. Expertise in unused triples in the kene is eventually lost and the triples are then deleted from the kene; the corresponding abilities are �forgotten�.

Thus, in trying to be successful on the market, firms are dependent on their innovation hypothesis, i.e. on their kene. If a product does not meet any demand, the firm has to adapt its knowledge in order to produce something else for which there are customers. A firm has several ways of improving its performance, either alone or in co-operation, and in either an incremental or a more radical fashion. 

Learning and co-operation: improving innovation performance

In the SKIN model, firms may engage in single- and double-loop learning activities. Firm agents can:  
*	use their capabilities (learning by doing/using) and learn to estimate their success via feedback from markets and clients (learning by feedback) as already mentioned above and/or  
*	improve their own knowledge incrementally when the feedback is not satisfactory in order to adapt to changing technological and/or economic standards (adaptation learning, incremental learning).

If a firm�s previous innovation has been successful, i.e. it has found buyers, the firm will continue selling the same product in the next round, possibly at a different price depending on the demand it has experienced. However, if there were no sales, it considers that it is time for change. If the firm still has enough capital, it will carry out �incremental� research (R&D in the firm�s labs). Performing incremental research means that a firm tries to improve its product by altering one of the abilities chosen from the triples in its innovation hypothesis, while sticking to its focal capabilities. The ability in each triple is considered to be a point in the respective capability�s action space. To move in the action space means to go up or down by an increment, thus allowing for two possible �research directions�. 

Alternatively, firms can radically change their capabilities in order to meet completely different client requirements (innovative learning, radical learning). A SKIN firm agent under serious pressure and in danger of becoming bankrupt, will turn to more radical measures, by exploring a completely different area of market opportunities. In the model, an agent under financial pressure turns to a new innovation hypothesis after first �inventing� a new capability for its kene. This is done by randomly replacing a capability in the kene with a new one and then generating a new innovation hypothesis. 

An agent in the model may consider partnerships (alliances, joint ventures etc.) in order to exploit external knowledge sources. The decision whether and with whom to co-operate is based on the mutual observations of the firms, which estimate the chances and requirements coming from competitors, possible and past partners, and clients.  In the SKIN model, a marketing feature provides the information that a firm can gather about other agents: to advertise its product, a firm publishes the capabilities used in its innovation hypothesis. Those capabilities not included in its innovation hypothesis and thus in its product are not visible externally and cannot be used to select the firm as a partner. The firm�s �advertisement� is then the basis for decisions by other firms to form or reject co-operative arrangements.

In experimenting with the model, one can choose between two different partner search strategies, both of which compare the firm�s own capabilities as used in its innovation hypothesis and the possible partner�s capabilities as seen in its advertisement. Applying the conservative strategy, a firm will be attracted to a partner that has similar capabilities; using a progressive strategy the attraction is based on the difference between the capability sets. 

To find a partner, the firm will look at previous partners first, then at its suppliers, customers and finally at all others. If there is a firm sufficiently attractive according to the chosen search strategy (i.e. with attractiveness above the �attractiveness threshold�), it will stop its search and offer a partnership. If the potential partner wishes to return the partnership offer, the partnership is set up. 

The model assumes that partners learn only about the knowledge being actively used by the other agent. Thus, to learn from a partner, a firm will add the triples of the partner�s innovation hypothesis to its own. For capabilities that are new to it, the expertise levels of the triples taken from the partner are reduced in order to mirror the difficulty of integrating external knowledge as stated in empirical learning research.  For partner�s capabilities that are already known to it, if the partner has a higher expertise level, the firm will drop its own triple in favour of the partner�s one; if the expertise level of a similar triple is lower, the firm will stick to its own version. Once the knowledge transfer has been completed, each firm continues to produce its own product, possibly with greater expertise as a result of acquiring skills from its partner.

If the firm�s last innovation was successful, i.e. the value of its profit in the previous round was above a threshold, and the firm has some partners at hand, it can initiate the formation of a network. This can increase its profits because the network will try to create innovations as an autonomous agent in addition to those created by its members and will distribute any rewards back to its members who, in the meantime, can continue with their own attempts, thus providing a double chance for profits. Networks are �normal� agents, i.e. they get the same amount of initial capital as other firms and can engage in all the activities available to other firms. The kene of a network is the union of the triples from the innovation hypotheses of all its participants. If a network is successful it will distribute any earnings above the amount of the initial capital to its members; if it fails and becomes bankrupt, it will be dissolved. 

Start-ups

If a sector is successful, new firms will be attracted into it. This is modelled by adding a new firm to the population when any existing firm makes a substantial profit. The new firm is a clone of the successful firm, but with its kene triples restricted to those in the successful firm�s advertisement and these having a low expertise level. This models a new firm copying the characteristics of those seen to be successful in the market. As with all firms, the kene may also be restricted because the initial capital of a start-up is limited and may not be sufficient to support the copying of the whole of the successful firm�s innovation hypothesis.



## REFERENCES

More information about SKIN and research based on it can be found at: http://cress.soc.surrey.ac.uk/skin/home

The following papers describe the model and how it has been used by its originators:

Gilbert, Nigel, Pyka, Andreas, & Ahrweiler, Petra. (2001b). Innovation networks - a simulation approach. Journal of Artificial Societies and Social Simulation, 4(3)8, <http://jasss.soc.surrey.ac.uk/4/3/8.html>.

Vaux, Janet, & Gilbert, Nigel. (2003). Innovation networks by design: The case of the mobile VCE. In A. Pyka & G. K�ppers (Eds.), Innovation networks: Theory and practice. Cheltenham: Edward Elgar.

Pyka, Andreas, Gilbert, Nigel, & Ahrweiler, Petra. (2003). Simulating innovation networks. In A. Pyka & G. K�ppers; (Eds.), Innovation networks: Theory and practice. Cheltenham: Edward Elgar.

Ahrweiler, Petra, Pyka, Andreas, & Gilbert, Nigel. (2004). Simulating knowledge dynamics in innovation networks (SKIN). In R. Leombruni & M. Richiardi (Eds.),Industry and labor dynamics: The agent-based computational economics approach. Singapore: World Scientific Press.

Ahrweiler, Petra, Pyka, Andreas & Gilbert, Nigel. (2004), Die Simulation von Lernen in Innovationsnetzwerken, in: Michael Florian und Frank Hillebrandt (eds.): Adaption und Lernen in und von Organisationen. VS-Verlag f�r Sozialwissenschaften, Opladen 2004, 165-186.

Pyka, A. (2006), Modelling Qualitative Development. Agent Based Approaches in Economics, in: Rennard, J.-P. (Hrsg.), Handbook of Research on Nature Inspired Computing for Economy and Management, Idea Group Inc., Hershey, USA, 211-224.

Gilbert, Nigel, Ahrweiler, Petra, & Pyka, Andreas. (2007). Learning in innovation networks: Some simulation experiments. Physica A, 378, 100-109.

Pyka, Andreas, Gilbert, Nigel, & Ahrweiler, Petra. (2007). Simulating knowledge-generation and distribution processes in innovation collaborations and networks. Cybernetics and Systems, 38 (7), 667-693.

Pyka, Andreas, Gilbert, Nigel & Petra Ahrweiler (2009), Agent-Based Modelling of Innovation Networks � The Fairytale of Spillover, in: Pyka, A. and Scharnhorst, A. (eds.), Innovation Networks � New Approaches in Modelling and Analyzing, Springer: Complexity, Heidelberg and New York, 101-126.

Gilbert, N., P. Ahrweiler and A. Pyka (2010): Learning in Innovation Networks: some Simulation Experiments. In P. Ahrweiler, (ed.) : Innovation in complex social systems. London: Routledge (Reprint from Physica A, 2007), pp. 235-249.

Scholz, R., T. Nokkala, P. Ahrweiler, A. Pyka and N. Gilbert (2010): The agent-based Nemo Model (SKEIN) � simulating European Framework Programmes. In P. Ahrweiler (ed.): Innovation in complex social systems. London: Routledge, pp. 300-314.

Ahrweiler, P., A. Pyka and N. Gilbert (forthcoming): A new Model for University-Industry Links in knowledge-based Economies. Journal of Product Innovation Management.

Ahrweiler, P., N. Gilbert and A. Pyka (2010): Agency and Structure. A social simulation of knowledge-intensive Industries. Computational and Mathematical Organization Theory (forthcoming).

## CREDITS

To cite the SKIN model please use the following acknowledgement:

Gilbert, Nigel, Ahrweiler, Petra and Pyka, Andreas (2010) The SKIN (Simulating Knowledge Dynamics in Innovation Networks) model.  University of Surrey, University College Dublin and University of Hohenheim.

Copyright 2003 - 2010 Nigel Gilbert, Petra Ahrweiler and Andreas Pyka. All rights reserved.

Permission to use, modify or redistribute this model is hereby granted, provided that both of the following requirements are followed: a) this copyright notice is included. b) this model will not be redistributed for profit without permission and c) the requirements of the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License <http://creativecommons.org/licenses/by-nc-sa/3.0/> are complied with.

The authors gratefully acknowldge funding during the course of development of the model from the European Commission, DAAD, and the British Council.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 151 152 137 77 105 67 89 67 66 74 48 85 36 100 24 116 14 134 0 151 15 167 22 182 40 206 58 220 82 226 105 226 134 222
Polygon -16777216 true false 151 150 149 128 149 114 155 98 178 80 197 80 217 81 233 95 242 117 246 141 247 151 245 177 234 195 218 207 206 211 184 211 161 204 151 189 148 171
Polygon -7500403 true true 246 151 241 119 240 96 250 81 261 78 275 87 282 103 277 115 287 121 299 150 286 180 277 189 283 197 281 210 270 222 256 222 243 212 242 192
Polygon -16777216 true false 115 70 129 74 128 223 114 224
Polygon -16777216 true false 89 67 74 71 74 224 89 225 89 67
Polygon -16777216 true false 43 91 31 106 31 195 45 211
Line -1 false 200 144 213 70
Line -1 false 213 70 213 45
Line -1 false 214 45 203 26
Line -1 false 204 26 185 22
Line -1 false 185 22 170 25
Line -1 false 169 26 159 37
Line -1 false 159 37 156 55
Line -1 false 157 55 199 143
Line -1 false 200 141 162 227
Line -1 false 162 227 163 241
Line -1 false 163 241 171 249
Line -1 false 171 249 190 254
Line -1 false 192 253 203 248
Line -1 false 205 249 218 235
Line -1 false 218 235 200 144

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

directed line
true
0
Line -7500403 true 150 0 150 300
Circle -7500403 true true 135 16 31

factory
true
0
Polygon -7500403 true true 1 152 2 296 299 296 299 3 264 3 265 91 152 2 2 119

line
true
0
Line -7500403 true 150 0 150 300

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
