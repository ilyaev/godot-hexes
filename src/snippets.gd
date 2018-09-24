# The real strength of using yield is when combined with signals. yield can accept two parameters,
    # - an object and a signal. When the signal is received, execution will recommence. Here are some examples:


# Resume execution the next frame.
yield(get_tree(), "idle_frame")

# Resume execution when animation is done playing.
yield(get_node("AnimationPlayer"), "finished")

# Wait 5 seconds, then resume execution.
yield(get_tree().create_timer(5.0), "timeout")

# Coroutines themselves use the completed signal when they transition into an invalid state, for example:

func my_func():
        yield(button_func(), "completed")
        print("All buttons were pressed, hurray!")

func button_func():
    yield($Button0, "pressed")
        yield($Button1, "pressed")


# create and run timer

var timer = Timer.new()
timer.set_one_shot(true)
timer.connect("timeout", self, "do_proceed", [score, timer])
timer.set_wait_time(1)
add_child(timer)
timer.start()