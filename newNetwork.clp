
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
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

  (assert (UI-state (display "Welcome to the Engine Diagnosis Expert System.")
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule adapter-existance ""

   (logical (start))

   =>

   (assert (UI-state (display "Does your computer has Wi-Fi adapter?")
                     (relation-asserted adapter-exist)
                     (response No)
                     (valid-answers No Yes))))

(defrule wireless-network-existance ""

   (logical (adapter-exist yes))

   =>

   (assert (UI-state (display "Is there a wireless network in the area?")
                     (relation-asserted wireless-network-exist)
                     (response No)
                     (valid-answers No Yes))))

(defrule adapter-on-or-off ""

   (logical (wireless-network-exist no))

   =>

   (assert (UI-state (display "Is your Wi-Fi adapter turned on?")
                     (relation-asserted adapter-on)
                     (response No)
                     (valid-answers No Yes))))

(defrule active-router-existance ""

   (logical (adapter-on yes))

   =>

   (assert (UI-state (display "Verify if there's router active in the area?")
                     (relation-asserted active-router-exist)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-home-network ""

   (logical (active-router-exist yes))

   =>

   (assert (UI-state (display "Is this network considerd a HOME network?")
                     (relation-asserted home-network)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-able-get-other-wifi ""

   (logical (home-network yes))

   =>

   (assert (UI-state (display "Is your device able to get other Wi-Fi networks?")
                     (relation-asserted able-get-other-wifi)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-support-5ghz ""

   (logical (able-get-other-wifi yes))

   =>

   (assert (UI-state (display "your device support 5 Ghz?")
                     (relation-asserted support-5ghz)
                     (response No)
                     (valid-answers No Yes))))

(defrule distance-from-router ""

   (logical (support-5ghz yes))

   =>

   (assert (UI-state (display "Are you close enogh to router?")
                     (relation-asserted near-from-router)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-login-problem ""

   (logical (wireless-network-exist yes))

   =>

   (assert (UI-state (display "Is it security login problem?")
                     (relation-asserted login-problem)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-ethernet-works ""

   (logical (login-problem no))

   =>

   (assert (UI-state (display "Works with ethernet?")
                     (relation-asserted ethernet-works)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-firewall-block ""

   (logical (ethernet-works no))

   =>

   (assert (UI-state (display "Blocked by firewall security?")
                     (relation-asserted firewall-block)
                     (response No)
                     (valid-answers No Yes))))

(defrule cable-condition ""

   (logical (firewall-block no))

   =>

   (assert (UI-state (display "Check if the cable are damaged or not connected properly?")
                     (relation-asserted cable-damaged)
                     (response No)
                     (valid-answers No Yes))))

(defrule wheter-internet-in-router ""

   (logical (cable-damaged no))

   =>

   (assert (UI-state (display "Is there's internet in the router?")
                     (relation-asserted internet-in-router)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-default-setting ""

   (logical (ethernet-works yes))

   =>

   (assert (UI-state (display "Is the router is one the default settings?")
                     (relation-asserted default-setting)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-intermmittent-connections ""

   (logical (default-setting yes))

   =>

   (assert (UI-state (display "Intermittent connections?")
                     (relation-asserted intermmittent-connections)
                     (response No)
                     (valid-answers No Yes))))


(defrule whether-compatible-device ""

   (logical (intermmittent-connections no))

   =>

   (assert (UI-state (display "Are you use compatible standards device?")
                     (relation-asserted compatible-device)
                     (response No)
                     (valid-answers No Yes))))

(defrule able-connect-public ""

   (logical (compatible-device yes))

   =>

   (assert (UI-state (display "Can you connect laptop to public networks?")
                     (relation-asserted connect-public)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-bluetooth ""

   (logical (intermmittent-connections yes))

   =>

   (assert (UI-state (display "Is there's interferer signal like Bluetooth device?")
                     (relation-asserted bluetooth)
                     (response No)
                     (valid-answers No Yes))))

(defrule whether-firmware-updated ""

   (logical (bluetooth no))

   =>

   (assert (UI-state (display "Is your router firmware updated?")
                     (relation-asserted firmware-updated)
                     (response No)
                     (valid-answers No Yes))))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule adapter-doesnt-exist ""

   (logical (adapter-exist no))

   =>

   (assert (UI-state (display "Please contact support to install one")
                     (state final))))

(defrule adapter-off ""

   (logical (adapter-on no))

   =>

   (assert (UI-state (display "Please turn on Wi-Fi adapter in settings")
                     (state final))))

(defrule active-router-doesnt-exist ""

   (logical (active-router-exist no))

   =>

   (assert (UI-state (display "Try to enable the router. The active LED should indicate the activity")
                     (state final))))

(defrule isnot-home-network ""

   (logical (home-network no))

   =>

   (assert (UI-state (display "Sometimes the corporate networks might be hidden. Ask the network admin for network settings")
                     (state final))))

(defrule cant-able-get-other-wifi ""

   (logical (able-get-other-wifi no))

   =>

   (assert (UI-state (display "Try to reinstall driver. If problem stays the same, try to use different connection software to connect")
                     (state final))))

(defrule cant-support-5ghz ""

   (logical (support-5ghz no))

   =>

   (assert (UI-state (display "Some Wi-Fi networks use the 5Ghz connection. Make sure your router is on the 2.4 GHz mode")
                     (state final))))

(defrule far-from-router ""

   (logical (near-from-router no))

   =>

   (assert (UI-state (display "You might be on the edge of the coverage area. Get closer to router")
                     (state final))))

(defrule no-far-from-router ""

   (logical (near-from-router yes))

   =>

   (assert (UI-state (display "The problem might be due to router failure or overheating. Try to reset the router to its factory condition Then run the manufacture's setup program to configure the router")
                     (state final))))

(defrule yes-login-problem ""

   (logical (login-problem yes))

   =>

   (assert (UI-state (display "Try to re-enter the encryption and password")
                     (state final))))

(defrule firewall-blocks ""

   (logical (firewall-block yes))

   =>

   (assert (UI-state (display "Make sure that the firewall setting allow you to access the internet or restore the default setting.")
                     (state final))))

(defrule cable-get-damaged ""

   (logical (cable-damaged yes))

   =>

   (assert (UI-state (display "Change the cable that provide the router with internet")
                     (state final))))

(defrule internet-in-router-exist ""

   (logical (internet-in-router yes))

   =>

   (assert (UI-state (display "Laptop hardware issue, go to laptop service center")
                     (state final))))

(defrule internet-in-router-doesnt-exist ""

   (logical (internet-in-router no))

   =>

   (assert (UI-state (display "Try to reboot the router. If nothing happens then it is ISP or Hardware failure. Ask ISP or buy new router")
                     (state final))))

(defrule no-defaults-setting ""

   (logical (defaults-setting no))

   =>

   (assert (UI-state (display "Try to reset the router to factory condition and run the manufacturer's setup program to configure the router")
                     (state final))))

(defrule connect-public-network ""

   (logical (connect-public yes))

   =>

   (assert (UI-state (display "Check router default set, no security or MAC addressing reboot router continued problem indicate wireless router failure or incompatibility")
                     (state final))))

(defrule cant-connect-public-network ""

   (logical (connect-public no))

   =>

   (assert (UI-state (display "Laptop wireless adapter fault, or OS software settings. Try latest driver software rescue")
                     (state final))))

(defrule not-compatible-device ""

   (logical (compatible-device no))

   =>

   (assert (UI-state (display "Try compatibility modes but be prepared to update old hardware")
                     (state final))))

(defrule bluetooth-existed ""

   (logical (bluetooth yes))

   =>

   (assert (UI-state (display "Try to change the laptop location by moving it away from the interference region")
                     (state final))))

(defrule firmware-isnot-updated""

   (logical (firmware-updated no))

   =>

   (assert (UI-state (display "Upgrade the router firmware to the latest version")
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

