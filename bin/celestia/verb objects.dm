

obj
	verbs
		Move_To
			//icon_state="gun1"
			desc="Moves all selected units in view to selected location"
			Click()
				usr:MoveTo()

		Attack
			//icon_state="armor"
			desc="All selected units in view will be ready to attack on sight"
			Click()
				usr:SetAttack()


