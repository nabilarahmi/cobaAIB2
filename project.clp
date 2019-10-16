
;;;======================================================
;;;   Project Decision Expert System
;;;
;;;     This expert system diagnoses some simple problems with project implementation
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))

(deftemplate state-list
   (slot current)
   (multislot sequence))

(deffacts startup
   (state-list))

;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>

  (assert (UI-state (display "Welcome to the Project Decision Expert System.")
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule our-business ""

   (logical (start))

   =>

   (assert (UI-state (display "Is your project your business?")
                     (relation-asserted business)
                     (response No)
                     (valid-answers No Yes))))

(defrule repeated-project ""

   (logical (business yes))

   =>

   (assert (UI-state (display "Is your project already done before?")
                     (relation-asserted repeat)
                     (response No)
                     (valid-answers No Yes))))

(defrule project-potential ""

   (logical (business no))

   =>

   (assert (UI-state (display "Is your project potetial for our business?")
                     (relation-asserted potential)
                     (response No)
                     (valid-answers No Yes))))

(defrule project-potential1 ""

    (logical (repeat no))

    =>

    (assert (UI-state (display "Is your project potetial for our business?")
                  (relation-asserted potential)
                  (response No)
                  (valid-answers No Yes))))

(defrule project-margin10 ""

   (logical (repeat yes))

   =>

   (assert (UI-state (display "Is your project have profit more than 10% margin?")
                    (relation-asserted project-margin)
                     (response No)
                     (valid-answers No Yes))))

(defrule resource1 ""

    (logical (project-margin yes))

    =>

    (assert (UI-state (display "Is there any human resource?")
                    (relation-asserted our.human)
                    (response No)
                    (valid-answers No Yes))))

(defrule project-margin5 ""

   (logical (potential yes))

   =>

   (assert (UI-state (display "Is your project have profit more than 5% margin?")
                     (relation-asserted project-margin5)
                     (response No)
                     (valid-answers No Yes))))

(defrule resource-exist ""

   (logical (project-margin5 yes))

   =>

   (assert (UI-state (display "Is there any human resource?")
       (relation-asserted our.human)
                     (response No)
                     (valid-answers No Yes))))

(defrule recruitment ""

    (logical (our.human no))

   =>

   (assert (UI-state (display "Could we get from recruitment?")
                     (relation-asserted recruitable)
                     (response No)
                     (valid-answers No Yes))))

(defrule qualified ""

    (logical (our.human yes))

   =>

   (assert (UI-state (display "Is our human trained qualified?")
                     (relation-asserted expertised)
                     (response No)
                     (valid-answers No Yes))))

(defrule  resource2""

    (logical (recruitable yes))

    =>

    (assert (UI-state (display "Do we have some resources")
                  (relation-asserted our-resource)
                  (response No)
                  (valid-answers No Yes))))

(defrule training ""

   (logical (expertised no))

   =>

   (assert (UI-state (display "Could our human  get some training?")
                     (relation-asserted trainable)
                     (response No)
                     (valid-answers No Yes))))

(defrule resource ""

   (logical (expertised yes))

   =>

   (assert (UI-state (display "Do we have some resources?")
                    (relation-asserted our-resource)
                     (response No)
                     (valid-answers No Yes))))

(defrule resource3 ""

    (logical (trainable yes))

    =>

    (assert (UI-state (display "Do we have some resources?")
                 (relation-asserted our-resource)
                  (response No)
                  (valid-answers No Yes))))


(defrule buy-resource ""

   (logical (our-resource no))

   =>

   (assert (UI-state (display "Could we buy the resources?")
                     (relation-asserted buyable)
                     (response No)
                     (valid-answers No Yes))))

(defrule quality1 ""

    (logical (buyable yes))

    =>

    (assert (UI-state (display "Is our resources in good condition?")
                  (relation-asserted quality)
                  (response No)
                  (valid-answers No Yes))))

(defrule resource-condition ""

   (logical (our-resource yes))

   =>

   (assert (UI-state (display "Is our resources in good condition?")
                     (relation-asserted quality)
                     (response No)
                     (valid-answers No Yes))))

(defrule repaired-resources ""

   (logical (quality no))

   =>

   (assert (UI-state (display "Could our resources be repaired?")
                     (relation-asserted repairable)
                     (response No)
                     (valid-answers No Yes))))

(defrule repaired-resources ""

    (logical (quality yes))

    =>

    (assert (UI-state (display "Is our financial in good condition?")
                  (relation-asserted money)
                  (response No)
                  (valid-answers No Yes))))


(defrule financial ""

   (logical (repairable yes))

   =>

   (assert (UI-state (display "Is our financial in good condition?")
                     (relation-asserted money)
                     (response No)
                     (valid-answers No Yes))))
   
(defrule not-repairable ""

   (logical (repairable no))

   =>

   (assert (UI-state (display "Could we buy the resources?")
                     (relation-asserted buyable)
                     (response No)
                     (valid-answers No Yes))))

(defrule risk ""

   (logical (money yes))

   =>

   (assert (UI-state (display "Do we have big risk?")
                     (relation-asserted big-risk)
                     (response No)
                     (valid-answers No Yes))))


(defrule removable-risk ""

   (logical (big-risk no))

   =>

   (assert (UI-state (display "Could we remove that risk?")
                     (relation-asserted removable)
                     (response No)
                     (valid-answers No Yes))))


(defrule mitigation ""

   (logical (big-risk yes))

   =>

   (assert (UI-state (display "Could we mitigate that risk?")
                     (relation-asserted mitigatable)
                     (response No)
                     (valid-answers No Yes))))

(defrule not-removable ""

    (logical (removable no))

    =>

    (assert (UI-state (display "Could we mitigate that risk?")
                  (relation-asserted mitigatable)
                  (response No)
                  (valid-answers No Yes))))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule not-mitigatable ""

   (logical (mitigatable no))

   =>

   (assert (UI-state (display "I think you must abort your project")
                     (state final))))

