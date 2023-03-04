extends GameScene

func set_arr_ally(data: Array) -> void:
    var ally = [
		{
			"name": "0",
		},
	]
    data_ally = ally
    for each in data_ally:
        create_entity(arrAlly, ub_ani_ally, each["name"], true)