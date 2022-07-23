extends CanvasLayer

signal start_game
signal handle_submit_score
signal handle_mute_toggle
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubmitScore.hide()
	$PlayerName.hide()
	$HighscoresList.hide()
	$VirtualJoystick.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCardenas!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$Leaderboard.show()
	$PlayerName.show()
	$SubmitScore.show()
	$VirtualJoystick.hide()
	

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$Leaderboard.hide()
	$SubmitScore.hide()
	$PlayerName.hide()
	$HighscoresList.hide()
	$VirtualJoystick.show()
	emit_signal("start_game")


func _on_SubmitScore_pressed():
	$PlayerName.hide()
	$SubmitScore.hide()
	emit_signal("handle_submit_score")



func _on_Leaderboard_pressed():
	if($HighscoresList.is_visible_in_tree()):
		$HighscoresList.hide()
		$HighscoresList.clear()
	else:
		yield(SilentWolf.Scores.get_high_scores(5), "sw_scores_received")
		
		print("Scores: " + str(SilentWolf.Scores.scores))
		for score in SilentWolf.Scores.scores:
			$HighscoresList.add_item(str(int(score.score)) + " - " + score.player_name)

		$HighscoresList.show()



func _on_CheckBox_pressed():
	emit_signal("handle_mute_toggle")
