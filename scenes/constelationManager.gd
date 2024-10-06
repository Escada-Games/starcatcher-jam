extends Node2D

export(int) var iNumberOfStars := 0

func _ready() -> void:
	showOnlyObtainedStars()
	yield(get_tree().create_timer(1.0), 'timeout')
	drawLines()
#	var vLastStarPosition := Vector2()
#	var iCount := 1
#	var iMaxCount := get_child_count()
#
#	for n in get_children():
#		if n is SpriteConstellationStar:
#			if iCount > iNumberOfStars:
#				n.queue_free()
#				continue
#
#			if iCount == 1:
#				iCount += 1
#				vLastStarPosition = n.vTargetPosition
#				continue
#
#			if n.bFormsLine:
#				if iCount <= iMaxCount:
#					var l := Line2D.new()
#					l.width = 2
#					l.add_point(vLastStarPosition + Vector2(0,8))
#					l.add_point(n.vTargetPosition + Vector2(0,8))
#					$lines.add_child(l)
#
#			iCount += 1
#			vLastStarPosition = n.vTargetPosition

func showOnlyObtainedStars() -> void:
	var iCount := 0
	for n in get_children():
		if n is SpriteConstellationStar:
			iCount += 1
			if iCount > iNumberOfStars:
				n.queue_free()
				continue
			
func drawLines() -> void:
	var vLastStarPosition := Vector2()
	var iCount := 1
	var iMaxCount := iNumberOfStars#get_child_count()
	
	for n in get_children():
		if n is SpriteConstellationStar:
			if iCount == 1:
				iCount += 1
				vLastStarPosition = n.vTargetPosition
				continue
			
			if n.bFormsLine:
				if iCount <= iMaxCount:
					var l := Line2D.new()
					l.width = 2
					l.add_point(vLastStarPosition + Vector2(0,8))
					l.add_point(n.vTargetPosition + Vector2(0,8))
					$lines.add_child(l)
			
			yield(get_tree().create_timer(0.5), 'timeout')
			iCount += 1
			vLastStarPosition = n.vTargetPosition