(defrule possible-mitigatable ""

   (logical (mitigatable yes))

   =>

   (assert (UI-state (display "I think you must do your project")
                     (state final))))

(defrule not-potential ""

    (logical (potential no))

    =>

    (assert (UI-state (display "I think you must abort your project")
                  (state final))))

(defrule not-profitable ""

    (logical (project-margin no))

    =>

    (assert (UI-state (display "I think you must abort your project")
              (state final))))

(defrule not-profitable1 ""

    (logical (project-margin5 no))

    =>

    (assert (UI-state (display "I think you must abort your project")
              (state final))))

(defrule not-recruitable ""

    (logical (recruitable no))

    =>

    (assert (UI-state (display "I think you must abort your project")
              (state final))))

(defrule not-buyable ""

    (logical (buyable no))

    =>

    (assert (UI-state (display "I think you must abort your project")
              (state final))))

(defrule not-enoughmoney ""

    (logical (money no))

    =>

    (assert (UI-state (display "I think you must abort your project")
              (state final))))

(defrule not-trainable ""

    (logical (trainable no))

    =>

    (assert (UI-state (display "I think you must abort your project")
            (state final))))

;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))

   (UI-state (id ?id))

   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))

   =>

   (modify ?f (current ?id)
              (sequence ?id ?s))

   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))

   =>

   (retract ?f1)

   (modify ?f2 (current ?nid))

   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))

   ?f <- (next ?id)

   (state-list (sequence ?id $?))

   (UI-state (id ?id)
             (relation-asserted ?relation))

   =>

   (retract ?f)

   (assert (add-response ?id)))

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))

   (UI-state (id ?id) (response ?response))

   =>

   (retract ?f1)

   (modify ?f2 (current ?nid))

   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))

   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))

   (UI-state (id ?id) (response ~?response))

   ?f2 <- (UI-state (id ?nid))

   =>

   (modify ?f1 (sequence ?b ?id ?e))

   (retract ?f2))

(defrule handle-next-response-end-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id ?response)

   (state-list (sequence ?id $?))

   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))

   =>

   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))

   (assert (add-response ?id ?response)))

(defrule handle-add-response

   (declare (salience 10))

   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))

   ?f1 <- (add-response ?id ?response)

   =>

   (str-assert (str-cat "(" ?relation " " ?response ")"))

   (retract ?f1))

(defrule handle-add-response-none

   (declare (salience 10))

   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))

   ?f1 <- (add-response ?id)

   =>

   (str-assert (str-cat "(" ?relation ")"))

   (retract ?f1))

(defrule handle-prev

   (declare (salience 10))

   ?f1 <- (prev ?id)

   ?f2 <- (state-list (sequence $?b ?id ?p $?e))

   =>

   (retract ?f1)

   (modify ?f2 (current ?p))

   (halt))



