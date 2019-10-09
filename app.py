from flask import Flask, render_template, jsonify, url_for, request
from clips import Environment

# Define the clips environment
clips = Environment()

# Load the Network Expert System
clips.load("newNetwork.clp")

# Define the app of web server
app = Flask(__name__)
boolAnswer = False

def changeUIState():
    # Get the state-list.
    factlist = clips.eval("(find-all-facts ((?f state-list)) TRUE)")
    if len(factlist) == 0:
        return jsonify(question="Error in the server, ask support to fix")
    currentID = factlist[0]["current"]
    print("currentID1 :", currentID)

    # Get the current UI state.
    factlist = clips.eval("(find-all-facts ((?f UI-state)) (eq ?f:id %s))" % currentID)
    if len(factlist) == 0:
        return jsonify(question="Error in the server, ask support to fix")

    # Determine the Next/Prev button states.
    state = factlist[0]["state"]
    if state == "final":
        buttonLabel = "Restart"

    elif state == "initial":
        buttonLabel = "Next"

    else:
        buttonLabel = "Next"

    # Set the label to the display text.
    theText = factlist[0]["display"]
    return jsonify(question=theText, button=buttonLabel)


@app.route('/')
def start():
    # Run clips Expert System
    clips.reset()
    clips.run()
    changeUIState()
    return render_template('index.html')


@app.route('/question', methods=['POST'])
def question():
    # Handle changes
    factlist = clips.eval("(find-all-facts ((?f state-list)) TRUE)")
    if len(factlist) == 0:
        return jsonify(question="Error in the server, ask support to fix")
    currentID = factlist[0]["current"]
    print("currentID2 :", currentID)

    if request.json['answer'] is None:
        clips.assert_string("(next %s)" % currentID)
    else:
        if request.json['answer'] == 1:
            clips.assert_string("(next %s yes)" % currentID)
        else:
            clips.assert_string("(next %s no)" % currentID)
            print("(next %s No)" % currentID)
    clips.run()
    return changeUIState()


@app.route('/reset')
def reset():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0')
